Config = Config or {}

Config.Creator = {
    -- Move new characters to a private studio while they create their look.
    -- The player is returned to where they were when they confirm.
    useStudio = true,
    studio = vector4(402.91, -996.78, -99.0, 180.0),   -- GTA Online creator line-up room
    privateBucket = true,                              -- isolate the player in their own routing bucket

    allowGenderSwap = true,                            -- let the player switch between male/female freemode
    intro = true,                                      -- play the holographic boot intro

    -- Starter outfits offered in the "Outfit" step (freemode peds). Tweak freely.
    -- Only clothing keys belong here.
    starterOutfits = {
        male = {
            { label = 'Casual', icon = 'shirt', data = {
                ['torso2'] = { item = 0, texture = 0 }, ['t-shirt'] = { item = 15, texture = 0 }, ['arms'] = { item = 0, texture = 0 },
                ['pants'] = { item = 0, texture = 0 }, ['shoes'] = { item = 1, texture = 0 },
            } },
            { label = 'Street', icon = 'hoodie', data = {
                ['torso2'] = { item = 7, texture = 0 }, ['t-shirt'] = { item = 15, texture = 0 }, ['arms'] = { item = 1, texture = 0 },
                ['pants'] = { item = 4, texture = 0 }, ['shoes'] = { item = 4, texture = 0 },
            } },
            { label = 'Smart', icon = 'tie', data = {
                ['torso2'] = { item = 4, texture = 0 }, ['t-shirt'] = { item = 4, texture = 0 }, ['arms'] = { item = 1, texture = 0 },
                ['pants'] = { item = 10, texture = 0 }, ['shoes'] = { item = 10, texture = 0 }, ['accessory'] = { item = 10, texture = 0 },
            } },
            { label = 'Sport', icon = 'run', data = {
                ['torso2'] = { item = 5, texture = 0 }, ['t-shirt'] = { item = 15, texture = 0 }, ['arms'] = { item = 5, texture = 0 },
                ['pants'] = { item = 6, texture = 0 }, ['shoes'] = { item = 9, texture = 0 },
            } },
        },
        female = {
            { label = 'Casual', icon = 'shirt', data = {
                ['torso2'] = { item = 0, texture = 0 }, ['t-shirt'] = { item = 14, texture = 0 }, ['arms'] = { item = 0, texture = 0 },
                ['pants'] = { item = 0, texture = 0 }, ['shoes'] = { item = 0, texture = 0 },
            } },
            { label = 'Street', icon = 'hoodie', data = {
                ['torso2'] = { item = 3, texture = 0 }, ['t-shirt'] = { item = 14, texture = 0 }, ['arms'] = { item = 3, texture = 0 },
                ['pants'] = { item = 4, texture = 0 }, ['shoes'] = { item = 3, texture = 0 },
            } },
            { label = 'Smart', icon = 'tie', data = {
                ['torso2'] = { item = 6, texture = 0 }, ['t-shirt'] = { item = 14, texture = 0 }, ['arms'] = { item = 5, texture = 0 },
                ['pants'] = { item = 6, texture = 0 }, ['shoes'] = { item = 6, texture = 0 },
            } },
            { label = 'Sport', icon = 'run', data = {
                ['torso2'] = { item = 10, texture = 0 }, ['t-shirt'] = { item = 14, texture = 0 }, ['arms'] = { item = 4, texture = 0 },
                ['pants'] = { item = 10, texture = 0 }, ['shoes'] = { item = 10, texture = 0 },
            } },
        },
    },
}
