-- Legacy qb-clothing / qb-clothes server API, so other resources keep working.

local function sendSkin(src)
    local cid = MZ.Cid(src)
    if not cid then return end
    local model, skin = MZ.LoadSkin(cid)
    if skin then
        TriggerClientEvent('qb-clothes:loadSkin', src, false, model, json.encode(skin))
    else
        TriggerClientEvent('qb-clothes:loadSkin', src, true)
    end
end

RegisterNetEvent('qb-clothes:loadPlayerSkin', function() sendSkin(source) end)
RegisterNetEvent('qb-clothing:loadPlayerSkin', function() sendSkin(source) end) -- was missing in qb-clothing

-- Client-supplied skins are only accepted where the player may freely edit (creator/admin)
-- or when the character has no look yet.
RegisterNetEvent('qb-clothing:saveSkin', function(model, skin)
    local src = source
    local cid = MZ.Cid(src)
    if not cid or not model or not skin then return end
    local session = MZ.Sessions[src]
    local free = session and (session.mode == 'creator' or session.mode == 'admin')
    if not free and MZ.LoadSkin(cid) then
        MZ.Debug(('ignored legacy saveSkin from %s'):format(src))
        return
    end
    local normalized = MZ.SanitizeTattoos(Schema.Normalize(skin))
    MZ.SaveSkin(cid, model, normalized)
end)

local function legacyRows(cid)
    local rows = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { cid }) or {}
    for _, row in ipairs(rows) do
        row.skin = type(row.skin) == 'string' and json.decode(row.skin) or row.skin
    end
    return rows
end

-- Saves the character's current saved look (client skin data is ignored for safety)
RegisterNetEvent('qb-clothes:saveOutfit', function(outfitName)
    local src = source
    local cid = MZ.Cid(src)
    if not cid then return end
    local model, skin = MZ.LoadSkin(cid)
    if not skin then return end
    MZ.InsertOutfit(cid, outfitName, model, skin)
    TriggerClientEvent('qb-clothing:client:reloadOutfits', src, legacyRows(cid))
end)

RegisterNetEvent('qb-clothing:server:removeOutfit', function(outfitName, outfitId)
    local src = source
    local cid = MZ.Cid(src)
    if not cid then return end
    MySQL.query.await('DELETE FROM player_outfits WHERE citizenid = ? AND outfitId = ?', { cid, tostring(outfitId) })
    TriggerClientEvent('qb-clothing:client:reloadOutfits', src, legacyRows(cid))
end)

QBCore.Functions.CreateCallback('qb-clothing:server:getOutfits', function(src, cb)
    local cid = MZ.Cid(src)
    cb(cid and legacyRows(cid) or {})
end)

-- qb-adminmenu "Clothing" button: allow the target to open the full menu once
RegisterNetEvent('qb-admin:server:cloth', function(player)
    local src = source
    if type(player) ~= 'table' or not player.id then return end
    if QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        MZ.GrantAdminMenu(tonumber(player.id))
    end
end)

-- Server exports
exports('GetSkin', function(src)
    local cid = MZ.Cid(src)
    if not cid then return nil end
    local model, skin = MZ.LoadSkin(cid)
    return skin, model
end)
exports('GetOutfits', function(src)
    local cid = MZ.Cid(src)
    return cid and MZ.GetOutfits(cid) or {}
end)
