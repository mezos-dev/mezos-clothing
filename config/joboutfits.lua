-- Job / gang uniforms. Migrated verbatim from qb-clothing.
-- Structure: Config.Outfits[job][gender][gradeLevel] = { { outfitLabel = '', outfitData = { ... } }, ... }
Config = Config or {}

Config.Outfits = {
    ['police'] = {
        -- Job
        ['male'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { texture = 0, item = 24, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 19, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                }
            },
            -- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 19, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                }
            },
            -- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 19, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 8, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 3, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                }
            },
            -- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 19, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 8, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 3, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [5] = {
                    outfitLabel = 'SWAT',
                    outfitData = {
                        ['pants'] = { item = 130, texture = 1, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['arms'] = { item = 172, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Arms
                        ['t-shirt'] = { item = 15, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- T Shirt
                        ['vest'] = { item = 15, texture = 2, defaultItem = 0, defaultTexture = 0 },     -- Body Vest
                        ['torso2'] = { item = 336, texture = 3, defaultItem = 0, defaultTexture = 0 },  -- Jacket
                        ['shoes'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['accessory'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['hat'] = { item = 150, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['mask'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 }      -- Mask
                    }
                }
            },
            -- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 19, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 },   -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        ['pants'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Pants
                        ['arms'] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Body Vest
                        ['torso2'] = { item = 317, texture = 8, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 51, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 58, texture = 3, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [5] = {
                    outfitLabel = 'SWAT',
                    outfitData = {
                        ['pants'] = { item = 130, texture = 1, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['arms'] = { item = 172, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Arms
                        ['t-shirt'] = { item = 15, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- T Shirt
                        ['vest'] = { item = 15, texture = 2, defaultItem = 0, defaultTexture = 0 },     -- Body Vest
                        ['torso2'] = { item = 336, texture = 3, defaultItem = 0, defaultTexture = 0 },  -- Jacket
                        ['shoes'] = { item = 24, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['accessory'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['hat'] = { item = 150, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['mask'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 }      -- Mask
                    }
                }
            }
        },
        ['female'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 48, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                }
            },
            -- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 48, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                }
            },
            -- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 48, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 8, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                }
            },
            -- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 48, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 8, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [5] = {
                    outfitLabel = 'Swat',
                    outfitData = {
                        ['pants'] = { item = 135, texture = 1, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['arms'] = { item = 213, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Arms
                        ['t-shirt'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- T Shirt
                        ['vest'] = { item = 17, texture = 2, defaultItem = 0, defaultTexture = 0 },     -- Body Vest
                        ['torso2'] = { item = 327, texture = 8, defaultItem = 0, defaultTexture = 0 },  -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['accessory'] = { item = 102, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['hat'] = { item = 149, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['mask'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }      -- Mask
                    }
                }
            },
            -- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 48, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [2] = {
                    outfitLabel = 'Long Sleeve',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [3] = {
                    outfitLabel = 'Trooper Tan',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [4] = {
                    outfitLabel = 'Trooper Black',
                    outfitData = {
                        ['pants'] = { item = 133, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms'] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Body Vest
                        ['torso2'] = { item = 327, texture = 8, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Bag
                        ['hat'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Glasses
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }     -- Mask
                    }
                },
                [5] = {
                    outfitLabel = 'Swat',
                    outfitData = {
                        ['pants'] = { item = 135, texture = 1, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['arms'] = { item = 213, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Arms
                        ['t-shirt'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- T Shirt
                        ['vest'] = { item = 17, texture = 2, defaultItem = 0, defaultTexture = 0 },     -- Body Vest
                        ['torso2'] = { item = 327, texture = 8, defaultItem = 0, defaultTexture = 0 },  -- Jacket
                        ['shoes'] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['accessory'] = { item = 102, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['hat'] = { item = 149, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['mask'] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 }      -- Mask
                    }
                }
            }
        }
    },
    ['realestate'] = {
        -- Job
        ['male'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 28, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 294, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = 12, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 28, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 294, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = 12, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 28, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 294, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = 12, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 28, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 294, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = 12, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    -- Outfits
                    outfitLabel = 'Short Sleeve',
                    outfitData = {
                        ['pants']     = { item = 28, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 294, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = 12, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            }
        },
        ['female'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 57, texture = 2, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 105, texture = 7, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 8, texture = 5, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 11, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 57, texture = 2, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 105, texture = 7, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 8, texture = 5, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 11, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 57, texture = 2, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 105, texture = 7, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 8, texture = 5, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 11, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 57, texture = 2, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 105, texture = 7, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 8, texture = 5, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 11, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            },
            -- Gender
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'Worker',
                    outfitData = {
                        ['pants']     = { item = 57, texture = 2, defaultItem = 0, defaultTexture = 0 }, -- Pants
                        ['arms']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Arms
                        ['t-shirt']   = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T Shirt
                        ['vest']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Body Vest
                        ['torso2']    = { item = 105, texture = 7, defaultItem = 0, defaultTexture = 0 }, -- Jacket
                        ['shoes']     = { item = 8, texture = 5, defaultItem = 0, defaultTexture = 0 }, -- Shoes
                        ['accessory'] = { item = 11, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- Neck Accessory
                        ['bag']       = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Bag
                        ['hat']       = { item = -1, texture = -1, defaultItem = 0, defaultTexture = 0 }, -- Hat
                        ['glass']     = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Glasses
                        ['mask']      = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Mask
                    }
                }
            }
        }
    },
    ['ambulance'] = {
        -- Job
        ['male'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 85, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 129, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 250, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 127, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                }
            },
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 85, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 129, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 250, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 127, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                }
            },
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 85, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 129, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 250, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 127, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = { item = 90, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 15, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- T-Shirt
                        ['torso2'] = { item = 249, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 57, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 126, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                }
            },
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 85, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 129, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 250, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 127, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = { item = 90, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 15, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- T-Shirt
                        ['torso2'] = { item = 249, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 57, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 126, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = { item = 93, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 32, texture = 3, defaultItem = 0, defaultTexture = 0 },  -- T-Shirt
                        ['torso2'] = { item = 31, texture = 7, defaultItem = 0, defaultTexture = 0 },   -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Decals
                        ['accessory'] = { item = 126, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 28, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Mask
                        ['hat'] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                }
            },
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 85, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 129, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 250, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 58, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 127, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = { item = 90, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 15, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- T-Shirt
                        ['torso2'] = { item = 249, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 57, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 126, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 54, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Mask
                        ['hat'] = { item = 122, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = { item = 93, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Arms
                        ['t-shirt'] = { item = 32, texture = 3, defaultItem = 0, defaultTexture = 0 },  -- T-Shirt
                        ['torso2'] = { item = 31, texture = 7, defaultItem = 0, defaultTexture = 0 },   -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Vest
                        ['decals'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Decals
                        ['accessory'] = { item = 126, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },       -- Bag
                        ['pants'] = { item = 28, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Pants
                        ['shoes'] = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Shoes
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Mask
                        ['hat'] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }        -- Ear accessories
                    }
                }
            }
        },
        ['female'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 109, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 159, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 258, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 66, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 97, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                }
            },
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 109, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 159, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 258, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 66, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 97, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                }
            },
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 109, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 159, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 258, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 66, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 97, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = { item = 105, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 13, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 257, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 65, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                }
            },
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 109, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 159, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 258, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 66, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 97, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = { item = 105, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 13, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 257, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 65, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = { item = 105, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 39, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 7, texture = 1, defaultItem = 0, defaultTexture = 0 },   -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 29, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Mask
                        ['hat'] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                }
            },
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = { item = 109, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 159, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 258, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 66, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 97, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = { item = 105, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 13, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 257, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 65, texture = 0, defaultItem = 0, defaultTexture = 0 },  -- Decals
                        ['accessory'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 99, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 55, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Mask
                        ['hat'] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = { item = 105, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Arms
                        ['t-shirt'] = { item = 39, texture = 3, defaultItem = 0, defaultTexture = 0 }, -- T-Shirt
                        ['torso2'] = { item = 7, texture = 1, defaultItem = 0, defaultTexture = 0 },   -- Jackets
                        ['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Vest
                        ['decals'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Decals
                        ['accessory'] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- Neck
                        ['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },      -- Bag
                        ['pants'] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Pants
                        ['shoes'] = { item = 29, texture = 0, defaultItem = 0, defaultTexture = 0 },   -- Shoes
                        ['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Mask
                        ['hat'] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },     -- Hat
                        ['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },    -- Glasses
                        ['ear'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }       -- Ear accessories
                    }
                }
            }
        }
    }
}
