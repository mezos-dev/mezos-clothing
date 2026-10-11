-- Wardrobe: personal outfits, wearing outfits, job uniforms, share codes.

local CHARSET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'

local function randomString(len)
    local out = {}
    for i = 1, len do
        local n = math.random(1, #CHARSET)
        out[i] = CHARSET:sub(n, n)
    end
    return table.concat(out)
end

local function cleanText(text, max)
    text = tostring(text or ''):gsub('[%c<>]', ''):gsub('^%s+', ''):gsub('%s+$', '')
    return text:sub(1, max or Config.MaxOutfitNameLength)
end
MZ.CleanText = cleanText

local function newOutfitId()
    return 'mz-' .. randomString(10):lower()
end

function MZ.NewShareCode()
    for _ = 1, 20 do
        local code = ('%s-%s'):format(Config.ShareCodePrefix, randomString(5))
        local taken = MySQL.scalar.await('SELECT 1 FROM player_outfits WHERE share_code = ? LIMIT 1', { code })
        if not taken then return code end
    end
end

local function decodeOutfit(row)
    local skin = type(row.skin) == 'string' and json.decode(row.skin) or row.skin or {}
    return {
        id = row.outfitId,
        name = row.outfitname,
        model = tonumber(row.model) or row.model,
        skin = Schema.ExtractOutfit(Schema.Normalize(skin)),
        shareCode = row.share_code,
        folder = row.folder or '',
        tags = row.tags or '',
        createdAt = row.created_at,
    }
end
MZ.DecodeOutfit = decodeOutfit

function MZ.GetOutfits(cid)
    local rows = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ? ORDER BY id DESC', { cid }) or {}
    local list = {}
    for i, row in ipairs(rows) do list[i] = decodeOutfit(row) end
    return list
end

local function getOwned(cid, outfitId)
    local row = MySQL.single.await('SELECT * FROM player_outfits WHERE citizenid = ? AND outfitId = ? LIMIT 1', { cid, tostring(outfitId) })
    return row and decodeOutfit(row)
end

-- Insert an outfit for a character. Returns outfit id or nil, reason
function MZ.InsertOutfit(cid, name, model, outfitSkin, folder, tags)
    local count = MySQL.scalar.await('SELECT COUNT(*) FROM player_outfits WHERE citizenid = ?', { cid })
    if count >= Config.MaxOutfits then return nil, 'limit' end
    local id = newOutfitId()
    MySQL.insert.await('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId, folder, tags) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        cid, cleanText(name) ~= '' and cleanText(name) or 'Outfit', tostring(model), json.encode(Schema.ExtractOutfit(outfitSkin)), id,
        cleanText(folder, 32), cleanText(tags, 128),
    })
    return id
end

-- ─────────────────────────── Job outfits ───────────────────────────

function MZ.JobOutfitsFor(Player, room)
    local jobData = Config.Outfits[room.requiredJob]
    if not jobData then return nil end
    local gender = Player.PlayerData.charinfo.gender == 1 and 'female' or 'male'
    local byGrade = jobData[gender]
    if not byGrade then return nil end
    local grade = room.isGang and Player.PlayerData.gang.grade.level or Player.PlayerData.job.grade.level
    grade = tonumber(grade) or 0
    -- exact grade, otherwise the highest configured grade below it
    local list = byGrade[grade]
    if not list then
        local best
        for g in pairs(byGrade) do
            if g <= grade and (not best or g > best) then best = g end
        end
        list = best and byGrade[best]
    end
    if not list then return nil end
    local out = {}
    for i, o in ipairs(list) do
        out[i] = { index = i, name = o.outfitLabel, skin = Schema.ExtractOutfit(Schema.Normalize(o.outfitData)) }
    end
    return out
end

-- ─────────────────────────── Wearing ───────────────────────────

