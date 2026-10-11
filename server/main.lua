QBCore = exports['qb-core']:GetCoreObject()
MZ = { Sessions = {} }

-- ─────────────────────────── Helpers ───────────────────────────

function MZ.GetPlayer(src)
    return exports['qb-core']:GetPlayer(src)
end

function MZ.Cid(src)
    local Player = MZ.GetPlayer(src)
    return Player and Player.PlayerData.citizenid, Player
end

function MZ.Notify(src, msg, kind)
    TriggerClientEvent('mezos-clothing:client:notify', src, msg, kind or 'info')
end

function MZ.IsAdmin(src)
    return QBCore.Functions.HasPermission(src, Config.AdminPermission) or IsPlayerAceAllowed(src, 'command')
end

function MZ.Debug(...)
    if Config.Debug then print('[mezos-clothing]', ...) end
end

-- Simple per-player rate limiter: returns true if allowed
local limits = {}
function MZ.RateLimit(src, key, seconds)
    limits[src] = limits[src] or {}
    local now = os.time()
    if limits[src][key] and now - limits[src][key] < seconds then return false, seconds - (now - limits[src][key]) end
    limits[src][key] = now
    return true
end

function MZ.DistanceTo(src, coords)
    local ped = GetPlayerPed(src)
    if ped == 0 then return math.huge end
    return #(GetEntityCoords(ped) - vector3(coords.x, coords.y, coords.z))
end

-- ─────────────────────────── Skins ───────────────────────────

-- Returns model (number), skin (normalized table) or nil when the character has no saved look
function MZ.LoadSkin(cid)
    local row = MySQL.single.await('SELECT model, skin FROM playerskins WHERE citizenid = ? AND active = 1 LIMIT 1', { cid })
    if not row then return nil end
    return tonumber(row.model) or row.model, Schema.Normalize(row.skin)
end

function MZ.SaveSkin(cid, model, skin)
    local encoded = type(skin) == 'string' and skin or json.encode(skin)
    MySQL.query.await('DELETE FROM playerskins WHERE citizenid = ?', { cid })
    MySQL.insert.await('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, 1)', { cid, tostring(model), encoded })
end

-- ─────────────────────────── Database bootstrap ───────────────────────────

local function columnExists(tbl, column)
    return MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?]], { tbl, column }) > 0
end

CreateThread(function()
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `playerskins` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(255) NOT NULL,
        `model` varchar(255) NOT NULL,
        `skin` text NOT NULL,
        `active` tinyint(2) NOT NULL DEFAULT 1,
        PRIMARY KEY (`id`), KEY `citizenid` (`citizenid`), KEY `active` (`active`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])

    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `player_outfits` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(50) DEFAULT NULL,
        `outfitname` varchar(50) NOT NULL,
        `model` varchar(50) DEFAULT NULL,
        `skin` text DEFAULT NULL,
        `outfitId` varchar(50) NOT NULL,
        PRIMARY KEY (`id`), KEY `citizenid` (`citizenid`), KEY `outfitId` (`outfitId`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])

    local extra = {
        { 'share_code', 'VARCHAR(16) NULL DEFAULT NULL' },
        { 'folder', "VARCHAR(32) NOT NULL DEFAULT ''" },
        { 'tags', "VARCHAR(128) NOT NULL DEFAULT ''" },
        { 'created_at', 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP' },
    }
    for _, col in ipairs(extra) do
        if not columnExists('player_outfits', col[1]) then
            MySQL.query.await(('ALTER TABLE `player_outfits` ADD COLUMN `%s` %s'):format(col[1], col[2]))
            if col[1] == 'share_code' then
                MySQL.query.await('ALTER TABLE `player_outfits` ADD UNIQUE KEY `share_code` (`share_code`)')
            end
        end
    end

    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `mezos_outfit_gallery` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(50) NOT NULL,
        `author` varchar(100) NOT NULL,
        `name` varchar(50) NOT NULL,
        `model` varchar(50) NOT NULL,
        `skin` text NOT NULL,
        `tags` varchar(128) NOT NULL DEFAULT '',
        `likes` int(11) NOT NULL DEFAULT 0,
        `uses` int(11) NOT NULL DEFAULT 0,
        `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`), KEY `model` (`model`), KEY `citizenid` (`citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])

    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `mezos_gallery_likes` (
        `gallery_id` int(11) NOT NULL,
        `citizenid` varchar(50) NOT NULL,
        PRIMARY KEY (`gallery_id`, `citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])

    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `mezos_outfitbags` (
        `bag_id` varchar(32) NOT NULL,
        `label` varchar(50) NOT NULL DEFAULT 'Outfit Bag',
        `outfits` longtext NOT NULL,
        `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`bag_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])

    MZ.Debug('database ready')
