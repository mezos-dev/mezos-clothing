-- Appearance engine: applies a skin table to a ped and reports variation limits.

Appearance = {}

local function num(v, d) return tonumber(v) or d or 0 end

function Appearance.IsFreemode(ped)
    local model = GetEntityModel(ped)
    return model == Schema.FreemodeMale or model == Schema.FreemodeFemale
end

function Appearance.Gender(ped)
    return GetEntityModel(ped) == Schema.FreemodeFemale and 'female' or 'male'
end

function Appearance.LoadModel(model)
    model = type(model) == 'string' and joaat(model) or tonumber(model)
    if not model or not IsModelInCdimage(model) then return false end
    RequestModel(model)
    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do Wait(0) end
    return HasModelLoaded(model) and model or false
end

-- Switch the player model, keeping health and armour. Returns the new ped.
function Appearance.SetPlayerModel(model)
    local hash = Appearance.LoadModel(model)
    if not hash then return PlayerPedId() end
    if GetEntityModel(PlayerPedId()) == hash then return PlayerPedId() end
    local ped = PlayerPedId()
    local health, armour = GetEntityHealth(ped), GetPedArmour(ped)
    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    ped = PlayerPedId()
    SetPedDefaultComponentVariation(ped)
    if Appearance.IsFreemode(ped) then
        SetPedHeadBlendData(ped, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, false)
    end
    SetEntityHealth(ped, health)
    SetPedArmour(ped, armour)
    return ped
end

-- ─────────────────────────── Apply ───────────────────────────

local function applyComponent(ped, key, e)
    local id = Schema.Components[key]
    if key == 'hair' then
        SetPedComponentVariation(ped, 2, num(e.item), 0, 0)
        SetPedHairColor(ped, num(e.texture), num(e.highlight, num(e.texture)))
        return
    end
    SetPedComponentVariation(ped, id, num(e.item), num(e.texture), 0)
end

local function applyProp(ped, key, e)
    local id = Schema.Props[key]
    local item = num(e.item, -1)
    if item > 0 then
        SetPedPropIndex(ped, id, item, math.max(0, num(e.texture)), true)
    else
        ClearPedProp(ped, id)
    end
end

local function applyOverlay(ped, key, e)
    local def = Schema.Overlays[key]
    local item = num(e.item, -1)
    local opacity = num(e.opacity, 1.0)
    if item < 0 or item == 255 then
        SetPedHeadOverlay(ped, def.id, 255, 0.0)
        return
    end
    SetPedHeadOverlay(ped, def.id, item, opacity + 0.0)
    if def.colorType > 0 then
        SetPedHeadOverlayColor(ped, def.id, def.colorType, num(e.texture), num(e.secondColor, num(e.texture)))
    end
end

local function applyHeritage(ped, skin)
    local f1, f2, mix = skin['face'] or {}, skin['face2'] or {}, skin['facemix'] or {}
    SetPedHeadBlendData(ped,
        num(f1.item), num(f2.item), 0,
        num(f1.texture), num(f2.texture), 0,
        num(mix.shapeMix, 0.5) + 0.0, num(mix.skinMix, 0.5) + 0.0, 0.0, false)
end

local function applyFeature(ped, key, e)
    local idx = Schema.FaceFeatureIndex[key]
    SetPedFaceFeature(ped, idx, (num(e.item) / 10) + 0.0)
end

function Appearance.ApplyDecorations(ped, skin)
    ClearPedDecorations(ped)
    local fade = skin['hair_fade']
    if fade and fade.collection ~= '' and fade.name ~= '' then
        AddPedDecorationFromHashes(ped, joaat(fade.collection), joaat(fade.name))
    end
    for _, t in ipairs(skin['tattoos'] or {}) do
        if t.collection and t.name then
            AddPedDecorationFromHashes(ped, joaat(t.collection), joaat(t.name))
        end
    end
end

-- Apply a single key. Heritage keys re-apply the whole blend.
function Appearance.ApplyKey(ped, key, skin)
    local e = skin[key]
    if e == nil then return end
    local freemode = Appearance.IsFreemode(ped)
    if Schema.Components[key] then
        applyComponent(ped, key, e)
    elseif Schema.Props[key] then
        applyProp(ped, key, e)
    elseif not freemode then
        return
    elseif Schema.Overlays[key] then
        applyOverlay(ped, key, e)
    elseif Schema.FaceFeatureIndex[key] then
        applyFeature(ped, key, e)
    elseif key == 'face' or key == 'face2' or key == 'facemix' then
        applyHeritage(ped, skin)
    elseif key == 'eye_color' then
        if num(e.item, -1) >= 0 then SetPedEyeColor(ped, num(e.item)) end
    elseif key == 'tattoos' or key == 'hair_fade' then
        Appearance.ApplyDecorations(ped, skin)
    end
