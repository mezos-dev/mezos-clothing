-- qb-core's export can be briefly unavailable while resources restart; never let that abort this file
local function getCore()
    local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
    return ok and core or nil
end
QBCore = getCore()
if not QBCore then
    CreateThread(function()
        while not QBCore do
            Wait(250)
            QBCore = getCore()
        end
    end)
end

Client = {
    open = false,
    mode = nil,
    skin = nil,          -- the look currently applied (and saved) on the player
    original = nil,      -- look before the menu opened, restored on cancel
    originalModel = nil,
    creating = false,
    ctx = nil,
}

function Client.Notify(msg, kind)
    if Client.open then
        SendNUIMessage({ action = 'toast', message = msg, kind = kind or 'info' })
    else
        QBCore.Functions.Notify(msg, kind == 'info' and 'primary' or kind)
    end
end

RegisterNetEvent('mezos-clothing:client:notify', function(msg, kind) Client.Notify(msg, kind) end)

function Client.PlayerData()
    return QBCore.Functions.GetPlayerData() or {}
end

function Client.Gender()
    local pd = Client.PlayerData()
    return pd.charinfo and pd.charinfo.gender == 1 and 'female' or 'male'
end

local function trackerOverride(ped)
    local meta = Client.PlayerData().metadata
    if meta and meta.tracker then SetPedComponentVariation(ped, 7, 13, 0, 0) end
end

-- Apply a saved look to the player (switching model when needed)
function Client.ApplySaved(model, skin)
    local ped = PlayerPedId()
    if model and tonumber(model) and GetEntityModel(ped) ~= tonumber(model) then
        ped = Appearance.SetPlayerModel(tonumber(model))
    end
    Client.skin = Appearance.Apply(ped, skin)
    trackerOverride(ped)
    return Client.skin
end

-- Fetch and apply the saved look
function Client.LoadSavedLook(cb)
    QBCore.Functions.TriggerCallback('mezos-clothing:server:getSkin', function(data)
        if data then Client.ApplySaved(data.model, data.skin) end
        if cb then cb(data) end
    end)
end

-- ─────────────────────────── Menu payload ───────────────────────────

