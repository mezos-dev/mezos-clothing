-- Outfit bag: an inventory item that carries its own outfits.
-- The outfits live in mezos_outfitbags keyed by the item's info.bagId, so whoever
-- holds the bag (e.g. after it was given via the inventory) can use them.

local BAG = Config.OutfitBag.item

local function newBagId()
    return ('bag-%s%04d'):format(os.time(), math.random(0, 9999))
end

local function findBag(src, bagId)
    local Player = MZ.GetPlayer(src)
    if not Player or not bagId then return nil end
    for _, item in pairs(Player.PlayerData.items or {}) do
        if item and item.name == BAG and item.info and item.info.bagId == bagId then return item end
    end
end

local function loadBag(bagId)
    local row = MySQL.single.await('SELECT * FROM mezos_outfitbags WHERE bag_id = ?', { bagId })
    if not row then return { label = 'Outfit Bag', outfits = {} } end
    return { label = row.label, outfits = json.decode(row.outfits) or {} }
end

local function saveBag(bagId, bag)
    MySQL.query.await([[INSERT INTO mezos_outfitbags (bag_id, label, outfits) VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE label = VALUES(label), outfits = VALUES(outfits)]], { bagId, bag.label, json.encode(bag.outfits) })
end

function MZ.GetBagOutfit(src, bagId, index)
    if not findBag(src, bagId) then return nil end
    return loadBag(bagId).outfits[tonumber(index) or 0]
end

QBCore.Functions.CreateUseableItem(BAG, function(source, item)
    local src = source
    local info = type(item.info) == 'table' and item.info or {}
    if not info.bagId then
        info.bagId = newBagId()
        info.label = info.label or 'Outfit Bag'
        exports['qb-inventory']:SetItemData(src, BAG, 'info', info, item.slot)
        saveBag(info.bagId, { label = info.label, outfits = {} })
    end
    TriggerClientEvent('mezos-clothing:client:useBag', src, info.bagId)
end)

-- Every bag action re-checks that the player is holding that exact bag
local function withBag(handler)
    return function(src, cb, bagId, ...)
        if not findBag(src, bagId) then return cb({ ok = false, reason = 'no_bag' }) end
        local bag = loadBag(bagId)
        return handler(src, cb, bagId, bag, ...)
    end
end

local function reply(cb, bag, extra)
    local out = { ok = true, label = bag.label, outfits = bag.outfits, max = Config.OutfitBag.maxOutfits }
    for k, v in pairs(extra or {}) do out[k] = v end
    cb(out)
end

QBCore.Functions.CreateCallback('mezos-clothing:server:bagGet', withBag(function(src, cb, bagId, bag)
    local cid = MZ.Cid(src)
    reply(cb, bag, { wardrobe = MZ.GetOutfits(cid) })
end))

-- Put what you are wearing into the bag
QBCore.Functions.CreateCallback('mezos-clothing:server:bagAddCurrent', withBag(function(src, cb, bagId, bag, name)
    if #bag.outfits >= Config.OutfitBag.maxOutfits then return cb({ ok = false, reason = 'full' }) end
    local model, skin = MZ.LoadSkin(MZ.Cid(src))
    if not skin then return cb({ ok = false, reason = 'no_skin' }) end
    local label = MZ.CleanText(name)
    bag.outfits[#bag.outfits + 1] = { name = label ~= '' and label or ('Outfit %d'):format(#bag.outfits + 1), model = model, skin = Schema.ExtractOutfit(skin) }
    saveBag(bagId, bag)
    reply(cb, bag)
end))

-- Copy a wardrobe outfit into the bag
QBCore.Functions.CreateCallback('mezos-clothing:server:bagAddFromWardrobe', withBag(function(src, cb, bagId, bag, outfitId)
    if #bag.outfits >= Config.OutfitBag.maxOutfits then return cb({ ok = false, reason = 'full' }) end
    local row = MySQL.single.await('SELECT * FROM player_outfits WHERE citizenid = ? AND outfitId = ?', { MZ.Cid(src), tostring(outfitId) })
    if not row then return cb({ ok = false, reason = 'not_found' }) end
    local o = MZ.DecodeOutfit(row)
    bag.outfits[#bag.outfits + 1] = { name = o.name, model = o.model, skin = o.skin }
    saveBag(bagId, bag)
    reply(cb, bag)
end))

-- Copy a bag outfit into your wardrobe
QBCore.Functions.CreateCallback('mezos-clothing:server:bagToWardrobe', withBag(function(src, cb, bagId, bag, index)
    local o = bag.outfits[tonumber(index) or 0]
    if not o then return cb({ ok = false, reason = 'not_found' }) end
    local id, reason = MZ.InsertOutfit(MZ.Cid(src), o.name, o.model, o.skin, 'Outfit Bag', '')
    if not id then return cb({ ok = false, reason = reason }) end
    reply(cb, bag)
end))

QBCore.Functions.CreateCallback('mezos-clothing:server:bagRemove', withBag(function(src, cb, bagId, bag, index)
    index = tonumber(index) or 0
    if not bag.outfits[index] then return cb({ ok = false }) end
    table.remove(bag.outfits, index)
    saveBag(bagId, bag)
    reply(cb, bag)
end))

QBCore.Functions.CreateCallback('mezos-clothing:server:bagRenameOutfit', withBag(function(src, cb, bagId, bag, index, name)
    local o = bag.outfits[tonumber(index) or 0]
    local label = MZ.CleanText(name)
    if not o or label == '' then return cb({ ok = false }) end
    o.name = label
    saveBag(bagId, bag)
    reply(cb, bag)
end))

QBCore.Functions.CreateCallback('mezos-clothing:server:bagRename', withBag(function(src, cb, bagId, bag, label)
    label = MZ.CleanText(label, 30)
    if label == '' then return cb({ ok = false }) end
    bag.label = label
    saveBag(bagId, bag)
    local item = findBag(src, bagId)
    local info = item.info
    info.label = label
    exports['qb-inventory']:SetItemData(src, BAG, 'info', info, item.slot)
    reply(cb, bag)
end))

-- Buy an empty bag at a clothing store
QBCore.Functions.CreateCallback('mezos-clothing:server:buyBag', function(src, cb)
    local session = MZ.Sessions[src]
    local _, Player = MZ.Cid(src)
    if not Config.OutfitBag.soldInClothingStores or not session or session.mode ~= 'clothing' then return cb({ ok = false, reason = 'denied' }) end
    if not exports['qb-inventory']:CanAddItem(src, BAG, 1) then return cb({ ok = false, reason = 'inventory' }) end
    local ok = MZ.Charge(Player, Config.Prices.outfitBag, 'mezos-clothing outfit bag')
    if not ok then return cb({ ok = false, reason = 'money', price = Config.Prices.outfitBag }) end
    local info = { bagId = newBagId(), label = 'Outfit Bag' }
    saveBag(info.bagId, { label = info.label, outfits = {} })
    exports['qb-inventory']:AddItem(src, BAG, 1, false, info, 'mezos-clothing purchase')
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[BAG], 'add')
    cb({ ok = true })
end)
