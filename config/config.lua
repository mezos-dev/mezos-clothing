Config = Config or {}

-- ───────────────────────────── General ─────────────────────────────
Config.Debug = false                     -- draws zones and prints debug info
Config.Locale = 'en'
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'
Config.InteractKey = 38                  -- E (only used when UseTarget = false)
Config.InteractDistance = 2.0

-- Money: try these accounts in order until one can pay
Config.PaymentAccounts = { 'cash', 'bank' }

-- Who can open the full (free) appearance menu via qb-adminmenu / /appearance
Config.AdminPermission = { 'admin', 'god' }
Config.AdminCommand = 'appearance'       -- set to false to disable

-- Legacy /refreshskin command (reloads your saved look)
Config.RefreshSkinCommand = 'refreshskin'

-- ───────────────────────────── UI ─────────────────────────────
Config.Theme = {
    accent = '#22e4ff',                  -- primary neon
    accent2 = '#a855ff',                 -- secondary neon
    danger = '#ff3d71',
    success = '#2bffb1',
    serverName = 'MEZOS',                -- shown in the creator intro
    tagline = 'Design your future self',
    sounds = true,                       -- subtle UI ticks
}

-- ───────────────────────────── Camera ─────────────────────────────
Config.Camera = {
    fov = 40.0,
    -- offsets relative to the ped (forward distance, height, look-at height)
    presets = {
        full  = { dist = 2.6, height = 0.2,  look = 0.0,   fov = 42.0 },
        head  = { dist = 0.75, height = 0.65, look = 0.65,  fov = 32.0 },
        torso = { dist = 1.35, height = 0.3,  look = 0.25,  fov = 38.0 },
        legs  = { dist = 1.5,  height = -0.35, look = -0.45, fov = 40.0 },
        feet  = { dist = 1.1,  height = -0.75, look = -0.85, fov = 38.0 },
    },
    zoomMin = 0.4,                       -- zoom multipliers of the preset distance
    zoomMax = 2.0,
}

-- ───────────────────────────── Outfits & sharing ─────────────────────────────
Config.MaxOutfits = 60                   -- per character
Config.MaxOutfitNameLength = 32
Config.ShareCodePrefix = 'MZ'
Config.SendOutfitDistance = 5.0          -- metres, for "send to nearby player"
Config.SendOutfitCooldown = 10           -- seconds between sends
Config.Gallery = {
    enabled = true,
    pageSize = 24,
    maxPostsPerPlayer = 15,
    publishCooldown = 60,                -- seconds
}

-- ───────────────────────────── Outfit bag ─────────────────────────────
Config.OutfitBag = {
    item = 'mezos_outfitbag',
    maxOutfits = 10,                     -- outfits a single bag can hold
    prop = 'prop_cs_heist_bag_01',
    changeDuration = 3500,               -- ms of the changing animation
    soldInClothingStores = true,
}

-- ───────────────────────────── Tattoo parlor ─────────────────────────────
-- Clothes come off so designs are visible. Preview only: nothing is saved or charged,
-- and the outfit is put back when the menu closes. Players can toggle it in the menu.
Config.Tattoo = {
    undressOnOpen = true,                -- strip automatically when the parlor opens
    -- component id -> drawable used while undressed (freemode peds only)
    undress = {
        male = {
            [1] = 0,   -- mask
            [3] = 15,  -- arms (bare)
            [4] = 61,  -- pants -> boxers
            [5] = 0,   -- bag
            [6] = 34,  -- shoes -> barefoot
            [7] = 0,   -- accessory
            [8] = 15,  -- t-shirt (none)
            [9] = 0,   -- vest
            [10] = 0,  -- decals
            [11] = 15, -- torso (none)
        },
        female = {
            [1] = 0,
            [3] = 15,
            [4] = 15,  -- pants -> underwear
            [5] = 0,
            [6] = 35,  -- barefoot
            [7] = 0,
            [8] = 14,  -- t-shirt (none)
            [9] = 0,
            [10] = 0,
            [11] = 15, -- torso (bra)
        },
    },
    props = { 0, 1, 6, 7 },              -- hat, glasses, watch, bracelet come off too
}

-- ───────────────────────────── Blips ─────────────────────────────
Config.Blips = {
    clothing = { sprite = 73,  color = 47, scale = 0.7, label = 'Clothing Store' },
    barber   = { sprite = 71,  color = 0,  scale = 0.7, label = 'Barber Shop' },
    tattoo   = { sprite = 75,  color = 1,  scale = 0.7, label = 'Tattoo Parlor' },
    surgeon  = { sprite = 102, color = 4,  scale = 0.7, label = 'Plastic Surgeon' },
    outfit   = false,                    -- outfit changers have no blip
}
