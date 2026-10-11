-- First-spawn character creator ("Genesis").

Creator = {}

local returnTo

local function teleport(coords, heading)
    local ped = PlayerPedId()
    DoScreenFadeOut(400)
    while not IsScreenFadedOut() do Wait(0) end
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading or 0.0)
    local t = GetGameTimer() + 5000
    while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < t do Wait(0) end
end

local function randomHeritage(skin)
    local fathers = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44 }
    local mothers = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45 }
    local f, m = fathers[math.random(#fathers)], mothers[math.random(#mothers)]
    skin['face'] = { item = f, texture = f }
    skin['face2'] = { item = m, texture = m }
    skin['facemix'] = { shapeMix = 0.5, skinMix = 0.5 }
end

local function starterSkin(gender)
    local skin = Schema.Default()
    randomHeritage(skin)
    local presets = Config.Creator.starterOutfits[gender]
    if presets and presets[1] then
        for key, v in pairs(presets[1].data) do skin[key] = { item = v.item, texture = v.texture } end
    end
    skin['eyebrows'] = { item = 0, texture = 0, opacity = 1.0 }
    return skin
end
Creator.StarterSkin = starterSkin

function Creator.Start()
    if Client.creating or Client.open then return end
    Client.creating = true

    -- wait until the character data is available
    local t = GetGameTimer() + 10000
    while not (Client.PlayerData().charinfo) and GetGameTimer() < t do Wait(100) end

    local gender = Client.Gender()
    local ped = PlayerPedId()
    returnTo = { coords = GetEntityCoords(ped), heading = GetEntityHeading(ped) }

    if Config.Creator.useStudio then
        if Config.Creator.privateBucket then TriggerServerEvent('mezos-clothing:server:creatorBucket', true) end
        local s = Config.Creator.studio
        teleport(vector3(s.x, s.y, s.z), s.w)
    else
        DoScreenFadeOut(300)
        while not IsScreenFadedOut() do Wait(0) end
    end

    ped = Appearance.SetPlayerModel(gender == 'female' and Schema.FreemodeFemale or Schema.FreemodeMale)
    Client.skin = Appearance.Apply(ped, starterSkin(gender))

    Client.Open('creator', { label = 'Genesis' }, function()
        -- keep the fresh look we just built (no saved skin exists yet)
        DoScreenFadeIn(800)
    end)

    -- if the session was refused, don't leave the player stuck in the studio
    SetTimeout(4000, function()
        if Client.creating and not Client.open and not Client.opening then Creator.Finish() end
    end)
end

-- Called after the creator closes (after a successful save)
function Creator.Finish()
    if not Client.creating then return end
    Client.creating = false
    -- creator refused or aborted: put the saved look back
    if not Client.creatorSaved then Client.LoadSavedLook() end
    Client.creatorSaved = false
    if Config.Creator.useStudio and returnTo then
        teleport(returnTo.coords, returnTo.heading)
        if Config.Creator.privateBucket then TriggerServerEvent('mezos-clothing:server:creatorBucket', false) end
    end
    returnTo = nil
    DoScreenFadeIn(800)
    TriggerEvent('mezos-clothing:client:creatorFinished')
end
