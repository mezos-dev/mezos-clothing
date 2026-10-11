-- Skin schema shared by client, server and (mirrored) the NUI.
-- The skin JSON is a superset of the qb-clothing format, so old saves load as-is
-- and new keys simply fall back to their defaults.

Schema = {}

Schema.FreemodeMale = `mp_m_freemode_01`
Schema.FreemodeFemale = `mp_f_freemode_01`

-- Ped components: key -> component id
Schema.Components = {
    ['mask'] = 1, ['hair'] = 2, ['arms'] = 3, ['pants'] = 4, ['bag'] = 5, ['shoes'] = 6,
    ['accessory'] = 7, ['t-shirt'] = 8, ['vest'] = 9, ['decals'] = 10, ['torso2'] = 11,
}

-- Ped props: key -> prop anchor. Like qb-clothing, item 0 / -1 mean "none".
Schema.Props = { ['hat'] = 0, ['glass'] = 1, ['ear'] = 2, ['watch'] = 6, ['bracelet'] = 7 }

-- Head overlays: key -> { id, colorType } (colorType 0 = no color, 1 = hair palette, 2 = makeup palette)
Schema.Overlays = {
    ['blemishes']      = { id = 0,  colorType = 0 },
    ['beard']          = { id = 1,  colorType = 1 },
    ['eyebrows']       = { id = 2,  colorType = 1 },
    ['ageing']         = { id = 3,  colorType = 0 },
    ['makeup']         = { id = 4,  colorType = 2 },
    ['blush']          = { id = 5,  colorType = 2 },
    ['complexion']     = { id = 6,  colorType = 0 },
    ['sun_damage']     = { id = 7,  colorType = 0 },
    ['lipstick']       = { id = 8,  colorType = 2 },
    ['moles']          = { id = 9,  colorType = 0 },
    ['chest_hair']     = { id = 10, colorType = 1 },
    ['body_blemishes'] = { id = 11, colorType = 0 },
}

-- Face features in native index order (0..19). Values are stored as item = -10..10 (native value * 10).
Schema.FaceFeatures = {
    'nose_0', 'nose_1', 'nose_2', 'nose_3', 'nose_4', 'nose_5',
    'eyebrown_high', 'eyebrown_forward', 'cheek_1', 'cheek_2', 'cheek_3',
    'eye_opening', 'lips_thickness', 'jaw_bone_width', 'jaw_bone_back_lenght',
    'chimp_bone_lowering', 'chimp_bone_lenght', 'chimp_bone_width', 'chimp_hole', 'neck_thikness',
}

Schema.FaceFeatureIndex = {}
for i, key in ipairs(Schema.FaceFeatures) do Schema.FaceFeatureIndex[key] = i - 1 end

Schema.HeritageKeys = { 'face', 'face2', 'facemix' }

