-- Builds the tattoo / hair-fade catalogue for the UI, per gender (cached).

local cache = {}

local function priceFor(zone)
    local p = Config.Prices.tattoo
    local name = Tattoos.ZoneNames[zone]
    return (name and p.zones[name]) or p.default
end

local function add(list, entry, gender, idx)
    local overlay = gender == 'female' and entry[4] or entry[3]
    if not overlay or overlay == '' then return end
    local zone = tonumber(entry[5]) or 0
    local label = entry[2]
    if zone == 6 then label = ('Fade %d'):format(idx) end
    list[#list + 1] = {
        id = entry[1] .. ':' .. overlay,
        collection = entry[1],
        name = overlay,
        label = label,
        zone = zone,
        pack = Tattoos.CollectionLabels[entry[1]] or entry[1],
        price = zone == 6 and (Config.Prices.barber['hair_fade'] or 0) or priceFor(zone),
    }
end

function TattooCatalogue(gender)
    if cache[gender] then return cache[gender] end
    local list, fades = {}, 0
    for _, source in ipairs({ Tattoos.List, Tattoos.Custom }) do
        for _, entry in ipairs(source) do
            if tonumber(entry[5]) == 6 then fades = fades + 1 end
            add(list, entry, gender, fades)
        end
    end
    cache[gender] = list
    return list
end

-- ─────────────────────────── Undress preview ───────────────────────────
-- Visual only: Client.skin is untouched, so closing the menu (or any full re-apply) restores the outfit.

Client.undressed = false

function TattooStrip(ped)
    ped = ped or PlayerPedId()
    if not Appearance.IsFreemode(ped) then return end
    local set = Config.Tattoo.undress[Appearance.Gender(ped)] or {}
    for comp, drawable in pairs(set) do
        SetPedComponentVariation(ped, comp, drawable, 0, 0)
    end
    for _, prop in ipairs(Config.Tattoo.props or {}) do
        ClearPedProp(ped, prop)
    end
end

-- on = true strips, false puts the current look back
function TattooSetUndressed(on)
    Client.undressed = on == true
    local ped = PlayerPedId()
    if Client.undressed then
        TattooStrip(ped)
    elseif Client.skin then
        Appearance.Apply(ped, Client.skin)
    end
end

-- Call after anything re-applies the full look while the parlor is open
function TattooReapplyStrip()
    if Client.undressed and Client.open and Client.mode == 'tattoo' then TattooStrip() end
end