end)

-- ─────────────────────────── Sessions ───────────────────────────
-- A session is opened before any paid/free editing so the server knows what the
-- player is allowed to change and what their look was before (pricing baseline).

local function storeNear(src, index, kind)
    local store = Config.Stores[tonumber(index) or 0]
    if not store or store.type ~= kind then return false end
    return MZ.DistanceTo(src, store.coords) <= 15.0
end

local function roomAllowed(Player, room)
    if not room then return false end
    if room.isGang then return Player.PlayerData.gang.name == room.requiredJob end
    return Player.PlayerData.job.name == room.requiredJob
end
MZ.RoomAllowed = roomAllowed

QBCore.Functions.CreateCallback('mezos-clothing:server:openSession', function(src, cb, mode, ctx)
    ctx = type(ctx) == 'table' and ctx or {}
    local cid, Player = MZ.Cid(src)
    if not cid then return cb({ ok = false }) end

    local model, skin = MZ.LoadSkin(cid)
    local allowed = false

    if mode == 'clothing' or mode == 'barber' or mode == 'tattoo' or mode == 'surgeon' then
        allowed = storeNear(src, ctx.store, mode)
    elseif mode == 'wardrobe' then
        allowed = true -- wearing your own outfits is always free
    elseif mode == 'creator' then
        allowed = skin == nil or (MZ.Sessions[src] and MZ.Sessions[src].creatorGrant)
    elseif mode == 'admin' then
        allowed = MZ.IsAdmin(src) or (MZ.Sessions[src] and MZ.Sessions[src].adminGrant)
    end

    if not allowed then
        MZ.Debug(('denied session %s for %s'):format(tostring(mode), src))
        return cb({ ok = false, reason = 'denied' })
    end

    local jobOutfits
    if mode == 'wardrobe' and ctx.room then
        local room = Config.ClothingRooms[tonumber(ctx.room) or 0]
        if room and roomAllowed(Player, room) and MZ.DistanceTo(src, room.coords) <= 15.0 then
            jobOutfits = MZ.JobOutfitsFor(Player, room)
        end
    end

    local previous = MZ.Sessions[src] or {}
    MZ.Sessions[src] = {
        mode = mode, store = ctx.store, room = ctx.room, baseline = skin, model = model,
        creatorGrant = previous.creatorGrant, adminGrant = mode ~= 'admin' and previous.adminGrant or nil,
    }

    cb({
        ok = true,
        hasSkin = skin ~= nil,
        model = model,
        skin = skin,
        prices = (mode ~= 'creator' and mode ~= 'admin' and mode ~= 'wardrobe') and Config.Prices or nil,
        money = { cash = Player.PlayerData.money.cash, bank = Player.PlayerData.money.bank },
        jobOutfits = jobOutfits,
        isAdmin = MZ.IsAdmin(src),
        citizenid = cid,
    })
end)