-- Apply an outfit's clothing onto the saved skin and persist it
local function wear(src, outfitSkin, outfitModel)
    local cid = MZ.Cid(src)
    local model, skin = MZ.LoadSkin(cid)
    if not skin then return { ok = false, reason = 'no_skin' } end
    if outfitModel and tonumber(outfitModel) and tonumber(model) and tonumber(outfitModel) ~= tonumber(model) then
        return { ok = false, reason = 'wrong_model' }
    end
    for key in pairs(Schema.ClothingSet) do
        if outfitSkin[key] then
            skin[key] = { item = tonumber(outfitSkin[key].item) or 0, texture = tonumber(outfitSkin[key].texture) or 0 }
        end
    end
    MZ.SaveSkin(cid, model, skin)
    -- keep an open store session in sync so wearing an owned outfit is never charged
    if MZ.Sessions[src] then MZ.Sessions[src].baseline = skin end
    return { ok = true, skin = skin, model = model }
end
MZ.WearOutfitSkin = wear

QBCore.Functions.CreateCallback('mezos-clothing:server:wearOutfit', function(src, cb, spec)
    spec = type(spec) == 'table' and spec or {}
    local cid, Player = MZ.Cid(src)
    if not cid then return cb({ ok = false }) end

    if spec.type == 'outfit' then
        local outfit = getOwned(cid, spec.id)
        if not outfit then return cb({ ok = false, reason = 'not_found' }) end
        return cb(wear(src, outfit.skin, outfit.model))
    elseif spec.type == 'job' then
        local session = MZ.Sessions[src]
        local room = session and Config.ClothingRooms[tonumber(session.room) or 0]
        if not room or not MZ.RoomAllowed(Player, room) then return cb({ ok = false, reason = 'denied' }) end
        local list = MZ.JobOutfitsFor(Player, room)
        local outfit = list and list[tonumber(spec.index) or 0]
        if not outfit then return cb({ ok = false, reason = 'not_found' }) end
        return cb(wear(src, outfit.skin))
    elseif spec.type == 'bag' then
        local outfit = MZ.GetBagOutfit(src, spec.bagId, spec.index)
        if not outfit then return cb({ ok = false, reason = 'not_found' }) end
        return cb(wear(src, outfit.skin, outfit.model))
    end
    cb({ ok = false })
end)

-- ─────────────────────────── CRUD ───────────────────────────

QBCore.Functions.CreateCallback('mezos-clothing:server:getOutfits', function(src, cb)
    local cid = MZ.Cid(src)
    cb(cid and MZ.GetOutfits(cid) or {})
end)

-- Saves what the character is currently wearing (from the database, never from the client)
QBCore.Functions.CreateCallback('mezos-clothing:server:saveOutfit', function(src, cb, data)
    data = type(data) == 'table' and data or {}
    local cid = MZ.Cid(src)
    local model, skin = MZ.LoadSkin(cid)
    if not skin then return cb({ ok = false, reason = 'no_skin' }) end
    local id, reason = MZ.InsertOutfit(cid, data.name, model, skin, data.folder, data.tags)
    if not id then return cb({ ok = false, reason = reason }) end
    cb({ ok = true, id = id, outfits = MZ.GetOutfits(cid) })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:updateOutfit', function(src, cb, outfitId)
    local cid = MZ.Cid(src)
    local model, skin = MZ.LoadSkin(cid)
    if not skin or not getOwned(cid, outfitId) then return cb({ ok = false }) end
    MySQL.update.await('UPDATE player_outfits SET skin = ?, model = ? WHERE citizenid = ? AND outfitId = ?', {
        json.encode(Schema.ExtractOutfit(skin)), tostring(model), cid, tostring(outfitId),
    })
    cb({ ok = true, outfits = MZ.GetOutfits(cid) })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:editOutfitInfo', function(src, cb, outfitId, data)
    data = type(data) == 'table' and data or {}
    local cid = MZ.Cid(src)
    local name = cleanText(data.name)
    if name == '' then return cb({ ok = false, reason = 'name' }) end
    MySQL.update.await('UPDATE player_outfits SET outfitname = ?, folder = ?, tags = ? WHERE citizenid = ? AND outfitId = ?', {
        name, cleanText(data.folder, 32), cleanText(data.tags, 128), cid, tostring(outfitId),
    })
    cb({ ok = true, outfits = MZ.GetOutfits(cid) })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:deleteOutfit', function(src, cb, outfitId)
    local cid = MZ.Cid(src)
    MySQL.query.await('DELETE FROM player_outfits WHERE citizenid = ? AND outfitId = ?', { cid, tostring(outfitId) })
    cb({ ok = true, outfits = MZ.GetOutfits(cid) })
end)

