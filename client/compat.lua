-- Legacy qb-clothing / qb-clothes client API. Other resources keep calling these unchanged.

-- Full menu (qb-adminmenu "Clothing" button)
RegisterNetEvent('qb-clothing:client:openMenu', function()
    Client.Open('admin', { label = 'Appearance' })
end)

-- Wardrobe (apartments, houses, boss & gang menus)
RegisterNetEvent('qb-clothing:client:openOutfitMenu', function()
    Client.OpenWardrobe('Wardrobe')
end)

RegisterNetEvent('qb-clothing:client:reloadOutfits', function(outfits)
    if Client.open then SendNUIMessage({ action = 'reloadOutfits' }) end
end)

-- First spawn (qb-multicharacter / qb-interior)
RegisterNetEvent('qb-clothes:client:CreateFirstCharacter', function()
    CreateThread(Creator.Start)
end)

-- Saved skin sent by the server
RegisterNetEvent('qb-clothes:loadSkin', function(isNew, model, data)
    if isNew or not model or not data then return end
    CreateThread(function()
        local skin = type(data) == 'string' and json.decode(data) or data
        Client.ApplySaved(tonumber(model), skin)
    end)
end)

-- Apply a skin to any ped (qb-multicharacter's preview ped uses this)
RegisterNetEvent('qb-clothing:client:loadPlayerClothing', function(data, ped)
    ped = ped or PlayerPedId()
    if type(data) == 'string' then data = json.decode(data) end
    local skin = Appearance.Apply(ped, data or {})
    if ped == PlayerPedId() then Client.skin = skin end
end)

-- Temporary outfit (police tracker, prison uniform, parachute). Not saved, like before.
RegisterNetEvent('qb-clothing:client:loadOutfit', function(oData)
    if type(oData) ~= 'table' then return end
    local data = oData.outfitData
    if type(data) == 'string' then data = json.decode(data) end
    if type(data) ~= 'table' then return end
    local ped = PlayerPedId()
    local temp = Schema.Copy(Client.skin or Schema.Default())
    for key in pairs(Schema.ClothingSet) do
        local e = data[key]
        if e then
            temp[key] = { item = tonumber(e.item) or 0, texture = tonumber(e.texture) or 0 }
            Appearance.ApplyKey(ped, key, temp)
        end
    end
    local meta = Client.PlayerData().metadata
    if meta and meta.tracker then
        SetPedComponentVariation(ped, 7, 13, 0, 0)
    elseif not data['accessory'] then
        SetPedComponentVariation(ped, 7, -1, 0, 2)
    end
    if oData.outfitName then Client.Notify(('Outfit: %s'):format(oData.outfitName), 'info') end
end)

-- Take off / put on hat, glasses, ear, mask, parachute bag (1..5), like qb-clothing
local faceProps = {}
local removed = {}
RegisterNetEvent('qb-clothing:client:adjustfacewear', function(kind)
    local pd = Client.PlayerData()
    if pd.metadata and pd.metadata.ishandcuffed then return end
    kind = tonumber(kind)
    local ped = PlayerPedId()
    local anims = {
        [1] = { 'mp_masks@on_foot', 'put_on_mask', prop = 0 },
        [2] = { 'clothingspecs', 'take_off', prop = 1 },
        [3] = { 'mp_masks@on_foot', 'put_on_mask', prop = 2 },
        [4] = { 'missfbi4', 'takeoff_mask', component = 1 },
        [5] = { 'oddjobs@basejump@ig_15', 'puton_parachute', component = 5 },
    }
    local a = anims[kind]
    if not a then return end
    RequestAnimDict(a[1])
    local t = GetGameTimer() + 2000
    while not HasAnimDictLoaded(a[1]) and GetGameTimer() < t do Wait(0) end

    removed[kind] = not removed[kind]
    TaskPlayAnim(ped, a[1], a[2], 4.0, 3.0, -1, 49, 1.0, false, false, false)
    Wait(600)
    if a.prop then
        if removed[kind] then
            faceProps[kind] = { GetPedPropIndex(ped, a.prop), GetPedPropTextureIndex(ped, a.prop) }
            ClearPedProp(ped, a.prop)
        elseif faceProps[kind] and faceProps[kind][1] >= 0 then
            SetPedPropIndex(ped, a.prop, faceProps[kind][1], faceProps[kind][2], true)
        end
    else
        if removed[kind] then
            faceProps[kind] = { GetPedDrawableVariation(ped, a.component), GetPedTextureVariation(ped, a.component) }
            SetPedComponentVariation(ped, a.component, 0, 0, 0)
        elseif faceProps[kind] then
            SetPedComponentVariation(ped, a.component, faceProps[kind][1], faceProps[kind][2], 0)
        end
    end
    Wait(kind == 5 and 1800 or 400)
    ClearPedTasks(ped)
end)

-- ─────────────────────────── Exports ───────────────────────────

local function reloadSkin(health)
    local ped = PlayerPedId()
    health = health or GetEntityHealth(ped)
    Client.LoadSavedLook(function()
        SetEntityHealth(PlayerPedId(), health)
    end)
end

local function isCreating() return Client.creating end

local function getOutfits(gradeLevel, data)
    Client.OpenWardrobe('Wardrobe')
end

exports('reloadSkin', reloadSkin)
exports('IsCreatingCharacter', isCreating)
exports('getOutfits', getOutfits)

-- Answer exports['qb-clothing']:... calls too
local function provideExport(name, fn)
    AddEventHandler(('__cfx_export_qb-clothing_%s'):format(name), function(setCB) setCB(fn) end)
end
provideExport('reloadSkin', reloadSkin)
provideExport('IsCreatingCharacter', isCreating)
provideExport('getOutfits', getOutfits)

if Config.RefreshSkinCommand then
    RegisterCommand(Config.RefreshSkinCommand, function()
        if Client.open then return end
        reloadSkin(GetEntityHealth(PlayerPedId()))
    end, false)
end
