if NoobgamKdfProfiles == nil then
    NoobgamKdfProfiles = {
        -- thornmarch
        [1067] = {
            name = "Thornmarch (Hard)",
            mesh = "[Trial] Thornmarch",
            dutyid = 1067,
            level = 50,
            expansion = 2,
            creator = "Rinn",
            notes = "",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 0, y = 0, z = -10}},
            },
            interactdistance = 50,
            interacts = {
                [1] = {contentid = 228, priority = 1, type = "Loot"},
                -- Mog Weapons
            },
            bossids = {
                725, -- Good King Moggle Mog XII -- Good King Moggle Mog XII Card & Moggle Mog XII's Whisker
            },
            enemytargetdistance = 50,
            prioritytarget = {
                [1] = {contentid = 718, priority = 3, type = "PLD"}, -- Whiskerwall Kupdi Koop
                [2] = {contentid = 719, priority = 2, type = "WAR"}, -- Ruffletuft Kupta Kapa
                [3] = {contentid = 720, priority = 1, type = "WHM"}, -- Furryfoot Kupli Kipp
                [4] = {contentid = 723, priority = 4, type = "BRD"}, -- Puksi Piko the Shaggysong
                [5] = {contentid = 721, priority = 7, type = "ARC"}, -- Woolywart Kupqu Kogi
                [6] = {contentid = 722, priority = 5, type = "BLM"}, -- Pukla Puki the Pomburner
                [7] = {contentid = 724, priority = 6, type = "ROG"}, -- Pukna Pako the Tailturner
            },
            avoidentity = {},
        },
        [778] = {
            name = "Castrum Fluminis",
            mesh = "",
            dutyid = 778,
            level = 70,
            expansion = 4,
            creator = "Mist",
            notes = "",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100.02 , y = 0.20, z = 99.74}},
            },
            interacts = {},
            bossids = {
                7225, -- Tsukuyomi -- Tsukuyomi Card
            },
            forcemeleerange = {7225},
            prioritytarget = {
                [1] = {contentid = 7230, priority = 1, type = "Midnight Haze"},
                [2] = {contentid = 7227, priority = 2, type = "Specter of the Patriarch"},
                [3] = {contentid = 7228, priority = 2, type = "Specter of the Matriarch"},
                [4] = {contentid = 7233, priority = 2, type = "Specter of the Homeland"},
                [5] = {contentid = 7234, priority = 2, type = "Specter of the Empire"},
                [6] = {contentid = 7225, priority = 2, type = "Specter of Asahi"},
                [7] = {contentid = 7476, priority = 2, type = "Specter of Asahi"},
                [8] = {contentid = 7537, priority = 2, type = "Specter of Zenos"},
            },
            -- avoidentity = {
            -- [1] = {contentid=7229, radius=10, type="circle"}, -- Dancing Fan
            -- },
            tankat = {
                [1] = {contentid = 7225, frompercent = 100, topercent = 0, pos = {x = 100.02 ,y = 0.20,z =  99.74}},
            },
            advancedavoid = {
                [1] = {
                    castingid = 11238, -- Lead of the Underworld
                    type = "singlefixed",
                    pos = { -- South far
                        [1] = {x = 100.02 , y = 0.20, z = 99.74},
                        [2] = {x = 100.02 , y = 0.20, z = 99.74},
                        [3] = {x = 100.02 , y = 0.20, z = 99.74},
                        [4] = {x = 100.02 , y = 0.20, z = 99.74},
                        [5] = {x = 100.02 , y = 0.20, z = 99.74},
                        [6] = {x = 100.02 , y = 0.20, z = 99.74},
                        [7] = {x = 100.02 , y = 0.20, z = 99.74},
                        [8] = {x = 100.02 , y = 0.20, z = 99.74},
                    },
                },
                [2] = {
                    castingid = 11259, -- Lunacy
                    type = "singlefixed",
                    pos = { -- South far
                        [1] = {x = 100.02 , y = 0.20, z = 99.74},
                        [2] = {x = 100.02 , y = 0.20, z = 99.74},
                        [3] = {x = 100.02 , y = 0.20, z = 99.74},
                        [4] = {x = 100.02 , y = 0.20, z = 99.74},
                        [5] = {x = 100.02 , y = 0.20, z = 99.74},
                        [6] = {x = 100.02 , y = 0.20, z = 99.74},
                        [7] = {x = 100.02 , y = 0.20, z = 99.74},
                        [8] = {x = 100.02 , y = 0.20, z = 99.74},
                    },
                },
            [3] = {
                    castingid = 11249, -- Selenomancy
                    type = "singlefixed",
                    pos = { -- Center
                        [1] = {x = 100.02 , y = 0.20, z = 99.74},
                        [2] = {x = 100.02 , y = 0.20, z = 99.74},
                        [3] = {x = 100.02 , y = 0.20, z = 99.74},
                        [4] = {x = 100.02 , y = 0.20, z = 99.74},
                        [5] = {x = 100.02 , y = 0.20, z = 99.74},
                        [6] = {x = 100.02 , y = 0.20, z = 99.74},
                        [7] = {x = 100.02 , y = 0.20, z = 99.74},
                        [8] = {x = 100.02 , y = 0.20, z = 99.74},
                    },
                },
            [4] = {
                castingid = 11379, -- Lunar Halo
                type = "movetoentity",
                entitylist = "contentid=7231,maxdistance10",
                targetable = false
            },
            -- [5] = {
                -- 	castingid = 11235, -- Torment Unto Death
                -- 	type = "setdistance",
                -- 	dist = 5
            -- },
            -- [6] = {
                    -- 	castingid = 11244, -- Zashiki-asobi (fans start)
                    -- 	type = "singlefixed",
                    --  pos = { -- Center
                        -- [1] = {x = 100.02 , y = 0.20, z = 99.74},
                        -- [2] = {x = 100.02 , y = 0.20, z = 99.74},
                        -- [3] = {x = 100.02 , y = 0.20, z = 99.74},
                        -- [4] = {x = 100.02 , y = 0.20, z = 99.74},
                        -- [5] = {x = 100.02 , y = 0.20, z = 99.74},
                        -- [6] = {x = 100.02 , y = 0.20, z = 99.74},
                        -- [7] = {x = 100.02 , y = 0.20, z = 99.74},
                        -- [8] = {x = 100.02 , y = 0.20, z = 99.74},
                    --   },
                -- },
            }, -- advancedavoid
            hasbuff = {
            [1] = {
                    buffid = 1538, -- Moonlit
                    type = "move",
                    stacksrequired = 2,
                    pos = { -- East close
                        [1] = {x = 103.07 , y = 0.20, z = 100.17},
                        [2] = {x = 103.07 , y = 0.20, z = 100.17},
                        [3] = {x = 103.07 , y = 0.20, z = 100.17},
                        [4] = {x = 103.07 , y = 0.20, z = 100.17},
                        [5] = {x = 103.07 , y = 0.20, z = 100.17},
                        [6] = {x = 103.07 , y = 0.20, z = 100.17},
                        [7] = {x = 103.07 , y = 0.20, z = 100.17},
                        [8] = {x = 103.07 , y = 0.20, z = 100.17},
                    },
                },
            [2] = {
                    buffid = 1539, -- Moonshadowed
                    type = "move",
                    stacksrequired = 2,
                    pos = { -- West close
                        [1] = {x =  96.42 , y = 0.20, z = 100.04},
                        [2] = {x =  96.42 , y = 0.20, z = 100.04},
                        [3] = {x =  96.42 , y = 0.20, z = 100.04},
                        [4] = {x =  96.42 , y = 0.20, z = 100.04},
                        [5] = {x =  96.42 , y = 0.20, z = 100.04},
                        [6] = {x =  96.42 , y = 0.20, z = 100.04},
                        [7] = {x =  96.42 , y = 0.20, z = 100.04},
                        [8] = {x =  96.42 , y = 0.20, z = 100.04},
                    },
                },
            },
            excludeavoid = {
                11238, -- Lead of the Underworld (stack)
                11259, -- Lunacy (stack)
                11379, -- Lunar Halo (orb - donut aoe)
                -- 11245, -- Tsuki-no-Maiogi (fans)
            },
        },
        [845] = {
            name = "The Dancing Plague",
            mesh = "[Trial] The Dancing Plague",
            dutyid = 845,
            level = 73,
            expansion = 5,
            creator = "Kitanoi",
            notes = "Requires 8 characters.\n\n2 tanks, 2 healers, 4 dps.\nExpect occassional deaths, but will win.",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {},
            bossids = {
                8361, -- Titania -- Titania Card
            },
            enemytargetdistance = 60,
            prioritytarget = {
                [1] = {contentid = 8359, priority = 1, type = "blue boys"},
            },
            tankat = {
                [1] = {contentid = 8361, frompercent = 100, pos = {x = 100, y = 0, z = 105}, topercent = 0},
            },
            incombatinteract = {},
            advancedavoid = {
                [1] = {type = "custom", customdetails = "libraryfunction", functioncode = "KitanoiFuncs.DFTitania()"},
            },
            overheadmarkers = {},
            tankbuster = {18175,15707,15690},
        },
        [846] = {
            name = "The Crown of the Immaculate",
            mesh = "",
            dutyid = 846,
            level = 79,
            expansion = 5,
            creator = "HeavenL",
            notes = "Requires 8 characters.\n\n2 tanks, 2 healers, 4 dps.",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 105}},
                [2] = {objective = 2, pos = {x = 100, y = 0, z = 105}},
            },
            interacts = {
                [1] = {contentid = 2000139, priority = 1, req = {type = "noenemy"}, type = "Exit"},
            },
            bossids = {
                8353, -- Innocence -- Innocence Card
            },
            enemytargetdistance = 30,
            prioritytargetdistance = 20,
            prioritytarget = {
                [1] = {contentid = 8268, priority = 1, type = "Desire"},
                [2] = {contentid = 8394, priority = 2, type = "Shame"},
                [3] = {contentid = 8353, priority = 3, type = "Innocence"},
            },
            advancedavoid = {
                [1] = {castingid = 16071, type = "setdistancefrom", pos = {x = 118, y = 0, z = 100}, dist=0.2, desc="Out-of-Field Decay AOE"},
                [2] = {castingid = 16049, type = "setdistancefrom", pos = {x = 95, y = 0, z = 112}, dist=0.2, desc="Rotating AOE1"},
                [3] = {castingid = 16050, type = "setdistancefrom", pos = {x = 95, y = 0, z = 112}, dist=0.2, desc="Rotating AOE2"},
                [4] = {castingid = 16190, type = "setdistancefrom", pos = {x = 100, y = 0, z = 103}, dist=0.2, desc="Linear AoE Damage Distribution"},
                [5] = {castingid = 16053, type = "setdistancefrom", pos = {x = 96.72, y = 0, z = 108.67}, dist=0.2, desc="Eight-Direction Linear AOE"},
                [6] = {castingid = 16025, type = "setdistancefrom", pos = {x = 100, y = 0, z = 110}, dist=0.2, desc="Back-to-back tower assaults"},
                [7] = {castingid = 16025, type = "faceaway", desc="with one's back turned" },
                [8] = {castingid = 16019, type = "setdistancefrom", pos = {x = 100, y = 0, z = 97}, dist=0.2, desc="Multiple AOE gatherings"},
                [9] = {castingid = 16064, type = "custom", customdetails = "function", functionname = "customfunction",	functioncode = [[
                        KitanoiSettings = KitanoiSettings or {}
                        KitanoiSettings.DFTimer = KitanoiSettings.DFTimer or 0
                        local now = (Now and Now()) or ((os and os.clock) and os.clock() * 1000) or 0
                        if KitanoiSettings.DFTimer == 0 then
                            KitanoiSettings.DFTimer = now
                            return
                        end
                        local elapsed = TimeSince and TimeSince(KitanoiSettings.DFTimer) or (now - (KitanoiSettings.DFTimer or 0))
                        if elapsed < 12000 then
                            local plist = EntityList and EntityList.myparty
                            if plist then
                                for _, e in pairs(plist) do
                                    if e and e.id ~= Player.id and e.pos then
                                        local x, y, z = e.pos.x, e.pos.y, e.pos.z
                                        if KitanoiNavigation and KitanoiNavigation.NavAPI and KitanoiNavigation.NavAPI.MoveTo then
                                            KitanoiNavigation.NavAPI.MoveTo(x, y, z)
                                        elseif Player and Player.MoveTo then
                                            Player:MoveTo(x, y, z)
                                        end
                                        break
                                    end
                                end
                            end
                        else
                            KitanoiSettings.DFTimer = 0
                        end
                    ]]
                },
            },
            overheadmarkers = {},
            excludeavoid = {16060,16062,16063},
        },
        [847] = {
            name = "The Dying Gasp",
            mesh = "",
            dutyid = 847,
            level = 80,
            expansion = 5,
            creator = "Noobgam",
            notes = "Requires 8 characters.\n\n2 tanks, 2 healers, 4 dps.",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {
                [1] = {contentid = 2000139, priority = 1, req = {type = "noenemy"}, type = "Exit"},
            },
            tankat = {
                [1] = {contentid = 8352, frompercent = 100, topercent = 0, pos = {x = 100, y = 0, z = 100}},
            },
            bossids = {
                8352, -- Hades
            },
            enemytargetdistance = 40,
            prioritytargetdistance = 40,
            prioritytarget = {
                [1] = {contentid = 8352, priority = 1, type = "Hades"},
                [2] = {contentid = 8826, priority = 2, type = "Shadow of the Ancients"},
            },
            advancedavoid = {
            },
            overheadmarkers = {},
            excludeavoid = {

            },
        },
        [922] = {
            name = "The Seat of Sacrifice",
            mesh = "[KDF] - The Seat of Sacrifice",
            dutyid = 922,
            level = 80,
            expansion = 5,
            creator = "Kitanoi",
            notes = "Requires 8 characters.\n\n2 tanks, 2 healers, 4 dps (ranged ideally)\n\nThere will be wipes.\nFalling meteors and Sword of Light aren't detected so you need to run until favorable locations are used.",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {},
            bossids = {
                9462, -- Warrior of Light -- Shadowbringers Warrior of Light Card
            },
            forcemeleerange = {},
            enemytargetdistance = 50,
            prioritytarget = {
                [1] = {contentid = 8531, priority = 1, type = "Gaol"},
            },
            avoidentity = {},
            tankat = {},
            advancedavoid = {
                [1] = {type = "custom", customdetails = "libraryfunction", functioncode = "KitanoiFuncs.WoLStory()"},
                [2] = {
                    castingid = 16722,
                    pos = {
                        [1] = {x = 92.5, y = 0, z = 92.5},
                        [2] = {x = 92.5, y = 0, z = 107.5},
                        [3] = {x = 107.5, y = 0, z = 92.5},
                        [4] = {x = 107.5, y = 0, z = 107.5},
                        [5] = {x = 100, y = 0, z = 110},
                        [6] = {x = 110, y = 0, z = 100},
                        [7] = {x = 100, y = 0, z = 90},
                        [8] = {x = 90, y = 0, z = 100},
                    },
                    type = "multifixed",
                },
                [3] = {
                    castingid = 17811,
                    pos = {
                        [1] = {x = 92.5, y = 0, z = 92.5},
                        [2] = {x = 92.5, y = 0, z = 107.5},
                        [3] = {x = 107.5, y = 0, z = 92.5},
                        [4] = {x = 107.5, y = 0, z = 107.5},
                        [5] = {x = 100, y = 0, z = 110},
                        [6] = {x = 110, y = 0, z = 100},
                        [7] = {x = 100, y = 0, z = 90},
                        [8] = {x = 90, y = 0, z = 100},
                    },
                    type = "multifixed",
                },
                [4] = {
                    castingid = 16744,
                    pos = {
                        [1] = {x = 92.5, y = 0, z = 92.5},
                        [2] = {x = 92.5, y = 0, z = 107.5},
                        [3] = {x = 107.5, y = 0, z = 92.5},
                        [4] = {x = 107.5, y = 0, z = 107.5},
                        [5] = {x = 100, y = 0, z = 110},
                        [6] = {x = 110, y = 0, z = 100},
                        [7] = {x = 100, y = 0, z = 90},
                        [8] = {x = 90, y = 0, z = 100},
                    },
                    type = "multifixed",
                },
            },
            hasbuff = {},
            overheadmarkers = {
                [1] = {
                    contentid = "9462",
                    desc = "ice marker",
                    detectwho = "any",
                    id = 225,
                    pos = {},
                    returnpos = {},
                    timetoreturn = 5,
                    type = "justrecord",
                },
                [2] = {
                    contentid = "9462",
                    desc = "single arrow marker",
                    detectwho = "any",
                    id = 87,
                    returnpos = {},
                    timetoreturn = 8,
                    type = "justrecord",
                },
                [3] = {
                    contentid = "9462",
                    desc = "stakc marker",
                    detectwho = "any",
                    id = 161,
                    returnpos = {},
                    timetoreturn = 8,
                    type = "justrecord",
                },
                [4] = {
                    contentid = "9462",
                    desc = "red markers",
                    detectwho = "any",
                    id = 234,
                    returnpos = {},
                    timetoreturn = 8,
                    type = "justrecord",
                },
                [5] = {
                    contentid = "9462",
                    desc = "big purple markers",
                    detectwho = "any",
                    id = 233,
                    returnpos = {},
                    timetoreturn = 8,
                    type = "justrecord",
                },
            },
            excludeavoid = {20250,20251},
            puddledata = {},
            dontcastwhenmoving = true,
        }
    }
end

return NoobgamKdfProfiles