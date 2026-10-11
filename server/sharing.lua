-- Outfit sharing: send to nearby players and the public gallery.

local offers = {}       -- [offerId] = { from, to, outfit, expires }
local offerSeq = 0

local function charName(Player)
    local c = Player.PlayerData.charinfo or {}
    return ('%s %s'):format(c.firstname or 'Unknown', c.lastname or '')
end

-- ─────────────────────────── Send to nearby ───────────────────────────

QBCore.Functions.CreateCallback('mezos-clothing:server:nearbyPlayers', function(src, cb)
    local myPed = GetPlayerPed(src)
    if myPed == 0 then return cb({}) end
    local myPos = GetEntityCoords(myPed)
    local list = {}
    for _, id in ipairs(QBCore.Functions.GetPlayers()) do
        id = tonumber(id)
        if id ~= src then
            local ped = GetPlayerPed(id)
            if ped ~= 0 and #(GetEntityCoords(ped) - myPos) <= Config.SendOutfitDistance then
                local P = MZ.GetPlayer(id)
                if P then
                    local c = P.PlayerData.charinfo or {}
                    list[#list + 1] = { id = id, name = ('%s %s.'):format(c.firstname or '?', (c.lastname or ''):sub(1, 1)) }
                end
            end
        end
    end
    cb(list)
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:sendOutfit', function(src, cb, target, outfitId)
    target = tonumber(target)
    local cid, Player = MZ.Cid(src)
    local TargetPlayer = target and MZ.GetPlayer(target)
    if not cid or not TargetPlayer or target == src then return cb({ ok = false, reason = 'target' }) end

    local tPed, myPed = GetPlayerPed(target), GetPlayerPed(src)
    if #(GetEntityCoords(tPed) - GetEntityCoords(myPed)) > Config.SendOutfitDistance + 1.0 then
        return cb({ ok = false, reason = 'distance' })
    end
    local okRate, wait = MZ.RateLimit(src, 'send', Config.SendOutfitCooldown)
    if not okRate then return cb({ ok = false, reason = 'cooldown', wait = wait }) end

    local row = MySQL.single.await('SELECT * FROM player_outfits WHERE citizenid = ? AND outfitId = ? LIMIT 1', { cid, tostring(outfitId) })
    if not row then return cb({ ok = false, reason = 'not_found' }) end
    local outfit = MZ.DecodeOutfit(row)

    offerSeq = offerSeq + 1
    offers[offerSeq] = { from = src, to = target, outfit = outfit, expires = os.time() + 60 }
    TriggerClientEvent('mezos-clothing:client:outfitOffer', target, {
        offerId = offerSeq, from = charName(Player), name = outfit.name, model = outfit.model, skin = outfit.skin,
    })
    cb({ ok = true })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:respondOffer', function(src, cb, offerId, accept)
    local offer = offers[tonumber(offerId) or 0]
    if not offer or offer.to ~= src or offer.expires < os.time() then
        offers[tonumber(offerId) or 0] = nil
        return cb({ ok = false, reason = 'expired' })
    end
    offers[offerId] = nil
    if not accept then
        MZ.Notify(offer.from, 'Your outfit was declined', 'error')
        return cb({ ok = true })
    end
    if not MZ.ChargeImport(src) then return cb({ ok = false, reason = 'money' }) end
    local cid = MZ.Cid(src)
    local id, reason = MZ.InsertOutfit(cid, offer.outfit.name, offer.outfit.model, offer.outfit.skin, 'Gifts', offer.outfit.tags)
    if id then MZ.Notify(offer.from, ('"%s" was accepted'):format(offer.outfit.name), 'success') end
    cb({ ok = id ~= nil, reason = reason, outfits = MZ.GetOutfits(cid) })
end)

-- ─────────────────────────── Gallery ───────────────────────────

local function galleryRow(row, cid)
    return {
        id = row.id, name = row.name, author = row.author, mine = row.citizenid == cid,
        model = tonumber(row.model) or row.model, tags = row.tags, likes = row.likes, uses = row.uses,
        liked = row.liked == 1, skin = json.decode(row.skin), createdAt = row.created_at,
    }
end

QBCore.Functions.CreateCallback('mezos-clothing:server:galleryList', function(src, cb, query)
    if not Config.Gallery.enabled then return cb({ ok = false, reason = 'disabled' }) end
    query = type(query) == 'table' and query or {}
    local cid = MZ.Cid(src)
    local model = MZ.LoadSkin(cid)
    local page = math.max(0, math.floor(tonumber(query.page) or 0))
    local size = Config.Gallery.pageSize

    local where, params = { 'g.model = ?' }, { cid, tostring(model or '') }
    if query.mine then
        where[#where + 1] = 'g.citizenid = ?'
        params[#params + 1] = cid
    end
    local search = MZ.CleanText(query.search, 40)
    if search ~= '' then
        where[#where + 1] = '(g.name LIKE ? OR g.tags LIKE ? OR g.author LIKE ?)'
        local like = '%' .. search:gsub('[%%_]', '') .. '%'
        params[#params + 1] = like
        params[#params + 1] = like
        params[#params + 1] = like
    end

    local order = 'g.created_at DESC'
    if query.sort == 'top' then
        order = 'g.likes DESC, g.uses DESC'
    elseif query.sort == 'trending' then
        -- likes weighted by freshness
        order = '(g.likes * 2 + g.uses) / POW(TIMESTAMPDIFF(HOUR, g.created_at, NOW()) + 2, 1.3) DESC'
    end

    params[#params + 1] = size + 1
    params[#params + 1] = page * size
    local rows = MySQL.query.await(([[
        SELECT g.*, (SELECT 1 FROM mezos_gallery_likes l WHERE l.gallery_id = g.id AND l.citizenid = ?) AS liked
        FROM mezos_outfit_gallery g WHERE %s ORDER BY %s LIMIT ? OFFSET ?]]):format(table.concat(where, ' AND '), order), params) or {}

    local list = {}
    for i = 1, math.min(#rows, size) do list[i] = galleryRow(rows[i], cid) end
    cb({ ok = true, items = list, hasMore = #rows > size, page = page })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:galleryPublish', function(src, cb, outfitId, tags)
    if not Config.Gallery.enabled then return cb({ ok = false, reason = 'disabled' }) end
    local cid, Player = MZ.Cid(src)
    local okRate, wait = MZ.RateLimit(src, 'publish', Config.Gallery.publishCooldown)
    if not okRate then return cb({ ok = false, reason = 'cooldown', wait = wait }) end
    local count = MySQL.scalar.await('SELECT COUNT(*) FROM mezos_outfit_gallery WHERE citizenid = ?', { cid })
    if count >= Config.Gallery.maxPostsPerPlayer then return cb({ ok = false, reason = 'limit' }) end

    local row = MySQL.single.await('SELECT * FROM player_outfits WHERE citizenid = ? AND outfitId = ? LIMIT 1', { cid, tostring(outfitId) })
    if not row then return cb({ ok = false, reason = 'not_found' }) end
    local outfit = MZ.DecodeOutfit(row)
    MySQL.insert.await('INSERT INTO mezos_outfit_gallery (citizenid, author, name, model, skin, tags) VALUES (?, ?, ?, ?, ?, ?)', {
        cid, charName(Player), outfit.name, tostring(outfit.model), json.encode(outfit.skin), MZ.CleanText(tags or outfit.tags, 128),
    })
    cb({ ok = true })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:galleryLike', function(src, cb, id)
    id = tonumber(id)
    local cid = MZ.Cid(src)
    if not id or not MZ.RateLimit(src, 'like', 0.5) then return cb({ ok = false }) end
    local liked = MySQL.scalar.await('SELECT 1 FROM mezos_gallery_likes WHERE gallery_id = ? AND citizenid = ?', { id, cid })
    if liked then
        MySQL.query.await('DELETE FROM mezos_gallery_likes WHERE gallery_id = ? AND citizenid = ?', { id, cid })
        MySQL.update.await('UPDATE mezos_outfit_gallery SET likes = GREATEST(likes - 1, 0) WHERE id = ?', { id })
    else
        MySQL.insert.await('INSERT IGNORE INTO mezos_gallery_likes (gallery_id, citizenid) VALUES (?, ?)', { id, cid })
        MySQL.update.await('UPDATE mezos_outfit_gallery SET likes = likes + 1 WHERE id = ?', { id })
    end
    local likes = MySQL.scalar.await('SELECT likes FROM mezos_outfit_gallery WHERE id = ?', { id })
    cb({ ok = true, liked = not liked, likes = likes or 0 })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:gallerySave', function(src, cb, id)
    local cid = MZ.Cid(src)
    local row = MySQL.single.await('SELECT * FROM mezos_outfit_gallery WHERE id = ?', { tonumber(id) })
    if not row then return cb({ ok = false, reason = 'not_found' }) end
    if not MZ.ChargeImport(src) then return cb({ ok = false, reason = 'money' }) end
    local newId, reason = MZ.InsertOutfit(cid, row.name, row.model, json.decode(row.skin), 'Gallery', row.tags)
    if newId then MySQL.update.await('UPDATE mezos_outfit_gallery SET uses = uses + 1 WHERE id = ?', { row.id }) end
    cb({ ok = newId ~= nil, reason = reason, outfits = MZ.GetOutfits(cid) })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:galleryDelete', function(src, cb, id)
    local cid = MZ.Cid(src)
    id = tonumber(id)
    local owner = MySQL.scalar.await('SELECT citizenid FROM mezos_outfit_gallery WHERE id = ?', { id })
    if not owner then return cb({ ok = false }) end
    if owner ~= cid and not MZ.IsAdmin(src) then return cb({ ok = false, reason = 'denied' }) end
    MySQL.query.await('DELETE FROM mezos_outfit_gallery WHERE id = ?', { id })
    MySQL.query.await('DELETE FROM mezos_gallery_likes WHERE gallery_id = ?', { id })
    cb({ ok = true })
end)

-- Expire stale offers
CreateThread(function()
    while true do
        Wait(30000)
        local now = os.time()
        for id, o in pairs(offers) do
            if o.expires < now then offers[id] = nil end
        end
    end
end)