-- Confirm the edited look. The server enforces which keys the mode may change and the price.
QBCore.Functions.CreateCallback('mezos-clothing:server:commit', function(src, cb, newSkin, newModel)
    local session = MZ.Sessions[src]
    local cid, Player = MZ.Cid(src)
    if not session or not cid or type(newSkin) ~= 'table' then return cb({ ok = false, reason = 'no_session' }) end

    local mode = session.mode
    local baseline = session.baseline or Schema.Default()
    local model = session.model or tonumber(newModel)
    local final

    if mode == 'creator' or mode == 'admin' then
        final = Schema.Normalize(newSkin)
        model = tonumber(newModel) or newModel or model
    elseif mode == 'wardrobe' then
        return cb({ ok = false, reason = 'readonly' })
    else
        -- without a saved look, keep the client's non-shop keys (face etc.) instead of wiping them
        local base = session.baseline and Schema.Copy(session.baseline) or Schema.Normalize(newSkin)
        final = Schema.Merge(base, Schema.Normalize(newSkin), Schema.ModeKeys[mode])
    end
    if not model then return cb({ ok = false, reason = 'no_model' }) end
    MZ.SanitizeTattoos(final)
    local fade = final['hair_fade']
    if fade and fade.name ~= '' and not MZ.IsKnownTattoo(fade) then final['hair_fade'] = { collection = '', name = '' } end

    local price, lines = 0, {}
    if mode ~= 'creator' and mode ~= 'admin' then
        price, lines = MZ.CalculatePrice(mode, baseline, final)
    end

    if price > 0 then
        local paid, account = MZ.Charge(Player, price, ('mezos-clothing %s'):format(mode))
        if not paid then return cb({ ok = false, reason = 'money', price = price }) end
        MZ.Notify(src, ('Paid $%s (%s)'):format(price, account), 'success')
    end

    MZ.SaveSkin(cid, model, final)
    session.baseline = final
    session.model = model
    if mode == 'creator' then session.creatorGrant = nil end
    cb({ ok = true, skin = final, model = model, price = price, lines = lines })
end)

RegisterNetEvent('mezos-clothing:server:closeSession', function()
    local src = source
    local s = MZ.Sessions[src]
    if s and s.mode ~= 'creator' then
        MZ.Sessions[src] = (s.creatorGrant or s.adminGrant) and { creatorGrant = s.creatorGrant, adminGrant = s.adminGrant } or nil
    end
end)

-- One-time permission for a player to open the full menu (granted by an admin)
function MZ.GrantAdminMenu(target)
    MZ.Sessions[target] = MZ.Sessions[target] or {}
    MZ.Sessions[target].adminGrant = true
end

-- Fetch the saved look (used on spawn and by /refreshskin)
QBCore.Functions.CreateCallback('mezos-clothing:server:getSkin', function(src, cb)
    local cid = MZ.Cid(src)
    if not cid then return cb(nil) end
    local model, skin = MZ.LoadSkin(cid)
    cb(skin and { model = model, skin = skin } or nil)
end)

-- Private routing bucket while a new character is in the creator studio
local previousBucket = {}
RegisterNetEvent('mezos-clothing:server:creatorBucket', function(enable)
    local src = source
    if enable then
        local cid = MZ.Cid(src)
        local granted = MZ.Sessions[src] and MZ.Sessions[src].creatorGrant
        if not cid or (not granted and MZ.LoadSkin(cid)) or previousBucket[src] then return end
        previousBucket[src] = GetPlayerRoutingBucket(src)
        SetPlayerRoutingBucket(src, 7000 + src)
    elseif previousBucket[src] then
        SetPlayerRoutingBucket(src, previousBucket[src])
        previousBucket[src] = nil
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    previousBucket[src] = nil
    MZ.Sessions[src] = nil
    limits[src] = nil
end)

-- Admin command: open the full appearance menu (self or target)
if Config.AdminCommand then
    QBCore.Commands.Add(Config.AdminCommand, 'Open the full appearance menu (admin)', { { name = 'id', help = 'Player ID (optional)' } }, false, function(src, args)
        local target = tonumber(args[1]) or src
        if not MZ.GetPlayer(target) then return MZ.Notify(src, 'Player not online', 'error') end
        MZ.GrantAdminMenu(target)
        TriggerClientEvent('mezos-clothing:client:openAdmin', target)
    end, 'admin')

    -- Send a player back through the character creator
    QBCore.Commands.Add('resetlook', 'Send a player back to the character creator (admin)', { { name = 'id', help = 'Player ID' } }, true, function(src, args)
        local target = tonumber(args[1])
        if not target or not MZ.GetPlayer(target) then return MZ.Notify(src, 'Player not online', 'error') end
        MZ.Sessions[target] = MZ.Sessions[target] or {}
        MZ.Sessions[target].creatorGrant = true
        TriggerClientEvent('qb-clothes:client:CreateFirstCharacter', target)
    end, 'admin')
end