-- Key groups used for outfits, shop permissions and pricing
Schema.ClothingKeys = {
    'mask', 'arms', 'pants', 'bag', 'shoes', 'accessory', 't-shirt', 'vest', 'decals', 'torso2',
    'hat', 'glass', 'ear', 'watch', 'bracelet',
}
Schema.BarberKeys = { 'hair', 'hair_fade', 'beard', 'eyebrows', 'chest_hair', 'makeup', 'blush', 'lipstick' }
Schema.SurgeonKeys = {
    'face', 'face2', 'facemix', 'eye_color', 'ageing', 'moles', 'blemishes', 'complexion', 'sun_damage', 'body_blemishes',
}
for _, key in ipairs(Schema.FaceFeatures) do Schema.SurgeonKeys[#Schema.SurgeonKeys + 1] = key end
Schema.TattooKeys = { 'tattoos' }

local function toSet(list)
    local set = {}
    for _, v in ipairs(list) do set[v] = true end
    return set
end

Schema.ClothingSet = toSet(Schema.ClothingKeys)
Schema.BarberSet = toSet(Schema.BarberKeys)
Schema.SurgeonSet = toSet(Schema.SurgeonKeys)

-- Which keys each menu mode may change. nil = everything (creator / admin)
Schema.ModeKeys = {
    clothing = Schema.ClothingSet,
    barber = Schema.BarberSet,
    surgeon = Schema.SurgeonSet,
    tattoo = toSet(Schema.TattooKeys),
    wardrobe = Schema.ClothingSet,
}

-- Defaults mirror qb-clothing so untouched characters look identical
function Schema.Default()
    local skin = {
        ['face']      = { item = 0, texture = 0 },
        ['face2']     = { item = 0, texture = 0 },
        ['facemix']   = { shapeMix = 0.5, skinMix = 0.5 },
        ['hair']      = { item = 0, texture = 0, highlight = 0 },
        ['eye_color'] = { item = -1 },
        ['hair_fade'] = { collection = '', name = '' },
        ['tattoos']   = {},
    }
    for key in pairs(Schema.Components) do
        if not skin[key] then skin[key] = { item = 0, texture = 0 } end
    end
    skin['t-shirt'] = { item = 1, texture = 0 }
    skin['shoes'] = { item = 1, texture = 0 }
    for key in pairs(Schema.Props) do skin[key] = { item = -1, texture = 0 } end
    for key in pairs(Schema.Overlays) do skin[key] = { item = -1, texture = 1, opacity = 1.0 } end
    skin['ageing'].texture = 0
    skin['moles'] = { item = -1, texture = 0, opacity = 1.0 }
    for _, key in ipairs(Schema.FaceFeatures) do skin[key] = { item = 0, texture = 0 } end
    return skin
end

local function copy(v)
    if type(v) ~= 'table' then return v end
    local t = {}
    for k, x in pairs(v) do t[k] = copy(x) end
    return t
end
Schema.Copy = copy

-- Fill any missing keys so every consumer can rely on a complete skin
function Schema.Normalize(skin)
    if type(skin) == 'string' then skin = json.decode(skin) end
    if type(skin) ~= 'table' then skin = {} end
    local out = Schema.Default()
    for key, value in pairs(skin) do
        if type(value) == 'table' then
            if key == 'tattoos' then
                out.tattoos = value
            elseif out[key] then
                for field, v in pairs(value) do out[key][field] = v end
            end
        end
    end
    -- qb-clothing stored mole opacity in texture (0..10)
    if skin['moles'] and skin['moles'].opacity == nil and skin['moles'].texture then
        out['moles'].opacity = (tonumber(skin['moles'].texture) or 10) / 10
    end
    return out
end

-- Extract only the clothing part of a skin (what an outfit contains)
function Schema.ExtractOutfit(skin)
    local outfit = {}
    for _, key in ipairs(Schema.ClothingKeys) do
        if skin[key] then outfit[key] = { item = skin[key].item, texture = skin[key].texture } end
    end
    return outfit
end

-- Copy allowed keys from `src` into `dst`. allowed = set or nil (all)
function Schema.Merge(dst, src, allowed)
    for key, value in pairs(src) do
        if (not allowed or allowed[key]) and dst[key] ~= nil then
            dst[key] = copy(value)
        end
    end
    return dst
end

local function entryEqual(a, b)
    if type(a) ~= 'table' or type(b) ~= 'table' then return a == b end
    for _, f in ipairs({ 'item', 'texture', 'highlight', 'shapeMix', 'skinMix' }) do
        local x, y = tonumber(a[f]), tonumber(b[f])
        if x ~= y and not (x and y and math.abs(x - y) < 0.001) then return false end
    end
    if (a.collection or '') ~= (b.collection or '') or (a.name or '') ~= (b.name or '') then return false end
    local oa, ob = tonumber(a.opacity) or 1.0, tonumber(b.opacity) or 1.0
    return math.abs(oa - ob) < 0.01
end
Schema.EntryEqual = entryEqual

function Schema.TattooId(t)
    return ('%s:%s'):format(t.collection or '', t.name or '')
end

-- Gender helper: 'male' | 'female' | nil (non-freemode ped)
function Schema.GenderOfModel(model)
    model = tonumber(model) or model
    if type(model) == 'number' and model > 2147483647 then model = model - 4294967296 end
    if model == Schema.FreemodeMale then return 'male' end
    if model == Schema.FreemodeFemale then return 'female' end
    return nil
end