end

-- Apply a complete skin
function Appearance.Apply(ped, skin)
    skin = Schema.Normalize(skin)
    local freemode = Appearance.IsFreemode(ped)
    if freemode then applyHeritage(ped, skin) end
    for key in pairs(Schema.Components) do applyComponent(ped, key, skin[key]) end
    for key in pairs(Schema.Props) do applyProp(ped, key, skin[key]) end
    if freemode then
        for key in pairs(Schema.Overlays) do applyOverlay(ped, key, skin[key]) end
        for _, key in ipairs(Schema.FaceFeatures) do applyFeature(ped, key, skin[key]) end
        if num(skin['eye_color'].item, -1) >= 0 then SetPedEyeColor(ped, num(skin['eye_color'].item)) end
        Appearance.ApplyDecorations(ped, skin)
    end
    return skin
end

-- Apply only clothing keys of an outfit on top of a skin (returns merged skin)
function Appearance.ApplyOutfit(ped, skin, outfit)
    for key in pairs(Schema.ClothingSet) do
        if outfit[key] then
            skin[key] = { item = num(outfit[key].item), texture = num(outfit[key].texture) }
            Appearance.ApplyKey(ped, key, skin)
        end
    end
    return skin
end

-- ─────────────────────────── Limits ───────────────────────────

-- Returns { max = drawableCount, textures = textureCountForCurrent } for a key
function Appearance.Limits(ped, key, skin)
    local e = skin[key] or {}
    if key == 'hair' then
        return { max = GetNumberOfPedDrawableVariations(ped, 2), textures = GetNumHairColors() }
    elseif Schema.Components[key] then
        local id = Schema.Components[key]
        return { max = GetNumberOfPedDrawableVariations(ped, id), textures = GetNumberOfPedTextureVariations(ped, id, num(e.item)) }
    elseif Schema.Props[key] then
        local id = Schema.Props[key]
        local item = num(e.item, -1)
        return { max = GetNumberOfPedPropDrawableVariations(ped, id), textures = item > 0 and GetNumberOfPedPropTextureVariations(ped, id, item) or 0 }
    elseif Schema.Overlays[key] then
        local def = Schema.Overlays[key]
        local colors = def.colorType == 1 and GetNumHairColors() or (def.colorType == 2 and GetNumMakeupColors() or 0)
        return { max = GetPedHeadOverlayNum(def.id), textures = colors }
    end
    return nil
end

function Appearance.AllLimits(ped, skin)
    local limits = {}
    for key in pairs(Schema.Components) do limits[key] = Appearance.Limits(ped, key, skin) end
    for key in pairs(Schema.Props) do limits[key] = Appearance.Limits(ped, key, skin) end
    for key in pairs(Schema.Overlays) do limits[key] = Appearance.Limits(ped, key, skin) end
    return limits
end

-- RGB palettes for color swatches in the UI
local palettes
function Appearance.Palettes()
    if palettes then return palettes end
    palettes = { hair = {}, makeup = {} }
    for i = 0, GetNumHairColors() - 1 do
        local r, g, b = GetPedHairRgbColor(i)
        palettes.hair[#palettes.hair + 1] = ('#%02x%02x%02x'):format(r, g, b)
    end
    for i = 0, GetNumMakeupColors() - 1 do
        local r, g, b = GetPedMakeupRgbColor(i)
        palettes.makeup[#palettes.makeup + 1] = ('#%02x%02x%02x'):format(r, g, b)
    end
    return palettes
end

-- Read the clothing currently on a ped (used when no saved skin exists)
function Appearance.ReadClothing(ped)
    local skin = Schema.Default()
    for key, id in pairs(Schema.Components) do
        skin[key].item = GetPedDrawableVariation(ped, id)
        skin[key].texture = key == 'hair' and GetPedHairColor(ped) or GetPedTextureVariation(ped, id)
    end
    skin['hair'].highlight = GetPedHairHighlightColor(ped)
    for key, id in pairs(Schema.Props) do
        skin[key].item = GetPedPropIndex(ped, id)
        skin[key].texture = GetPedPropTextureIndex(ped, id)
    end
    return skin
end
