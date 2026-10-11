-- Server-side pricing. The client shows the same numbers, but only these are charged.

local tattooZone = {}
local function indexTattoos(list)
    for _, t in ipairs(list) do
        if t[3] and t[3] ~= '' then tattooZone[t[1] .. ':' .. t[3]] = t[5] end
        if t[4] and t[4] ~= '' then tattooZone[t[1] .. ':' .. t[4]] = t[5] end
    end
end
indexTattoos(Tattoos.List)
indexTattoos(Tattoos.Custom)

local function tattooPrice(t)
    local zone = tattooZone[Schema.TattooId(t)]
    local name = zone and Tattoos.ZoneNames[zone]
    local p = Config.Prices.tattoo
    return (name and p.zones[name]) or p.default
end

function MZ.IsKnownTattoo(t)
    return type(t) == 'table' and tattooZone[Schema.TattooId(t)] ~= nil
end

local function diffKeys(keys, old, new, priceTable, lines)
    local total = 0
    for _, key in ipairs(keys) do
        if not Schema.EntryEqual(old[key], new[key]) then
            local price = tonumber(priceTable[key]) or 0
            total = total + price
            lines[#lines + 1] = { key = key, price = price }
        end
    end
    return total
end

-- Returns total, lines
function MZ.CalculatePrice(mode, old, new)
    local lines, total = {}, 0
    local P = Config.Prices

    if mode == 'clothing' then
        total = diffKeys(Schema.ClothingKeys, old, new, P.clothing, lines)
    elseif mode == 'barber' then
        total = diffKeys(Schema.BarberKeys, old, new, P.barber, lines)
    elseif mode == 'surgeon' then
        local heritageChanged = false
        for _, key in ipairs(Schema.HeritageKeys) do
            if not Schema.EntryEqual(old[key], new[key]) then heritageChanged = true end
        end
        if heritageChanged then
            total = total + P.surgeon.heritage
            lines[#lines + 1] = { key = 'heritage', price = P.surgeon.heritage }
        end
        for _, key in ipairs(Schema.FaceFeatures) do
            if not Schema.EntryEqual(old[key], new[key]) then
                total = total + P.surgeon.feature
                lines[#lines + 1] = { key = key, price = P.surgeon.feature }
            end
        end
        local rest = { 'eye_color', 'ageing', 'moles', 'blemishes', 'complexion', 'sun_damage', 'body_blemishes' }
        total = total + diffKeys(rest, old, new, P.surgeon, lines)
    elseif mode == 'tattoo' then
        local had, has = {}, {}
        for _, t in ipairs(old.tattoos or {}) do had[Schema.TattooId(t)] = t end
        for _, t in ipairs(new.tattoos or {}) do has[Schema.TattooId(t)] = t end
        for id, t in pairs(has) do
            if not had[id] then
                local price = tattooPrice(t)
                total = total + price
                lines[#lines + 1] = { key = id, price = price }
            end
        end
        for id in pairs(had) do
            if not has[id] then
                total = total + P.tattoo.removal
                lines[#lines + 1] = { key = id, price = P.tattoo.removal, removal = true }
            end
        end
    end
    return math.floor(total), lines
end

-- Strip unknown tattoos so players can't inject arbitrary decorations
function MZ.SanitizeTattoos(skin)
    local clean, seen = {}, {}
    for _, t in ipairs(skin.tattoos or {}) do
        local id = MZ.IsKnownTattoo(t) and Schema.TattooId(t)
        if id and not seen[id] then
            seen[id] = true
            clean[#clean + 1] = { collection = t.collection, name = t.name }
        end
    end
    skin.tattoos = clean
    return skin
end

-- Charge the first account that can afford it. Returns ok, account
function MZ.Charge(Player, amount, reason)
    if amount <= 0 then return true, 'free' end
    for _, account in ipairs(Config.PaymentAccounts) do
        local balance = Player.PlayerData.money[account] or 0
        if balance >= amount and Player.Functions.RemoveMoney(account, amount, reason) then
            return true, account
        end
    end
    return false
end
