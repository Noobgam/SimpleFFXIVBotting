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
        },
        [992] = {
            name = "The Dark Inside (Story) US",
            mesh = "[Trial] The Dark Inside",
            dutyid = 992,
            level = 83,
            expansion = 6,
            creator = "Kitanoi",
            notes = "Requires 8 accounts, requires Exe.\nExtremely healer intensive during styx, if your healer ACR cannot handle it, manually heal on 1 character. Or take 3 healers and 1 tank.",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 98, y = 0, z = 115}},
            },
            interacts = {},
            bossids = {
                10456, -- Zodiark
            },
            forcemeleerange = {10456},
            enemytargetdistance = 80,
            prioritytarget = {},
            tankat = {
                [1] = {contentid = 10456, desc = "Tank Zodiark at this pos from 100-1%", frompercent = 100, pos = {x = 115.25, y = 0, z = 85.41}, topercent = 0},
            },
            advancedavoid = {
                [1] = {
                    type = "custom",
                    customdetails = "function",
                    functionname = "customfunction",
                    functioncode = [[
                        function customfunction()
                            NoobgamKdfProfiles.FarmEcho(5, 70, 0, 120)
                        end
                    ]]
                },
                [2] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "316", "false") == true) then
                                if (ActionList:Get(131):IsReady()) then
                                    ActionList:Get(131):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [3] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "316", "false") == true) then
                                if (ActionList:Get(25873):IsReady()) then
                                    ActionList:Get(25873):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [4] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "316", "false") == true) then
                                if (ActionList:Get(3600):IsReady()) then
                                    ActionList:Get(3600):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [5] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "316", "false") == true) then
                                if (ActionList:Get(124):IsReady()) then
                                    ActionList:Get(124):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [6] = {type = "custom", customdetails = "libraryfunction",functioncode = "KitanoiFuncs.ZodiarkStory()"},
            },
            hasbuff = {},
            overheadmarkers = {
                [1] = {
                    contentid = "10456",
                    desc = "Ania",
                    detectwho = "me",
                    id = 218,
                    pos = {[1] = {x = 83.2, y = 0, z = 85.8}},
                    returnpos = {[1] = {x = 115.8, y = 0, z = 85.8}},
                    timetoreturn = 10,
                    type = "move",
                },
                [2] = {
                    contentid = "10456",
                    desc = "Styx",
                    detectwho = "any",
                    id = 316,
                    pos = {
                        [1] = {x = 100, y = 0, z = 100},
                        [2] = {x = 100, y = 0, z = 100},
                        [3] = {x = 100, y = 0, z = 100},
                        [4] = {x = 100, y = 0, z = 100},
                        [5] = {x = 100, y = 0, z = 100},
                        [6] = {x = 100, y = 0, z = 100},
                        [7] = {x = 100, y = 0, z = 100},
                        [8] = {x = 100, y = 0, z = 100},
                    },
                    returnpos = {},
                    timetoreturn = 10,
                    type = "move",
                },
            },
            excludeavoid = {},
            dontexcludeaoe = {26579},
            limitbreak = {
                [1] = {contentid = 10456, level = 1, percent = 15, type = "ranged"},
                [2] = {contentid = 10456, level = 2, percent = 15, type = "ranged"},
                [3] = {contentid = 10456, level = 3, percent = 15, type = "ranged"},
            },
            meleeavoid = false,
        },
        [997] = {
            name = "The Final Day",
            mesh = "[Trial] The Final Day",
            dutyid = 997,
            level = 90,
            expansion = 6,
            creator = "Hikari/Kitanoi",
            notes = "",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {},
            bossids = {
                10448, -- The Endsinger -- Meteion Card
            },
            enemytargetdistance = 50,
            prioritytarget = {},
            avoidentity = {
                [1] = {contentid = 10443, radius = 7},
            },
            tankat = {},
            advancedavoid = {
                [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "27753", "27754", "false") == true) then
                                if (ActionList:Get(1, 7548):IsReady()) then
                                    ActionList:Get(1, 7548):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [2] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "27753", "27754", "false") == true) then
                                if (ActionList:Get(1, 7559):IsReady()) then
                                    ActionList:Get(1, 7559):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [3] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "27753", "27754", "false") == true) then
                                if (ActionList:Get(1, 3):IsReady()) then
                                    ActionList:Get(1, 3):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [4] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (ScanForCaster("", "100", "27753", "27754", "false") == true) then
                                if (ActionList:Get(1, 7388):IsReady()) then
                                    ActionList:Get(1, 7388):Cast(Player.id)
                                end
                            end
                        end
                    ]]
                },
                [5] = {
                    castingid = 26185,
                    pos = {
                        [1] = {x = 84.99, y = 0, z = 95.73},
                        [2] = {x = 88.92, y = 0, z = 99.48},
                        [3] = {x = 93.13, y = 0, z = 101.62},
                        [4] = {x = 98.5, y = 0, z = 102.73},
                        [5] = {x = 103.77, y = 0, z = 102.24},
                        [6] = {x = 107.33, y = 0, z = 101.26},
                        [7] = {x = 110.61, y = 0, z = 100.04},
                        [8] = {x = 114.24, y = 0, z = 98.15},
                    },
                    type = "multifixed",
                },
                [6] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local ents = MEntityList("contentid=10448,maxdistance=50")
                            if (ents ~= nil and TableSize(ents) > 0) then
                                for i, e in pairs(ents) do
                                    if (e ~= nil) then
                                        if (not e.targetable and math.distance2d({x = 100, y = 0, z = 88}, e.pos) < 2) then
                                            KitanoiNavigation.NavAPI.MoveTo(112, 0, 85)
                                            KitanoiSettings.avoidingtime = Now()
                                        elseif (not e.targetable and math.distance2d({x = 91.5, y = 0, z = 91.5}, e.pos) < 2) then
                                            KitanoiNavigation.NavAPI.MoveTo(100, 0, 81)
                                            KitanoiSettings.avoidingtime = Now()
                                        end
                                    end
                                end
                            end
                        end
                    ]]
                },
                [8] = {
                    castingid = 27754,
                    pos = {
                        [1] = {x = 100, y = 0, z = 100},
                        [2] = {x = 100, y = 0, z = 100},
                        [3] = {x = 100, y = 0, z = 100},
                        [4] = {x = 100, y = 0, z = 100},
                        [5] = {x = 100, y = 0, z = 100},
                        [6] = {x = 100, y = 0, z = 100},
                        [7] = {x = 100, y = 0, z = 100},
                        [8] = {x = 100, y = 0, z = 100},
                    },
                    type = "multifixed",
                },
                [9] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local target = Player:GetTarget()
                            if (Player.incombat and not target and KitanoiFuncs.HowManyAOES() == 0) then
                                if
                                    (KitanoiFuncs.ReturnSortedParty()[1] == Player.id or KitanoiFuncs.ReturnSortedParty()[2] == Player.id or
                                        KitanoiFuncs.ReturnSortedParty()[3] == Player.id or
                                        KitanoiFuncs.ReturnSortedParty()[4] == Player.id)
                                then
                                    KitanoiNavigation.NavAPI.MoveTo(91, 0, 100)
                                    KitanoiSettings.avoidingtime = Now()
                                elseif
                                    (KitanoiFuncs.ReturnSortedParty()[5] == Player.id or KitanoiFuncs.ReturnSortedParty()[6] == Player.id or
                                        KitanoiFuncs.ReturnSortedParty()[7] == Player.id or
                                        KitanoiFuncs.ReturnSortedParty()[8] == Player.id)
                                then
                                    KitanoiNavigation.NavAPI.MoveTo(107, 0, 104)
                                    KitanoiSettings.avoidingtime = Now()
                                end
                            end
                        end
                    ]]
                },
                [10] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            if (Player.role == 1 and not MIsCasting() and KitanoiFuncs.ScanForCaster2(27481)) then
                                local action = ActionList:Get(5, 3)
                                if (action) then
                                    action:Cast(Player)
                                end
                            end
                        end
                    ]]
                },
                -- you can't solo it.
                -- [11] = {
                --     type = "custom",
                --     customdetails = "function",
                --     functionname = "customfunction",
                --     functioncode = [[
                --         function customfunction()
                --             NoobgamKdfProfiles.FarmEcho(5, 70, 0, 120)
                --         end
                --     ]]
                -- },
            },
            hasbuff = {},
            overheadmarkers = {},
            excludeavoid = {27754,26203},
            dontexcludeaoe = {26158,26171},
            tankbuster = {26195,26190},
        },
        [1071] = {
            name = "Storm's Crown",
            mesh = "Storm's Crown",
            dutyid = 1071,
            level = 90,
            expansion = 6,
            creator = "Noobgam",
            notes = "This is dogshit quality, doesn't do anything",
            queuetype = 2,
            FFA = false,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {},
            bossids = {
                10298, -- Barbariccia
            },
            enemytargetdistance = 50,
            prioritytarget = {},
            avoidentity = {
            },
            meshchange={
                [1] = {type = "castid", castid = 30130, newmesh = "Storm's Crown v2"},
            },
            tankat = {},
            dontexcludeaoe = {
                30146,
                30138,
                30144,
                30145,
                30147,
                30176,
                30140,
                30167,
                30158,
            },
            overheadmarkers={},
            tankbuster = {30135},
        }
    }

    ---@param echoStacks integer number of echo stacks to get
    ---@param x number x to walk off the cliff
    ---@param y number yto walk off the cliff
    ---@param z number z to walk off the cliff
    function NoobgamKdfProfiles.FarmEcho(echoStacks, x, y, z)
        if not Player.alive then
            ---@diagnostic disable-next-line: undefined-global
            KitanoiNavigation.NavAPI.Stop()
        end

        local echoStacksWeHave = KitanoiSettings.StoreVar.EchoStacks or 0

        if HasBuff(Player, 42) then
            local ctrls = GetControls()
            for _, ctrl in pairs(ctrls) do
                if ctrl.name == "_WideText" and ctrl:IsOpen() then                
                    local wideLine = ctrl:GetStrings()[3]
                    if wideLine ~= nil then
                        local percent = tonumber(wideLine:match("increased by (%d+)%%"))
                        if percent and echoStacksWeHave < percent / 10 then
                            echoStacksWeHave = percent / 10
                            d("[EchoStacker] detected " .. echoStacksWeHave .. " from wide text")
                        end
                    end
                end
            end
            local chatlines = GetChatLines()
            -- DGAF. Just rely on chat going fast.
            for _, v in pairs(chatlines) do
                if v.code == 57 and v.subcode == 8 then
                    local percent = tonumber(v.line:match("increased by (%d+)%%"))
                    if percent and echoStacksWeHave < percent / 10 then
                        echoStacksWeHave = percent / 10
                        d("[EchoStacker] detected " .. echoStacksWeHave .. " from chat")
                    end
                end
            end
        else
            echoStacksWeHave = 0
        end

        KitanoiSettings.StoreVar.EchoStacks = echoStacksWeHave
        if echoStacksWeHave < echoStacks and TimeSince(KitanoiSettings.InCombatTimer) > 60 * 1000 * 3 then
            ---@diagnostic disable-next-line: undefined-global
            KitanoiNavigation.NavAPI.MoveTo(x, y, z)
            KitanoiSettings.avoidingtime = Now() + 2000
            KitanoiSettings.DisableKDFAvoidance = true
        else
            KitanoiSettings.DisableKDFAvoidance = false
        end
    end
end

return NoobgamKdfProfiles