local function modelList()
    local male, female = {}, {}
    for _, m in ipairs(Config.ManPlayerModels or {}) do male[#male + 1] = m end
    for _, m in ipairs(Config.WomanPlayerModels or {}) do female[#female + 1] = m end
    return { male = male, female = female }
end

function Client.BuildPayload(mode, session)
    local ped = PlayerPedId()
    local payload = {
        mode = mode,
        skin = Client.skin,
        limits = Appearance.AllLimits(ped, Client.skin),
        palettes = Appearance.Palettes(),
        freemode = Appearance.IsFreemode(ped),
        gender = Appearance.Gender(ped),
        model = GetEntityModel(ped),
        prices = session.prices,
        money = session.money,
        jobOutfits = session.jobOutfits,
        isAdmin = session.isAdmin,
        theme = Config.Theme,
        gallery = Config.Gallery.enabled,
        maxOutfits = Config.MaxOutfits,
        bagPrice = Config.OutfitBag.soldInClothingStores and mode == 'clothing' and Config.Prices.outfitBag or nil,
        sharePrefix = Config.ShareCodePrefix,
        context = Client.ctx and Client.ctx.label,
    }
    if mode == 'tattoo' or mode == 'admin' or mode == 'barber' or mode == 'creator' then
        payload.tattoos = TattooCatalogue(payload.gender)
    end
    if mode == 'tattoo' then payload.undressed = Client.undressed end
    if mode == 'creator' then
        payload.creator = {
            intro = Config.Creator.intro and not Client.introPlayed,
            allowGenderSwap = Config.Creator.allowGenderSwap,
            starterOutfits = Config.Creator.starterOutfits,
        }
        Client.introPlayed = true
    end
    if mode == 'admin' then payload.models = modelList() end
    return payload
end

-- ─────────────────────────── Open / close ───────────────────────────

local hudThread = false
local function hideHud()
    if hudThread then return end
    hudThread = true
    CreateThread(function()
        while Client.open do
            HideHudAndRadarThisFrame()
            DisableAllControlActions(0)
            DisableAllControlActions(2)
            Wait(0)
        end
        hudThread = false
    end)
end

-- mode: clothing | barber | tattoo | surgeon | wardrobe | creator | admin
-- ctx:  { store = index } | { room = index } | { label = '...' }
function Client.Open(mode, ctx, onReady)
    if Client.open or Client.opening then return end
    if IsPedInAnyVehicle(PlayerPedId(), false) then return Client.Notify('Step out of your vehicle first', 'error') end
    Client.opening = true
    Client.ctx = ctx or {}

    QBCore.Functions.TriggerCallback('mezos-clothing:server:openSession', function(session)
        Client.opening = false
        if not session or not session.ok then
            return Client.Notify('You can\'t use that right now', 'error')
        end

        Client.mode = mode
        Client.original = Schema.Copy(Client.skin)
        Client.originalModel = GetEntityModel(PlayerPedId())

        if onReady then
            onReady(session)
        elseif session.skin then
            -- edit from the saved look, so temporary outfits (parachute, uniforms) never get charged
            Client.ApplySaved(session.model, session.skin)
        elseif not Client.skin then
            Client.skin = Appearance.ReadClothing(PlayerPedId())
        end

        local ped = PlayerPedId()
        ClearPedTasksImmediately(ped)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)

        local startPreset = ({ barber = 'head', surgeon = 'head', tattoo = 'torso' })[mode] or 'full'
        Camera.Start(startPreset)
        Client.open = true
        hideHud()

        -- parent portraits for the heritage picker (served to the UI through nui-img)
        if mode == 'creator' or mode == 'surgeon' or mode == 'admin' then
            RequestStreamedTextureDict('char_creator_portraits', false)
        end

        Client.undressed = false
        if mode == 'tattoo' and Config.Tattoo.undressOnOpen then TattooSetUndressed(true) end

        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', data = Client.BuildPayload(mode, session) })
    end, mode, Client.ctx)
end

-- revert: restore the look from before the menu opened
function Client.Close(revert)
    if not Client.open then return end
    local ped = PlayerPedId()
    if revert and Client.original then
        if Client.originalModel and GetEntityModel(ped) ~= Client.originalModel then
            ped = Appearance.SetPlayerModel(Client.originalModel)
        end
        Client.skin = Appearance.Apply(ped, Client.original)
        trackerOverride(ped)
    elseif Client.skin then
        -- drop any try-on preview
        Appearance.Apply(ped, Client.skin)
        trackerOverride(ped)
    end

    Client.open = false
    Client.undressed = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    Camera.Stop()
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    TriggerServerEvent('mezos-clothing:server:closeSession')
    TriggerEvent('qb-clothing:client:onMenuClose')
    local mode = Client.mode
    Client.mode = nil
    if mode == 'creator' and Creator then Creator.Finish() end
end

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if Client.open then
        SetNuiFocus(false, false)
        Camera.Stop()
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityInvincible(PlayerPedId(), false)
    end
end)

-- ─────────────────────────── Lifecycle ───────────────────────────

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('qb-clothes:loadPlayerSkin')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if Client.open then Client.Close(true) end
    Client.skin = nil
end)

-- Restart support: reload the look if the resource restarts mid-session
AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    while not QBCore do Wait(100) end
    if LocalPlayer.state.isLoggedIn then Client.LoadSavedLook() end
end)

RegisterNetEvent('mezos-clothing:client:openAdmin', function()
    Client.Open('admin', { label = 'Admin' })
end)

-- Exports for other resources
exports('OpenMenu', function(mode, ctx) Client.Open(mode, ctx) end)
exports('OpenWardrobe', function(label) Client.Open('wardrobe', { label = label }) end)
exports('GetSkin', function() return Client.skin end)
exports('ApplySkin', function(skin) Client.skin = Appearance.Apply(PlayerPedId(), skin) end)
exports('IsMenuOpen', function() return Client.open end)
