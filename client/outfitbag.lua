-- Outfit bag: place the bag, pick an outfit, change, pick the bag back up.

local bagObject
Client.bagOpen = false
local currentBag

local function loadDict(dict)
    RequestAnimDict(dict)
    local t = GetGameTimer() + 3000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < t do Wait(0) end
end

local function placeBag()
    local ped = PlayerPedId()
    local model = joaat(Config.OutfitBag.prop)
    if not Appearance.LoadModel(model) then return end
    loadDict('random@domestic')
    TaskPlayAnim(ped, 'random@domestic', 'pickup_low', 8.0, -8.0, 1200, 0, 0, false, false, false)
    Wait(700)
    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.6, -0.98)
    bagObject = CreateObject(model, pos.x, pos.y, pos.z, true, true, false)
    PlaceObjectOnGroundProperly(bagObject)
    SetEntityHeading(bagObject, GetEntityHeading(ped))
    FreezeEntityPosition(bagObject, true)
    SetModelAsNoLongerNeeded(model)
end

local function pickupBag()
    if not bagObject then return end
    local ped = PlayerPedId()
    loadDict('random@domestic')
    TaskPlayAnim(ped, 'random@domestic', 'pickup_low', 8.0, -8.0, 1200, 0, 0, false, false, false)
    Wait(800)
    if DoesEntityExist(bagObject) then DeleteEntity(bagObject) end
    bagObject = nil
end

RegisterNetEvent('mezos-clothing:client:useBag', function(bagId)
    if Client.open or Client.bagOpen then return end
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) or IsPedRagdoll(ped) or IsEntityDead(ped) then
        return Client.Notify('You can\'t use your outfit bag right now', 'error')
    end
    QBCore.Functions.TriggerCallback('mezos-clothing:server:bagGet', function(res)
        if not res or not res.ok then return Client.Notify('Bag not found', 'error') end
        currentBag = bagId
        Client.bagOpen = true
        placeBag()
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'bag', bagId = bagId, data = res, theme = Config.Theme, gender = Appearance.Gender(PlayerPedId()), model = GetEntityModel(PlayerPedId()) })
    end, bagId)
end)

-- Called by the UI when the player picks an outfit from the bag
RegisterNUICallback('bagWear', function(data, cb)
    if not Client.bagOpen then return cb({ ok = false }) end
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'bagHide' })
    local ped = PlayerPedId()
    loadDict('clothingtie')
    TaskPlayAnim(ped, 'clothingtie', 'try_tie_neutral_a', 3.0, 3.0, Config.OutfitBag.changeDuration, 51, 0, false, false, false)
    Wait(Config.OutfitBag.changeDuration)
    QBCore.Functions.TriggerCallback('mezos-clothing:server:wearOutfit', function(res)
        if res and res.ok then
            Client.ApplySaved(res.model, res.skin)
            Client.Notify('Outfit changed', 'success')
        else
            Client.Notify(res and res.reason == 'wrong_model' and 'That outfit doesn\'t fit your body type' or 'Couldn\'t change outfit', 'error')
        end
        ClearPedTasks(ped)
        cb(res or { ok = false })
    end, { type = 'bag', bagId = currentBag, index = data.index })
    Client.bagOpen = false
    pickupBag()
end)

RegisterNUICallback('bagClose', function(_, cb)
    cb({})
    if not Client.bagOpen then return end
    Client.bagOpen = false
    SetNuiFocus(false, false)
    pickupBag()
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and bagObject and DoesEntityExist(bagObject) then DeleteEntity(bagObject) end
end)
