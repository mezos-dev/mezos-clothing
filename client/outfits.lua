-- Incoming outfit gifts and wardrobe helpers.

RegisterNetEvent('mezos-clothing:client:outfitOffer', function(offer)
    if not Client.open then SetNuiFocus(true, true) end
    SendNUIMessage({ action = 'offer', offer = offer, standalone = not Client.open })
end)

-- The UI closed a popup that was shown outside the main menu
RegisterNUICallback('popupClosed', function(_, cb)
    if not Client.open and not Client.bagOpen then SetNuiFocus(false, false) end
    cb({})
end)

-- Wardrobe opened from apartments, houses, boss/gang menus or outfit changers
function Client.OpenWardrobe(label, room)
    Client.Open('wardrobe', { label = label, room = room })
end
