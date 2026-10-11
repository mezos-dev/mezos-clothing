-- Store zones, blips and interaction (PolyZone + holo prompt, or qb-target).

local Labels = {
    clothing = { title = 'Clothing Store', action = 'Browse clothes', icon = 'fas fa-shirt' },
    barber   = { title = 'Barber Shop', action = 'Get a haircut', icon = 'fas fa-scissors' },
    tattoo   = { title = 'Tattoo Parlor', action = 'Get inked', icon = 'fas fa-pen-nib' },
    surgeon  = { title = 'Plastic Surgeon', action = 'Reshape your face', icon = 'fas fa-user-doctor' },
    changer  = { title = 'Changing Room', action = 'Open wardrobe', icon = 'fas fa-door-closed' },
    room     = { title = 'Locker Room', action = 'Open locker', icon = 'fas fa-user-shield' },
}

local function canUseRoom(room)
    local pd = Client.PlayerData()
    if room.isGang then return pd.gang and pd.gang.name == room.requiredJob end
    return pd.job and pd.job.name == room.requiredJob
end

local function interact(data)
    if data.kind == 'store' then
        local store = Config.Stores[data.index]
        Client.Open(store.type, { store = data.index, label = Labels[store.type].title })
    elseif data.kind == 'changer' then
        Client.Open('wardrobe', { label = Labels.changer.title })
    elseif data.kind == 'room' then
        Client.Open('wardrobe', { room = data.index, label = Labels.room.title })
    end
end

local function labelFor(data)
    if data.kind == 'store' then return Labels[Config.Stores[data.index].type] end
    return Labels[data.kind]
end

-- ─────────────────────────── Blips ───────────────────────────

CreateThread(function()
    for _, store in ipairs(Config.Stores) do
        local b = Config.Blips[store.type]
        if b and store.blip ~= false then
            local blip = AddBlipForCoord(store.coords.x, store.coords.y, store.coords.z)
            SetBlipSprite(blip, b.sprite)
            SetBlipColour(blip, b.color)
            SetBlipScale(blip, b.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(b.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- ─────────────────────────── Zones ───────────────────────────

local function allPoints()
    local points = {}
    local d = Config.StoreDefaults
    for i, store in ipairs(Config.Stores) do
        points[#points + 1] = { coords = store.coords, length = store.length or d.length, width = store.width or d.width, data = { kind = 'store', index = i } }
    end
    for i, coords in ipairs(Config.OutfitChangers) do
        points[#points + 1] = { coords = coords, length = d.length, width = d.width, data = { kind = 'changer', index = i } }
    end
    for i, room in ipairs(Config.ClothingRooms) do
        points[#points + 1] = { coords = room.coords, length = d.length, width = d.width, data = { kind = 'room', index = i }, room = room }
    end
    return points
end

local function setupTarget()
    for i, p in ipairs(allPoints()) do
        local label = labelFor(p.data)
        local option = { type = 'client', icon = label.icon, label = label.action, action = function() interact(p.data) end }
        if p.room then
            option.canInteract = function() return canUseRoom(p.room) end
        end
        exports['qb-target']:AddBoxZone('mezos_clothing_' .. i, vector3(p.coords.x, p.coords.y, p.coords.z), p.length, p.width, {
            name = 'mezos_clothing_' .. i, heading = 0, debugPoly = Config.Debug,
            minZ = p.coords.z + Config.StoreDefaults.minZ, maxZ = p.coords.z + Config.StoreDefaults.maxZ,
        }, { options = { option }, distance = Config.InteractDistance + 0.5 })
    end
end

local current
local function setupPolyZone()
    local zones = {}
    for _, p in ipairs(allPoints()) do
        local zone = BoxZone:Create(vector3(p.coords.x, p.coords.y, p.coords.z), p.length, p.width, {
            name = ('mezos_%s_%d'):format(p.data.kind, p.data.index), heading = 0, debugPoly = Config.Debug,
            minZ = p.coords.z + Config.StoreDefaults.minZ, maxZ = p.coords.z + Config.StoreDefaults.maxZ,
            data = { info = p.data, room = p.room },
        })
        zones[#zones + 1] = zone
    end

    local combo = ComboZone:Create(zones, { name = 'mezos_clothing', debugPoly = Config.Debug })
    combo:onPlayerInOut(function(inside, _, zone)
        if inside and zone then
            local d = zone.data
            if d.room and not canUseRoom(d.room) then return end
            current = d.info
            local label = labelFor(current)
            SendNUIMessage({ action = 'prompt', show = true, title = label.title, text = label.action, key = 'E' })
            CreateThread(function()
                local mine = current
                while current == mine do
                    if not Client.open and IsControlJustReleased(0, Config.InteractKey) then
                        SendNUIMessage({ action = 'prompt', show = false })
                        interact(mine)
                    end
                    Wait(0)
                end
            end)
        else
            current = nil
            SendNUIMessage({ action = 'prompt', show = false })
        end
    end)
end

CreateThread(function()
    if Config.UseTarget then setupTarget() else setupPolyZone() end
end)

-- re-show the prompt after a menu closes while still standing in the zone
AddEventHandler('qb-clothing:client:onMenuClose', function()
    if current then
        local label = labelFor(current)
        SendNUIMessage({ action = 'prompt', show = true, title = label.title, text = label.action, key = 'E' })
    end
end)
