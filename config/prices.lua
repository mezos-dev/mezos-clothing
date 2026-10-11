Config = Config or {}

-- Every price is charged once per changed category when the player confirms.
-- The server recalculates the total itself, so the UI price can never be spoofed.
Config.Prices = {
    clothing = {
        ['mask']      = 120,
        ['arms']      = 0,      -- arms/gloves follow the torso, keep free
        ['pants']     = 180,
        ['bag']       = 150,
        ['shoes']     = 160,
        ['accessory'] = 90,
        ['t-shirt']   = 110,
        ['vest']      = 140,
        ['decals']    = 60,
        ['torso2']    = 220,
        ['hat']       = 80,
        ['glass']     = 70,
        ['ear']       = 60,
        ['watch']     = 150,
        ['bracelet']  = 90,
    },
    barber = {
        ['hair']       = 120,   -- style, color or highlight
        ['hair_fade']  = 80,
        ['beard']      = 70,
        ['eyebrows']   = 40,
        ['chest_hair'] = 50,
        ['makeup']     = 80,
        ['blush']      = 50,
        ['lipstick']   = 50,
    },
    surgeon = {
        heritage = 2500,        -- parents / resemblance / skin tone
        feature  = 400,         -- per face feature changed
        ['eye_color']      = 300,
        ['ageing']         = 600,
        ['moles']          = 250,
        ['blemishes']      = 250,
        ['complexion']     = 250,
        ['sun_damage']     = 250,
        ['body_blemishes'] = 250,
    },
    tattoo = {
        default = 450,
        zones = {               -- override by body zone
            ZONE_HEAD      = 600,
            ZONE_TORSO     = 550,
            ZONE_LEFT_ARM  = 400,
            ZONE_RIGHT_ARM = 400,
            ZONE_LEFT_LEG  = 380,
            ZONE_RIGHT_LEG = 380,
        },
        removal = 250,          -- per tattoo removed
    },
    outfitBag = 1500,
    importOutfit = 0,           -- fee to save someone else's outfit (code, gallery, gift). 0 = free
}
