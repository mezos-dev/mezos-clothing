Config = Config or {}

-- type: clothing | barber | tattoo | surgeon
-- size: PolyZone box (length, width) and height range around coords.z
-- blip: set false to hide this store's blip
Config.Stores = {
    -- Clothing (migrated from qb-clothing)
    { type = 'clothing', coords = vector3(1693.32, 4823.48, 41.06) },
    { type = 'clothing', coords = vector3(-712.215881, -155.352982, 37.4151268) },
    { type = 'clothing', coords = vector3(-1192.94495, -772.688965, 17.3255997) },
    { type = 'clothing', coords = vector3(425.236, -806.008, 28.491) },
    { type = 'clothing', coords = vector3(-162.658, -303.397, 38.733) },
    { type = 'clothing', coords = vector3(75.950, -1392.891, 28.376) },
    { type = 'clothing', coords = vector3(-822.194, -1074.134, 10.328) },
    { type = 'clothing', coords = vector3(-1450.711, -236.83, 48.809) },
    { type = 'clothing', coords = vector3(4.254, 6512.813, 30.877) },
    { type = 'clothing', coords = vector3(615.180, 2762.933, 41.088) },
    { type = 'clothing', coords = vector3(1196.785, 2709.558, 37.222) },
    { type = 'clothing', coords = vector3(-3171.453, 1043.857, 19.863) },
    { type = 'clothing', coords = vector3(-1100.959, 2710.211, 18.107) },
    { type = 'clothing', coords = vector3(-1207.65, -1456.88, 4.3784737586975) },
    { type = 'clothing', coords = vector3(121.76, -224.6, 53.56) },

    -- Barbers (migrated from qb-clothing)
    { type = 'barber', coords = vector3(-814.3, -183.8, 36.6) },
    { type = 'barber', coords = vector3(136.8, -1708.4, 28.3) },
    { type = 'barber', coords = vector3(-1282.6, -1116.8, 6.0) },
    { type = 'barber', coords = vector3(1931.5, 3729.7, 31.8) },
    { type = 'barber', coords = vector3(1212.8, -472.9, 65.2) },
    { type = 'barber', coords = vector3(-32.9, -152.3, 56.1) },
    { type = 'barber', coords = vector3(-278.1, 6228.5, 30.7) },

    -- Tattoo parlors (GTA V interiors)
    { type = 'tattoo', coords = vector3(323.5, 180.9, 103.59) },
    { type = 'tattoo', coords = vector3(-1153.8, -1425.8, 4.95) },
    { type = 'tattoo', coords = vector3(1322.9, -1652.2, 52.27) },
    { type = 'tattoo', coords = vector3(1864.4, 3747.4, 33.03) },
    { type = 'tattoo', coords = vector3(-293.5, 6199.8, 31.49) },
    { type = 'tattoo', coords = vector3(-3170.3, 1075.6, 20.83) },

    -- Plastic surgeon
    { type = 'surgeon', coords = vector3(298.55, -572.63, 43.26) },
}

Config.StoreDefaults = { length = 2.5, width = 2.5, minZ = -1.0, maxZ = 2.0 }

-- Outfit changers: open the wardrobe (saved outfits) for free
Config.OutfitChangers = {
    vector3(1697.41, 4829.25, 41.06),
    vector3(-703.83, -151.67, 36.42),
    vector3(-1187.19, -768.64, 16.33),
    vector3(429.5, -800.15, 28.49),
    vector3(-168.21, -298.7, 38.73),
    vector3(71.06, -1399.17, 28.38),
    vector3(-829.72, -1073.33, 10.33),
    vector3(-1447.51, -242.81, 48.82),
    vector3(12.28, 6513.63, 30.88),
    vector3(617.89, 2766.79, 41.09),
    vector3(1190.35, 2714.51, 37.22),
    vector3(-3175.64, 1041.84, 19.86),
    vector3(-1108.95, 2709.37, 18.11),
    vector3(-1203.79, -1454.53, 3.38),
    vector3(120.44, -227.38, 53.56),
}

-- Job / gang locker rooms: wardrobe + uniforms from config/joboutfits.lua
-- set isGang = true if requiredJob is a gang
Config.ClothingRooms = {
    { requiredJob = 'police',     isGang = false, coords = vector3(454.68, -990.89, 29.69) },
    { requiredJob = 'ambulance',  isGang = false, coords = vector3(342.47, -586.15, 43.32) },
    { requiredJob = 'police',     isGang = false, coords = vector3(314.76, 671.78, 14.73) },
    { requiredJob = 'ambulance',  isGang = false, coords = vector3(338.70, 659.61, 14.71) },
    { requiredJob = 'ambulance',  isGang = false, coords = vector3(-1098.45, 1751.71, 23.35) },
    { requiredJob = 'police',     isGang = false, coords = vector3(-77.59, -129.17, 5.03) },
    { requiredJob = 'realestate', isGang = false, coords = vector3(-131.45, -633.74, 168.82) },
}
