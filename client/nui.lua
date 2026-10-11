-- NUI callbacks. The UI owns the editing state; Lua applies it to the ped and talks to the server.

local function limitsFor(key)
    return Appearance.Limits(PlayerPedId(), key, Client.skin)
end

-- Live edit of one key: { key, value }
RegisterNUICallback('patch', function(data, cb)
    if not Client.open or type(data) ~= 'table' or not data.key or not Client.skin then return cb({}) end
    local key = data.key
    if key == 'tattoos' then
        Client.skin.tattoos = type(data.value) == 'table' and data.value or {}
    elseif Client.skin[key] ~= nil and type(data.value) == 'table' then
        Client.skin[key] = data.value
    else
        return cb({})
    end
    Appearance.ApplyKey(PlayerPedId(), key, Client.skin)
    cb({ limits = limitsFor(key) })
end)

-- Replace the whole look (undo/redo, randomize, reset)
RegisterNUICallback('applySkin', function(data, cb)
    if not Client.open or type(data) ~= 'table' or type(data.skin) ~= 'table' then return cb({}) end
    Client.skin = Appearance.Apply(PlayerPedId(), data.skin)
    TattooReapplyStrip()
    cb({ limits = Appearance.AllLimits(PlayerPedId(), Client.skin) })
end)

-- Try an outfit on without saving (gallery, share code, gifts)
RegisterNUICallback('preview', function(data, cb)
    if not Client.open or type(data) ~= 'table' then return cb({}) end
    local ped = PlayerPedId()
    if data.clear then
        Appearance.Apply(ped, Client.skin)
        TattooReapplyStrip()
    elseif type(data.skin) == 'table' then
        Appearance.ApplyOutfit(ped, Schema.Copy(Client.skin), data.skin)
    end
    cb({})
end)

-- Switch model (creator gender / admin ped list)
RegisterNUICallback('setModel', function(data, cb)
    if not Client.open or (Client.mode ~= 'creator' and Client.mode ~= 'admin') then return cb({}) end
    local model = data.gender == 'female' and Schema.FreemodeFemale or data.gender == 'male' and Schema.FreemodeMale or data.model
    local ped = Appearance.SetPlayerModel(model)
    local skin = Schema.Default()
    if type(data.skin) == 'table' then skin = Schema.Normalize(data.skin) end
    Client.skin = Appearance.Apply(ped, skin)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    cb({
        skin = Client.skin,
        limits = Appearance.AllLimits(ped, Client.skin),
        freemode = Appearance.IsFreemode(ped),
        gender = Appearance.Gender(ped),
        model = GetEntityModel(ped),
        tattoos = TattooCatalogue(Appearance.Gender(ped)),
    })
end)

-- Tattoo parlor: take clothes off / put them back on (preview only)
RegisterNUICallback('undress', function(data, cb)
    if not Client.open or Client.mode ~= 'tattoo' then return cb({}) end
    TattooSetUndressed(data.on == true)
    cb({ undressed = Client.undressed })
end)

RegisterNUICallback('camera', function(data, cb)
    if data.preset then Camera.Focus(data.preset) end
    if data.rotate then Camera.Rotate(data.rotate) end
    if data.zoom then Camera.Zoom(data.zoom) end
    if data.angle then Camera.SetAngle(data.angle) end
    if data.lighting then Camera.SetLighting(data.lighting) end
    cb({})
end)

-- Confirm / purchase
RegisterNUICallback('commit', function(_, cb)
    if not Client.open then return cb({ ok = false }) end
    QBCore.Functions.TriggerCallback('mezos-clothing:server:commit', function(res)
        if res and res.ok then
            Client.skin = Schema.Normalize(res.skin)
            Client.original = Schema.Copy(Client.skin)
            Client.originalModel = GetEntityModel(PlayerPedId())
            if Client.mode == 'creator' then Client.creatorSaved = true end
        end
        cb(res or { ok = false })
    end, Client.skin, GetEntityModel(PlayerPedId()))
end)

RegisterNUICallback('close', function(data, cb)
    cb({})
    if Client.mode == 'creator' and not data.force then return end
    Client.Close(data.revert ~= false)
end)

-- Proxy to whitelisted server callbacks
local allowed = {
    getOutfits = true, saveOutfit = true, updateOutfit = true, editOutfitInfo = true, deleteOutfit = true,
    duplicateOutfit = true, getShareCode = true, previewCode = true, importCode = true,
    nearbyPlayers = true, sendOutfit = true, respondOffer = true,
    galleryList = true, galleryPublish = true, galleryLike = true, gallerySave = true, galleryDelete = true,
    bagGet = true, bagAddCurrent = true, bagAddFromWardrobe = true, bagToWardrobe = true, bagRemove = true,
    bagRenameOutfit = true, bagRename = true, buyBag = true, wearOutfit = true,
}

RegisterNUICallback('server', function(data, cb)
    if type(data) ~= 'table' or not allowed[data.name] then return cb({ ok = false }) end
    local args = type(data.args) == 'table' and data.args or {}
    QBCore.Functions.TriggerCallback('mezos-clothing:server:' .. data.name, function(res)
        -- wearing changes the saved look: apply it right away
        if data.name == 'wearOutfit' and res and res.ok and res.skin then
            Client.ApplySaved(res.model, res.skin)
            Client.original = Schema.Copy(Client.skin)
            res.limits = Appearance.AllLimits(PlayerPedId(), Client.skin)
            res.skin = Client.skin
        end
        cb(res or { ok = false })
    end, table.unpack(args, 1, 4))
end)