QBCore.Functions.CreateCallback('mezos-clothing:server:duplicateOutfit', function(src, cb, outfitId)
    local cid = MZ.Cid(src)
    local outfit = getOwned(cid, outfitId)
    if not outfit then return cb({ ok = false }) end
    local id, reason = MZ.InsertOutfit(cid, outfit.name .. ' (copy)', outfit.model, outfit.skin, outfit.folder, outfit.tags)
    cb({ ok = id ~= nil, reason = reason, outfits = MZ.GetOutfits(cid) })
end)

-- ─────────────────────────── Share codes ───────────────────────────

QBCore.Functions.CreateCallback('mezos-clothing:server:getShareCode', function(src, cb, outfitId)
    local cid = MZ.Cid(src)
    local outfit = getOwned(cid, outfitId)
    if not outfit then return cb({ ok = false }) end
    if outfit.shareCode and outfit.shareCode ~= '' then return cb({ ok = true, code = outfit.shareCode }) end
    local code = MZ.NewShareCode()
    if not code then return cb({ ok = false }) end
    MySQL.update.await('UPDATE player_outfits SET share_code = ? WHERE citizenid = ? AND outfitId = ?', { code, cid, tostring(outfitId) })
    cb({ ok = true, code = code, outfits = MZ.GetOutfits(cid) })
end)

local function findByCode(code)
    code = tostring(code or ''):upper():gsub('%s', '')
    if not code:find('-') then code = Config.ShareCodePrefix .. '-' .. code end
    local row = MySQL.single.await('SELECT * FROM player_outfits WHERE share_code = ? LIMIT 1', { code })
    return row and decodeOutfit(row)
end

QBCore.Functions.CreateCallback('mezos-clothing:server:previewCode', function(src, cb, code)
    if not MZ.RateLimit(src, 'code', 1) then return cb({ ok = false, reason = 'slow' }) end
    local outfit = findByCode(code)
    if not outfit then return cb({ ok = false, reason = 'not_found' }) end
    cb({ ok = true, outfit = { name = outfit.name, model = outfit.model, skin = outfit.skin } })
end)

-- Charge the import fee (if any). Returns ok
function MZ.ChargeImport(src)
    local fee = tonumber(Config.Prices.importOutfit) or 0
    if fee <= 0 then return true end
    local _, Player = MZ.Cid(src)
    local ok = MZ.Charge(Player, fee, 'mezos-clothing outfit import')
    if not ok then MZ.Notify(src, ('You need $%s to save this outfit'):format(fee), 'error') end
    return ok
end

QBCore.Functions.CreateCallback('mezos-clothing:server:importCode', function(src, cb, code, name)
    local cid = MZ.Cid(src)
    local outfit = findByCode(code)
    if not outfit then return cb({ ok = false, reason = 'not_found' }) end
    if not MZ.ChargeImport(src) then return cb({ ok = false, reason = 'money' }) end
    local id, reason = MZ.InsertOutfit(cid, name ~= nil and name ~= '' and name or outfit.name, outfit.model, outfit.skin, 'Imported', outfit.tags)
    cb({ ok = id ~= nil, reason = reason, outfits = MZ.GetOutfits(cid) })
end)
