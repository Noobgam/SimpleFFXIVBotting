if NoobgamKdfProfiles == nil then
    local function log(message)
        d("[NoobgamKdfProfiles] " .. message)
    end

    NoobgamKdfProfiles = {}

    NoobgamKdfProfiles.DungeonProfiles = {
        [674] = {
            name = "The Pool of Tribute",
            mesh = "[Trial] The Pool Of Tribute",
            dutyid = 674,
            level = 63,
            expansion = 4,
            creator = "Mist",
            notes = "",
            queuetype = 2,
            FFA = true,
            hacks = false,
            requeuetimer = 10,
            enemytargetdistance = 50,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = -0.76, y = -0.12, z = -12.85}},
            },
            interacts = {},
            bossids = {
                6221, -- Susano -- Susano Card
            },
            prioritytarget = {
                [1] = {contentid = 6225, priority = 1, type = "Blade"},
                [2] = {contentid = 6224, priority = 2, type = "Boulders"},
            },
            tankat = {
                [1] = {contentid = 6221, frompercent = 100, topercent = 0, pos = {x = -0.25, y = -0.12, z = -5.10}},
            },
            incombatinteract = {
            },
            advancedavoid = {
                [1] = {castingid = 9506, type = "multifixed", pos = {
                        [1] = {x = 19.47, y = -0.12, z = -0.09},
                        [2] = {x = -19.50, y = -0.12, z = -0.13},
                        [3] = {x = 19.47, y = -0.12, z = -0.09},
                        [4] = {x = -19.50, y = -0.12, z = -0.13},
                        [5] = {x = 19.47, y = -0.12, z = -0.09},
                        [6] = {x = -19.50, y = -0.12, z = -0.13},
                        [7] = {x = 19.47, y = -0.12, z = -0.09},
                        [8] = {x = -19.50, y = -0.12, z = -0.13},
                    },
                },
                [2] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                    function customfunction()
                        local hasHigherLevel = false
                        for _, v in pairs(EntityList.myparty) do
                            local ent = EntityList:Get(v.id)
                            if ent and ent.alive and ent.id ~= Player.id and ent.level >= Player.level then
                                hasHigherLevel = true
                                break
                            end
                        end
                        if not hasHigherLevel then
                            return
                        end
                        local sword = nil
                        for _, v in pairs(EntityList("contentid=2008185,targetable")) do
                            if sword == nil or sword.id > v.id then
                                sword = v
                            end
                        end
                        if sword == nil then
                            return
                        end
                        if NoobgamUtils.calculateDist(Player.pos, sword.pos) > 2 then
                            Player:MoveTo(sword.pos.x, sword.pos.y, sword.pos.z)
                            KitanoiSettings.avoidingtime = Now()
                        else
                            Player:Stop()
                            Player:Interact(sword.id)
                            KitanoiSettings.avoidingtime = Now()
                        end
                    end
                ]]},
            },
            overheadmarkers = {
                [1] = {id = 23, contentid = "6221", desc = "spread", type = "move", detectwho = "me", pos = {
                        [1] = {x = -13.83, y = -0.12, z = -0.01},
                        [2] = {x = -10.56, y = -0.12, z = -6.11},
                        [3] = {x = 6.60, y = -0.12, z = -12.36},
                        [4] = {x = 13.75, y = -0.12, z = -0.10},
                        [5] = {x = 10.96, y = -0.12, z = 5.41},
                        [6] = {x = 0.37, y = -0.12, z = 12.24},
                        [7] = {x = -6.75, y = -0.12, z = 12.36},
                        [8] = {x = -0.44, y = -0.12, z = -12.37},
                    },
                    returnpos = {
                        [1] = {x = 0.29, y = 0.40, z = 0.35},
                        [2] = {x = 0.29, y = 0.40, z = 0.35},
                        [3] = {x = 0.29, y = 0.40, z = 0.35},
                        [4] = {x = 0.29, y = 0.40, z = 0.35},
                        [5] = {x = 0.29, y = 0.40, z = 0.35},
                        [6] = {x = 0.29, y = 0.40, z = 0.35},
                        [7] = {x = 0.29, y = 0.40, z = 0.35},
                        [8] = {x = 0.29, y = 0.40, z = 0.35},
                    },
                    timetoreturn = 5,
                },
                [2] = {id = 62, contentid = "6221", desc = "stack", type = "move", detectwho = "any", pos = {
                        [1] = {x = 0.29, y = 0.40, z = 0.35},
                        [2] = {x = 0.29, y = 0.40, z = 0.35},
                        [3] = {x = 0.29, y = 0.40, z = 0.35},
                        [4] = {x = 0.29, y = 0.40, z = 0.35},
                        [5] = {x = 0.29, y = 0.40, z = 0.35},
                        [6] = {x = 0.29, y = 0.40, z = 0.35},
                        [7] = {x = 0.29, y = 0.40, z = 0.35},
                        [8] = {x = 0.29, y = 0.40, z = 0.35},
                    },
                    timetoreturn = 5,
                },
            },
        },
        [436] = {
            name = "The Limitless Blue (Hard) A",
            mesh = "[Trial] The Limitless Blue",
            dutyid = 436,
            level = 57,
            expansion = 3,
            creator = "Rinn",
            notes = "",
            queuetype = 2,
            FFA = true,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = -9.46, y = 0.0062, z = -0.439}},
                [2] = {objective = 1, pos = {x = -9.46, y = 0.0062, z = -0.439}},
            },
            interactdistance = 50,
            interacts = {},
            bossids = {
                3649, -- Bismarck -- Bismarck Card & (Bismarck's Baleen (Synced Only))
                3656, -- Chitin Carapace
                3657, -- Corona
            },
            forcemeleerange= {3654,3657,3656},
            enemytargetdistance = 50,
            prioritytarget = {
                [1] = {contentid = 3654, priority = 1, type = "phase 2 adds"},
            },
            ignoretarget = {},
            tankat = {
                [1] = {contentid = 3654, frompercent = 100, topercent = 1, pos = {x = -21.47, y = 0.258, z = 13.108}, desc = "tank boss 12345 at this pos from 100-95%"},
            },
            incombatinteract= {
                [1] = {interactid = 2005541, type = "interact", req = {castingid = 4010, desc = "Cetacean Rage Bismark Island"}, who = "closest", desc = "interact with something"},
                [2] = {interactid = 2005541, type = "interact", req = {castingid = 4918, desc = "Cetacean Rage Bismark Island"}, who = "closest", desc = "interact with something"},
                [3] = {interactid = 2005541, type = "interact", req = {castingid = 5075, desc = "Cetacean Rage Bismark Island"}, who = "closest", desc = "interact with something"},
                [4] = {interactid = "2005544;2005545", type = "interact", who = "closest", desc = "DragonKillers"},
            },
            advancedavoid = {
                [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        if not(next(Duty:GetActiveDutyObjectives())==nil)then
                            if Duty:GetActiveDutyObjectives()[2].values[1]==100 then
                                Player:MoveTo(-9.46,0.0062,-0.439)
                                d('Moving To Start Trial')
                                isOnCarapace=0;
                                onceStopAvoidance=0
                            end;
                            if HasBuff(Player.id,719)then
                                if isOnCarapace == 0 then
                                    d('IsOnCarapace')
                                end
                                isOnCarapace=1;
                                onceStopAvoidance=1
                            end;
                            if not HasBuff(Player.id,719)and onceStopAvoidance==1 then
                                onceStopAvoidance=0;
                                KitanoiSettings.avoidingtime=Now()
                                Player:Stop();
                                d('Stopping Avoidance')
                            end;
                            if not HasBuff(Player.id,719)and onceStopAvoidance==0 and isOnCarapace==1 then
                                KitanoiSettings.avoidingtime=Now();
                                d('Restarting Avoidance');
                                isOnCarapace=0
                            end
                        end
                        local DKsUp = KitanoiFuncs.MEntityList("targetable,contentid=2005544;2005545")
                        if (DKsUp) then
                            local counts = TableSize(DKsUp)
                            KitanoiSettings.DisableKDFAvoidance = true
                            if (counts >= 1) then
                                local action = ActionList:Get(1,3)
                                if ( action and action:IsReady() ) then
                                    action:Cast(Player)
                                end
                            end
                        else
                            if Player:GetTarget() == nil then
                                -- moving in to target carrapace
                                Player:MoveTo(-9.46,0.0062,-0.439)                                
                            end
                            KitanoiSettings.DisableKDFAvoidance = false
                        end
                    ]]
                },
            },
            excludeavoid = {4011,4035,4932,5081},
        },
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
            FFA = true,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 0, y = 0, z = -10}},
            },
            interactdistance = 50,
            interacts = {
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
        [679] = {
            name = "The Royal Menagerie",
            mesh = "The Royal Menagerie",
            dutyid = 679,
            level = 70,
            expansion = 4,
            creator = "Rinn",
            notes = "Meshes Required\nTidal Wave RNG at the start, but let it run until it finishes it one time for the MSQ",
            queuetype = 2,
            FFA = true,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 12.97, y = -380, z = -0.65}},
            },
            interacts = {},
            bossids = {
                5640, -- Shinryu -- Shinryu Card
            },
            enemytargetdistance = 50,
            prioritytarget = {
                [1] = {contentid = 5789, priority = 1, type = "Tail"},
            },
            tankat = {},
            advancedavoid = {
                [1] = {
                    castingid = 8075, --tidal wave basically random between right / left / behind (chose a corner behind <> left)
                    type = "multifixed",
                    pos = {
                        [1] = {x = -17.85, y = -380, z = -17.83},
                        [2] = {x = -17.85, y = -380, z = -17.83},
                        [3] = {x = -17.85, y = -380, z = -17.83},
                        [4] = {x = -17.85, y = -380, z = -17.83},
                        [5] = {x = -17.85, y = -380, z = -17.83},
                        [6] = {x = -17.85, y = -380, z = -17.83},
                        [7] = {x = -17.85, y = -380, z = -17.83},
                        [8] = {x = -17.85, y = -380, z = -17.83},
                    },
                },
                [2] = {
                    castingid = 8086, --cocoon aoe
                    type = "multifixed",
                    pos = {
                        [1] = {x = 0.56, y = -380, z = 16.94},
                        [2] = {x = 0.56, y = -380, z = 16.94},
                        [3] = {x = 0.56, y = -380, z = 16.94},
                        [4] = {x = 0.56, y = -380, z = 16.94},
                        [5] = {x = 0.56, y = -380, z = 16.94},
                        [6] = {x = 0.56, y = -380, z = 16.94},
                        [7] = {x = 0.56, y = -380, z = 16.94},
                        [8] = {x = 0.56, y = -380, z = 16.94},
                    },
                },
                [3] = {
                    castingid = 8080, --Aerial Blast
                    type = "multifixed",
                    pos = {
                        [1] = {x = -0.22, y = 620, z = -0.66},
                        [2] = {x = -0.22, y = 620, z = -0.66},
                        [3] = {x = -0.22, y = 620, z = -0.66},
                        [4] = {x = -0.22, y = 620, z = -0.66},
                        [5] = {x = -0.22, y = 620, z = -0.66},
                        [6] = {x = -0.22, y = 620, z = -0.66},
                        [7] = {x = -0.22, y = 620, z = -0.66},
                        [8] = {x = -0.22, y = 620, z = -0.66},
                    },
                },
                [4] = {
                    castingid = 8100, --Akh Morn
                    type = "multifixed",
                    pos = {
                        [1] = {x = 0.56, y = -380, z = -7.55},
                        [2] = {x = -8.41, y = -380, z = -7.67},
                        [3] = {x = -7.98, y = -380, z = 0.73},
                        [4] = {x = -8.46, y = -380, z = 7.91},
                        [5] = {x = -0.19, y = -380, z = 7.47},
                        [6] = {x = 7.69, y = -380, z = 7.85},
                        [7] = {x = 7.5, y = -380, z = -0.11},
                        [8] = {x = 7.37, y = -380, z = -7.9},
                    },
                },--to phase 2
                [5] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local targ = Player:GetTarget()
                            if (not targ) then
                                local shin = KitanoiFuncs.MEntityList("nearest,targetable,alive,name=5640")
                                if (shin~=nil) then
                                    local i,e = next(shin)
                                    if (i and e) then
                                        Player:SetTarget(i)
                                    end
                                end
                            end
                        end
                    ]]
                },
            },
            hasbuff = {},
            overheadmarkers = {
                [1] = {
                    id = 62,
                    contentid = "5640",
                    desc= "stack",
                    type = "move",
                    detectwho = "any",
                    pos =  {
                        [1] = {x = -0.22, y = 620, z = -0.66},
                        [2] = {x = -0.22, y = 620, z = -0.66},
                        [3] = {x = -0.22, y = 620, z = -0.66},
                        [4] = {x = -0.22, y = 620, z = -0.66},
                        [5] = {x = -0.22, y = 620, z = -0.66},
                        [6] = {x = -0.22, y = 620, z = -0.66},
                        [7] = {x = -0.22, y = 620, z = -0.66},
                        [8] = {x = -0.22, y = 620, z = -0.66},
                    }, --all move to same point to stack
                    timetoreturn = 5,
                },
            },
            excludeavoid = {},
        },
        [719] = {
            name = "Emanation",
            mesh = "[Trial] Emanation",
            dutyid = 719,
            level = 67,
            expansion = 4,
            creator = "Koyote/Rinn",
            notes = "",
            queuetype = 2,
            FFA = true,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {},
            bossids = {
                6385, -- Lakshmi -- Lakshmi Card
            },
            forcemeleerange = {6386},
            enemytargetdistance = 50,
            prioritytarget = {},
            tankat = {
                [1] = {contentid = 6386, frompercent = 100, topercent = 1, pos = {x = -4, y = 0, z = -3}, desc = "Tank at this pos from 100-1%"},
            },
            advancedavoid = {
                [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local a = MEntityList("contentid=6385")
                            if a ~= nil then
                                for b, c in pairs(a) do
                                    if c.action ~= nil then
                                        if c.action == 7748 then
                                            if ActionList:Get(5, 26):IsReady() then
                                                Player:Stop()
                                                ActionList:Get(5, 26):Cast()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    ]]
                },--to phase 2
            },
            hasbuff = {},
            overheadmarkers = {},
            excludeavoid = {},
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
            FFA = true,
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
            FFA = true,
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
            FFA = true,
            hacks = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {
            },
            bossids = {
                8353, -- Innocence -- Innocence Card
            },
            enemytargetdistance = 66,
            prioritytargetdistance = 60,
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
            FFA = true,
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
            },
            enemytargetdistance = 40,
            prioritytargetdistance = 40,
            prioritytarget = {
            },
            advancedavoid = {
                [1] = {
                    type = "custom",
                    customdetails = "function",
                    functionname = "customfunction",
                    functioncode = [[
                        function customfunction()
                            local count = NoobgamKdfProfiles.CountMaxLevel()
                            if count > 1 then
                                return
                            end
                            local enemies = MEntityList("targetable,contentid=8352")
                            local hades = nil
                            if table.valid(enemies) then
                            _, hades = next(enemies) 
                            end
                            if hades == nil or not hades.targetable then
                                -- p1 he becomes untargetable
                                NoobgamKdfProfiles.FarmEcho(5, 100, 0, 100, 0)
                            else
                                NoobgamKdfProfiles.FarmEcho(5, 100, 0, 100)
                            end
                        end
                    ]]
                },
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
            FFA = true,
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
            FFA = true,
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
                            local count = NoobgamKdfProfiles.CountMaxLevel()
                            if count > 1 then
                                return
                            end
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
            FFA = true,
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
            mesh = "[Trial] Storm's Crown",
            dutyid = 1071,
            level = 90,
            expansion = 6,
            creator = "Noobgam",
            notes = "This is dogshit quality, doesn't do anything",
            queuetype = 2,
            FFA = true,
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
                [1] = {contentid=10300, radius = 4}
            },
            meshchange={
            },
            advancedavoid={
                [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        if NoobgamKdfProfiles.TryingToWipe then
                            return
                        end
                        local targ = Player:GetTarget()
                        if (kdfscp2started == nil or kdfscp2started~=nil and not KitanoiFuncs.Player().incombat) then
                            kdfscp2started = false
                        end
                        local tankbusterdoublestack = KitanoiFuncs.ScanForCaster2(30135)
                        if (KitanoiFuncs.API.IsTank()) then
                            if (KitanoiFuncs.DetermineMainTank() ~= KitanoiFuncs.Player().id) then
                                local maintank = KitanoiFuncs.MGetEntity(KitanoiFuncs.DetermineMainTank())
                                if (maintank) then
                                    if (math.distance2d(KitanoiFuncs.Player().pos,maintank.pos)>4) then
                                        KitanoiNavigation.NavAPI.MoveTo(maintank.pos.x,maintank.pos.y,maintank.pos.z)
                                        kfcache.functions.SetAvoidanceTime(91892) KitanoiSettings.avoidingtime = KitanoiFuncs.Now()
                                    end
                                end
                            end
                        end	
                        if (NoobgamKdfProfiles.DoIHaveMarker(100) or NoobgamKdfProfiles.DoIHaveMarker(352)) then
                            local points = {
                                [1] = KitanoiFuncs.Player().pos,
                                [2] = {x=115,y=0,z=100},
                                [3] = {x=100,y=0,z=115}

                            }
                            if (KitanoiSettings.PathGenTime == 0 or KitanoiFuncs.TimeSince(KitanoiSettings.PathGenTime)>30000) then
                                for i,e in pairs(points) do
                                    if (e) then
                                        KitanoiFuncs.PathBuilder(e,i)
                                    end
                                end
                                
                                KitanoiSettings.PathGenTime = KitanoiFuncs.Now()
                            end		
                        end
                        if (KitanoiFuncs.IsMarkerUp(62) and not NoobgamKdfProfiles.DoIHaveMarker(352) and not NoobgamKdfProfiles.DoIHaveMarker(100)) then
                            local newpos = {x=90,y=0,z=100}
                            if (math.distance2d(KitanoiFuncs.Player().pos,newpos)>4) then
                                KitanoiNavigation.NavAPI.MoveTo(newpos.x,newpos.y,newpos.z)
                                kfcache.functions.SetAvoidanceTime(91918) KitanoiSettings.avoidingtime = KitanoiFuncs.Now()
                            end
                        end
                        if (kdfscp2started) then
                            KitanoiFuncs.DonutPoly2(100,-7,100,30,14.5,0, Player, 1564684684684, 60000)
                        end	
                    ]]
                },
                [2] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local count = NoobgamKdfProfiles.CountMaxLevel()
                            if count > 3 then
                                return
                            end
                            NoobgamKdfProfiles.FarmEcho(5, 100, 0, 100)
                        end
                    ]]
                },
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
            excludeavoid={30159},
            overheadmarkers={},
            tankbuster = {30135},
        },
        [1095] = {
            name = "Mount Ordeals",
            --mesh = "Storm's Crown",
            dutyid = 1095,
            level = 90,
            expansion = 6,
            creator = "Noobgam",
            notes = "This is dogshit quality, doesn't do anything",
            queuetype = 2,
            FFA = true,
            hacks = false,
            meleeavoid = false,
            requeuetimer = 10,
            objectivedestinations = {
                [1] = {objective = 1, pos = {x = 100, y = 0, z = 100}},
            },
            interacts = {},
            bossids = {
                12054, -- Rubicante
            },
            enemytargetdistance = 50,
            prioritytarget = {},
            avoidentity = {
            },
            meshchange={
            },
            -- 31943
            advancedavoid={
                [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            NoobgamKdfProfiles.Rubicante()
                        end
                    ]]
                },
                [3] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local count = NoobgamKdfProfiles.CountMaxLevel()
                            if count > 3 then
                                return
                            end
                            NoobgamKdfProfiles.FarmEcho(5, 116, 0, 116)
                        end
                    ]]
                },
            },
            tankat = {},
            dontexcludeaoe = {
            },
            excludeavoid={
                31978, -- inferno
                31956, -- cones from purgation, fully ignoring the mech
            },
            overheadmarkers={},
            tankbuster = {},
        },
        [1140] = {
            bossids = {},
            creator = "Kitanoi",
            dutyid = 1140,
            enemytargetdistance = 50,
            excludeavoid = {
                33947,
                33946,
                33945,
                33941,
                -- void star. It's not good to ignore it but it's not worse than what default avoidance does
                33957,
            },
            forcemeleerange = {12365},
            hasbuff = {},
            FFA = true,
            interactdistance = 20,
            interacts = {
            },
            name = "The Voidcast Dais",
            objectivedestinations =
            {
                [1] = {	objective = 1,pos = {x=100,y=0.03,z=90},},
            },
            reactions = {
                [1] = {
                    name = "Knockback Immunity",
                    cause = "return KitanoiFuncs.ScanForCaster2(33946,nil,4) and ((ActionList:Get(1,7548).usable and not ActionList:Get(1,7548).isoncd) or (ActionList:Get(1,7559).usable and not ActionList:Get(1,7559).isoncd))",
                    effect = "if (ActionList:Get(1,7548)) then ActionList:Get(1,7548):Cast(Player.id) end if (ActionList:Get(1,7559)) then ActionList:Get(1,7559):Cast(Player.id) end",
                },
                [2] = {
                    name = "Knockback Immunity",
                    cause = "return KitanoiFuncs.ScanForCaster2(33947,nil,4) and ((ActionList:Get(1,7548).usable and not ActionList:Get(1,7548).isoncd) or (ActionList:Get(1,7559).usable and not ActionList:Get(1,7559).isoncd))",
                    effect = "if (ActionList:Get(1,7548)) then ActionList:Get(1,7548):Cast(Player.id) end if (ActionList:Get(1,7559)) then ActionList:Get(1,7559):Cast(Player.id) end",
                },
            },	
            overheadmarkers = {
                [1] = {id = 344, 
                    contentid = "12365",
                    desc= "tank busters", 
                    type = "justrecord", 
                    detectwho = "any", 
                    pos =  {}, 
                    returnpos = {}, 
                    timetoreturn = 8,
                },	
                [2] = {id = 478, 
                    contentid = "12365",
                    desc= "knockaback", 
                    type = "move", 
                    detectwho = "me", 
                    pos =  {
                        [1] = {x=100,y=0,z=100},
                        [2] = {x=100,y=0,z=100},
                        [3] = {x=100,y=0,z=100},
                        [4] = {x=100,y=0,z=100},
                        [5] = {x=100,y=0,z=100},
                        [6] = {x=100,y=0,z=100},
                        [7] = {x=100,y=0,z=100},
                        [8] = {x=100,y=0,z=100},
                    }, 
                    returnpos = {}, 
                    timetoreturn = 8,
                },	
                [3] = {id = 476, 
                    contentid = "12365",
                    desc= "knockaback", 
                    type = "move", 
                    detectwho = "me", 
                    pos =  {
                        [1] = {x=100,y=0,z=100},
                        [2] = {x=100,y=0,z=100},
                        [3] = {x=100,y=0,z=100},
                        [4] = {x=100,y=0,z=100},
                        [5] = {x=100,y=0,z=100},
                        [6] = {x=100,y=0,z=100},
                        [7] = {x=100,y=0,z=100},
                        [8] = {x=100,y=0,z=100},
                    }, 
                    returnpos = {}, 
                    timetoreturn = 8,
                },
                [4] = {id = 318, 
                    contentid = "12365",
                    desc= "tank busters", 
                    type = "justrecord", 
                    detectwho = "any", 
                    pos =  {}, 
                    returnpos = {}, 
                    timetoreturn = 8,
                },			
            },
            prioritytarget = {},
            prioritytargetdistance = 10,
            puddledata= {
                --[1] = {castid = 34822, radius = 11, duration = 14, desc = "Puddles"},
            },	
            queuetype = 1,
            requeuetimer = 10,
            type = "duty",
            advancedavoid = {
                [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            NoobgamKdfProfiles.Golbez()       
                        end]],
                },
                [2] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local count = NoobgamKdfProfiles.CountMaxLevel()
                            if count > 3 then
                                return
                            end
                            NoobgamKdfProfiles.FarmEcho(5, 120, 0, 120)
                        end
                    ]]
                },
            },
        },
        [1168] = {
            bossids = {},
            creator = "Kitanoi",
            FFA = true,
            dutyid = 1168,
            mesh = "[Trial] The Abyssal Fracture",
            enemytargetdistance = 50,
            excludeavoid = {
                16547, --"[KF][31][1168] - Seraph(8227) cast: Consolation(16547)"
                35602,
                35603,
                35604,
                35605,
                35910, --turning left blue
                35573, --turning right red
                36134, --blackhalo
                35601, -- meteors
                35631, --nails cone
                35628, --nails cone
                35629, --nails cone
                -- voidstar
                33957,
                33959,
            },
            dontexcludeaoe = {

            },
            reactions = {
                [1] = {
                    name = "shake it off",
                    cause = "return Player.job == 21 and ActionList:Get(1,7388) and not ActionList:Get(1,7388).isoncd and HasBuff(Player.id,1769)",
                    effect = "ActionList:Get(1,7388):Cast(Player.id)",
                },
                [2] = {
                    name = "plennary",
                    cause = "return Player.job == 24 and ActionList:Get(1,7433) and not ActionList:Get(1,7433).isoncd and HasBuff(Player.id,1769)",
                    effect = "ActionList:Get(1,7433):Cast(Player.id)",
                },		
                [3] = {
                    name = "cure3",
                    cause = "return Player.job == 24 and ActionList:Get(1,131) and not ActionList:Get(1,131).isoncd and HasBuff(Player.id,1769) and HasBuff(Player.id,1219)",
                    effect = "ActionList:Get(1,131):Cast(Player.id)",
                },	
                -- [4] = {
                    -- name = "tether force stop",
                    -- cause = "return Player.job == 24 and ActionList:Get(1,131) and not ActionList:Get(1,131).isoncd and HasBuff(Player.id,1769) and HasBuff(Player.id,1219)",
                    -- effect = "ActionList:Get(1,131):Cast(Player.id)",
                -- },		
            },
            forcemeleerange = {
                --12586,
            },
            hasbuff = {},
            interactdistance = 20,
            interacts = {},
            name = "The Abyssal Fracture",
            objectivedestinations = 
            {
                [1] = {	objective = 1,pos = {x=100,y=0,z=100},},
            },
            overheadmarkers = {
                [1] = {id = 376, 
                    contentid = "12586",
                    desc = "spreadies",
                    precise = false,
                    type = "justrecord", 
                    detectwho = "any", 
                    timetoreturn = 6,	
                },		
                [2] = {id = 364, 
                    contentid = "12586",
                    desc = "tank stacks",
                    precise = false,
                    type = "justrecord", 
                    detectwho = "any", 
                    timetoreturn = 6,	
                },	
                [3] = {id = 197, 
                    contentid = "12586",
                    desc = "big damage lazer?",
                    precise = false,
                    type = "justrecord", 
                    detectwho = "any", 
                    timetoreturn = 6,	
                },	
                [4] = {id = 100, 
                    contentid = "12586",
                    desc = "stack",
                    precise = false,
                    type = "justrecord", 
                    detectwho = "any", 
                    timetoreturn = 6,	
                },			
            },
            prioritytarget = {},
            prioritytargetdistance = 10,
            pullenemyoutofpuddle = false,
            puddledata= {
                
            },	
            queuetype = 1,
            requeuetimer = 10,
            type = "duty",
            advancedavoid = {
                [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            NoobgamKdfProfiles.Zeromus()
                        end
                    ]],
                },
                [2] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                        function customfunction()
                            local count = NoobgamKdfProfiles.CountMaxLevel()
                            if count > 3 then
                                return
                            end
                            NoobgamKdfProfiles.FarmEcho(5, 125, 0, 100)
                        end
                    ]]
                },
            },
        }
    }

    function NoobgamKdfProfiles.UseMits(mits)
        mits = mits or {
            -- common
            7535,
            7531,

            -- war
            44,
            40,
            7388,

            -- pld
            25746,
            7382,
            3540,
            3542,
        }
        for _, v in pairs(mits) do
            if ActionList:Get(1, v):CanCastResult(Player.id) == 0 then
                ActionList:Get(1, v):Cast(Player.id)
            end
        end
    end

    function NoobgamKdfProfiles.Rubicante()
        if NoobgamKdfProfiles.TryingToWipe then
            return
        end
        if NoobgamKdfProfiles.StopMovingIfRaising() then
            return
        end
        local infernoId = 123718371
        if KitanoiFuncs.ScanForCaster2(31943) then
            if KitanoiSettings.AvoidThisArea[infernoId] == nil then
                KitanoiFuncs.CurrentAOEs[infernoId] = {
                    type = "circle",
                    entity = infernoId,
                    target = 0,
                    aoeID = infernoId,
                    name = "noname",
                    radius = 6,
                    length = 6,
                    width = 6,
                    pos = {x=100,y=0,z=100},
                    heading = 0,
                    casttime = 2,
                    channelingtime = 0,
                    deletetime = Now() + 20000,
                }
            end
        end
        if KitanoiFuncs.ScanForCaster2(32149) then
            -- Dualfire
            if NoobgamKdfProfiles.DoIHaveMarker(230) then
                if KitanoiFuncs.DetermineMainTank() == Player.id then
                    log("Dualfire MT")
                    KitanoiNavigation.NavAPI.MoveTo(105, 0, 105)
                else
                    log("Dualfire OT")
                    KitanoiNavigation.NavAPI.MoveTo(95, 0, 105)
                end
            else
                log("Dualfire party")
                KitanoiNavigation.NavAPI.MoveTo(100, 0, 95)
            end

            KitanoiSettings.avoidingtime = Now() + 2000
        end
        if KitanoiFuncs.ScanForCaster2(31974) then
            NoobgamKdfProfiles.ClockPositions(100, 0, 100, 6)
            KitanoiSettings.avoidingtime = Now() + 2000
        end
    end

    --- @param id integer
    --- @param targetId integer|nil
    local function useIfCan(id, targetId)
        local ac = ActionList:Get(1, id)
        if ac ~= nil and ac.usable and not ac.isoncd then
            ac:Cast(targetId)
        end
    end

    function NoobgamKdfProfiles.Golbez()
        if NoobgamKdfProfiles.TryingToWipe then
            return
        end

        if NoobgamKdfProfiles.StopMovingIfRaising() then
            return
        end

        if (KitanoiFuncs.ScanForCaster2(33957) or (NoobgamKdfProfiles.voidStar or 0) > GetTickCount()) then
            if NoobgamKdfProfiles.voidStar == nil or NoobgamKdfProfiles.voidStar < GetTickCount() - 40000 then
                NoobgamKdfProfiles.voidStar = GetTickCount() + 20000
                log("Void dust started")
            end

            -- we need to resolve it, but for now we don't care
            return
        end

        if (KitanoiFuncs.ScanForCaster2(33922) or (NoobgamKdfProfiles.eventide or 0) > GetTickCount()) then
            if NoobgamKdfProfiles.eventide == nil or NoobgamKdfProfiles.eventide < GetTickCount() - 40000 then
                NoobgamKdfProfiles.eventide = GetTickCount() + 20000
                log("Eventide started")
            end
            -- use all mits available
            -- WAR + PLD
            useIfCan(3626, Player.id)
            useIfCan(3540, Player.id)
            -- SGE
            useIfCan(24298, Player.id)
            useIfCan(24310, Player.id)
            useIfCan(24311, Player.id)
            --WHM
            useIfCan(7433, Player.id)
            useIfCan(16536, Player.id)

            if (Player.role == 1 and KitanoiFuncs.DetermineMainTank() == Player.id) then
                local peopleAlive = 0
                for _, v in pairs(EntityList.myparty) do
                    local ent = EntityList:Get(v.id)
                    if ent and ent.alive then
                        peopleAlive = peopleAlive + 1
                    end
                end
                -- invuln if got caught with 2 markers
                if HasBuff(Player, 2091) then
                    log("Need to invuln eventide")
                    useIfCan(30)
                    useIfCan(43)
                end
                KitanoiNavigation.NavAPI.MoveTo(105, 0, 100)
                KitanoiSettings.avoidingtime = Now()
            else
                KitanoiNavigation.NavAPI.MoveTo(95, 0, 100)
                KitanoiSettings.avoidingtime = Now()
            end
            return
        end
        if (KitanoiFuncs.IsMarkerUp(344)) then
            if (Player.role ~= 1) then
                KitanoiNavigation.NavAPI.MoveTo(100, 0, 105)
                KitanoiSettings.avoidingtime = Now()
            end
            if (Player.role == 1 and KitanoiFuncs.DetermineMainTank() == Player.id) then
                KitanoiFuncs.ForceTankCoolDowns()
                KitanoiNavigation.NavAPI.MoveTo(105, 0, 100)
                KitanoiSettings.avoidingtime = Now()
            end
            if (Player.role == 1 and KitanoiFuncs.DetermineMainTank() ~= Player.id) then
                KitanoiFuncs.ForceTankCoolDowns()
                KitanoiNavigation.NavAPI.MoveTo(95, 0, 100)
                KitanoiSettings.avoidingtime = Now()
            end
        end
        if (KitanoiFuncs.IsMarkerUp(318) and KitanoiFuncs.HowManyAOES(true) == 0) then
            KitanoiFuncs.ForceTankCoolDowns()
            KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
            KitanoiSettings.avoidingtime = Now()
        end
        local KBSoaks = KitanoiFuncs.ScanForCaster2(33946)
        local KBSoaks2 = KitanoiFuncs.ScanForCaster2(33947)
        if ((KBSoaks or KBSoaks2) and not NoobgamKdfProfiles.DoIHaveMarker(478)) then
            local pt = KitanoiFuncs.ReturnSortedParty()
            if (pt[1] == Player.id or pt[2] == Player.id or pt[3] == Player.id or pt[4] == Player.id) then
                KitanoiNavigation.NavAPI.MoveTo(88, 0, 100)
                KitanoiSettings.avoidingtime = Now()
            end
            if (pt[5] == Player.id or pt[6] == Player.id or pt[7] == Player.id or pt[8] == Player.id) then
                KitanoiNavigation.NavAPI.MoveTo(112, 0, 100)
                KitanoiSettings.avoidingtime = Now()
            end
        end
    end

    function NoobgamKdfProfiles.Zeromus()
        if NoobgamKdfProfiles.TryingToWipe then
            return
        end
        if NoobgamKdfProfiles.StopMovingIfRaising() then
            return
        end
        local zeromus = KitanoiFuncs.entityList("alive,attackable,targetable")
        local targ = Player:GetTarget()
        local midpoint = { x = 100, y = 0, z = 100 }
        local HMAOES = KitanoiFuncs.HowManyAOES(true)
        if (not targ and zeromus ~= nil) then
            local i, e = next(zeromus)
            if (i and e) then
                Player:SetTarget(i)
            end
        end
        if (KitanoiFuncs.ScanForCaster2(35603) or (NoobgamKdfProfiles.flare1End or 0) > GetTickCount()) then
            if NoobgamKdfProfiles.flare1End == nil or NoobgamKdfProfiles.flare1End < GetTickCount() - 40000 then
                NoobgamKdfProfiles.flare1End = GetTickCount() + 20000
                log("Flare1 started")
            end

            if NoobgamKdfProfiles.flare1End > GetTickCount() + 10500 then
                -- do nothing, 
            elseif NoobgamKdfProfiles.flare1End > GetTickCount() + 5000 then
                KitanoiNavigation.NavAPI.MoveTo(90, 0, 90)
                KitanoiSettings.avoidingtime = Now() + 6000
                KitanoiSettings.DisableKDFAvoidance = true
                return
            else
                KitanoiNavigation.NavAPI.MoveTo(110, 0, 90)
                KitanoiSettings.DisableKDFAvoidance = true
                KitanoiSettings.avoidingtime = Now() + 6000
                return
            end
        end
        KitanoiSettings.DisableKDFAvoidance = false
        local soaks = KitanoiFuncs.ScanForCaster2({ 35602, 35603, 35604, 35605 }, nil, nil, true)
        local lazer = KitanoiFuncs.ScanForCaster2(35566)
        local meteors = KitanoiFuncs.ScanForCaster2(35601)
        if (lazer or meteors) then
            NoobgamKdfProfiles.UseMits({
                7535,
                7388,
                3540,
            })
            KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
            KitanoiSettings.avoidingtime = Now() + 2000
        end
        local bubbles = KitanoiFuncs.entityList("contentid=12588")
        if (bubbles ~= nil) then
            for i, e in pairs(bubbles) do
                if (i and e and TensorCore.getEntitySpeed(i) > 0) then
                    local poly1 = KitanoiFuncs.SquarePolygon(e.pos, 4, 6, e.pos.h, 1)
                    KitanoiFuncs.CurrentAOEs[i] = {
                        type = "rectangle",
                        entity = i,
                        target = i,
                        pos = point1,
                        length = 4,
                        width = 4,
                        heading = -1.570796,
                        aoeID = 0000,
                        name = "",
                        poly = poly1,
                        casttime = 2,
                        channelingtime = 2,
                        deletetime = Now() + 750,
                    }
                    KitanoiSettings.AvoidThisArea[i] = {}
                    KitanoiSettings.AvoidThisArea[i].poly = poly1
                    KitanoiSettings.AvoidThisArea[i].timer = Now() + 750
                    local start, mid, endC, outlineColor, outlineThickness = TensorCore.getMoogleColors()
                    Argus2.addTimedRectFilled(750, e.pos.x, e.pos.y, e.pos.z, 6, 4, e.pos.h, start, endC, mid, 0, nil,
                        nil, outlineColor, outlineThickness)
                end
            end
        end
        if (soaks ~= nil and soaks ~= false and HMAOES == 0 and not KitanoiFuncs.IsMarkerUp(197)) then
            for ii, ee in pairs(soaks) do
                d("soaks")
                local ent = KitanoiFuncs.MGetEntity(ee.entityID)
                if (ent ~= nil and math.distance2d(midpoint.x, midpoint.z, ent.pos.x, ent.pos.z) < 15) then
                    KitanoiNavigation.NavAPI.MoveTo(ent.pos.x, 0, ent.pos.z)
                    KitanoiSettings.avoidingtime = Now() + 2000
                end
            end
        end
        local meteorimpact = KitanoiFuncs.ScanForCaster2(35595)

        if (meteorimpact) then
            local mypoint = NoobgamKdfProfiles.ClockPositions(100, 0, 100, 18)
            d("meteor impact: " .. json.encode(mypoint))
            KitanoiNavigation.NavAPI.MoveTo(mypoint.x, 0, mypoint.z)
            KitanoiSettings.avoidingtime = Now() + 2000
        end

        local ahkmorn = KitanoiFuncs.ScanForCaster2(35619)
        if (ahkmorn) then
            KitanoiSettings.avoidingtime = Now() + 10000
        end

        local turning1 = KitanoiFuncs.ScanForCaster2(35910)
        local turningEnd11 = KitanoiFuncs.ScanForCast2(35910, 6, 3)
        local turningEnd12 = KitanoiFuncs.ScanForCast2(35910, 8, 6)
        local turningEnd1 = KitanoiFuncs.ScanForCast2(35910, 11, 8)
        if (turning1) then
            d("turning1")
            KitanoiNavigation.NavAPI.MoveTo(90, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end
        if (turningEnd11) then
            d("turningEnd11")
            KitanoiNavigation.NavAPI.MoveTo(94, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end
        if (turningEnd12) then
            d("turningEnd12")
            KitanoiNavigation.NavAPI.MoveTo(98, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end
        if (turningEnd1) then
            d("turningEnd1")
            -- local sprint = ActionList:Get(1,3)
            -- if (sprint) then
            -- sprint:Cast(Player.id)
            -- end				
            KitanoiNavigation.NavAPI.MoveTo(118, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end

        local turning2 = KitanoiFuncs.ScanForCaster2(35573)
        local turningEnd21 = KitanoiFuncs.ScanForCast2(35573, 6, 3)
        local turningEnd22 = KitanoiFuncs.ScanForCast2(35573, 8, 6)
        local turningEnd2 = KitanoiFuncs.ScanForCast2(35573, 11, 8)
        if (turning2) then
            d("turning2")
            KitanoiNavigation.NavAPI.MoveTo(108, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end
        if (turningEnd21) then
            d("turningEnd21")
            KitanoiNavigation.NavAPI.MoveTo(104, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end
        if (turningEnd22) then
            d("turningEnd22")
            KitanoiNavigation.NavAPI.MoveTo(102, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end
        if (turningEnd2) then
            d("turningEnd2")
            -- local sprint = ActionList:Get(1,3)
            -- if (sprint) then
            -- sprint:Cast(Player.id)
            -- end
            KitanoiNavigation.NavAPI.MoveTo(82, 0, 82)
            KitanoiSettings.avoidingtime = Now() + 20000
        end

        if (KitanoiFuncs.IsMarkerUp(376) and not KitanoiFuncs.IsMarkerUp(100)) then
            d("spreadies")
            local points = {
                { x = 100.000000, y = 0.000000, z = 107.000000 },
                { x = 106.464466, y = 0.000000, z = 106.464466 },
                { x = 107.000000, y = 0.000000, z = 100.000000 },
                { x = 106.464466, y = 0.000000, z = 93.535534 },
                { x = 100.000000, y = 0.000000, z = 93.000000 },
                { x = 93.535534,  y = 0.000000, z = 93.535534 },
                { x = 93.000000,  y = 0.000000, z = 100.000000 },
                { x = 93.535534,  y = 0.000000, z = 106.464466 }
            }
            local pt = KitanoiFuncs.ReturnSortedParty()
            for i = 1, 8, 1 do
                if (pt[i] == Player.id) then
                    local mypoint = points[i]
                    if (mypoint) then
                        KitanoiNavigation.NavAPI.MoveTo(mypoint.x, 0, mypoint.z)
                        KitanoiSettings.avoidingtime = Now() + 2000
                    end
                end
            end
        end
        if (KitanoiFuncs.IsMarkerUp(376) and Player.role == 4 and not Player:IsMoving()) then
            KitanoiFuncs.HealDoomMulti()
        end
        if (KitanoiFuncs.IsMarkerUp(376) and Player.role == 1) then
            -- local action = ActionList:Get(5,3)
            -- if ( action ) then
            -- action:Cast()
            -- end
        end
        if (KitanoiFuncs.IsMarkerUp(197) and not NoobgamKdfProfiles.DoIHaveMarker(197) and HMAOES == 0) then
            KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
            KitanoiSettings.avoidingtime = Now() + 2000
        end
        if (NoobgamKdfProfiles.DoIHaveMarker(197)) then
            local points = {
                [1] = { x = 118.26, y = 0, z = 116.36 },
                [2] = { x = 115.13, y = 0, z = 117.87 },
                [3] = { x = 101.21, y = 0, z = 118.07 },
                [4] = { x = 98.07, y = 0, z = 118.06 },
                [5] = { x = 84.57, y = 0, z = 118.12 },
                [6] = { x = 81.87, y = 0, z = 115.79 },

            }
            local action = ActionList:Get(5, 3)
            if (action) then
                action:Cast()
            end
            for _, e in pairs(points) do
                if (not KitanoiFuncs.CheckPointInAOETable(e.x, e.y, e.z)) then
                    KitanoiNavigation.NavAPI.MoveTo(e.x, e.y, e.z)
                    KitanoiSettings.avoidingtime = Now() + 2000
                    break
                end
            end
        end
        if (KitanoiFuncs.IsMarkerUp(100) and HMAOES == 0) then
            KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
            KitanoiSettings.avoidingtime = Now() + 2000
        end
        if (KitanoiFuncs.IsMarkerUp(364)) then
            if (NoobgamKdfProfiles.DoIHaveMarker(364)) then
                KitanoiFuncs.ForceTankCoolDowns()
                KitanoiNavigation.NavAPI.MoveTo(90, 0, 90)
                KitanoiSettings.avoidingtime = Now() + 2000
            else
                KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
                KitanoiSettings.avoidingtime = Now() + 2000
            end
        end
        if (HMAOES == 0 and TimeSince(KitanoiSettings.avoidingtime) > 2000) then
            KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
            KitanoiSettings.avoidingtime = Now() + 2000
        end
    end

    function NoobgamKdfProfiles.StopMovingIfRaising()
        if Player.castinginfo.channelingid == 24287
            and (Player.castinginfo.casttime - Player.castinginfo.channeltime < 3)
        then
            KitanoiSettings.DisableKDFAvoidance = true
        else
            KitanoiSettings.DisableKDFAvoidance = false
        end
    end

    function NoobgamKdfProfiles.CountMaxLevel()
        local count = 0
        for _, v in pairs(EntityList.myparty) do
            if v.level >= 100 then count = count + 1 end
        end
        return count
    end

    function NoobgamKdfProfiles.ClockPositions(x, y, z, radius)
        local cnt = NoobgamUtils.tableSize(EntityList.myparty)
        local angle = 2 * 3.14159265 / cnt
        for i = 1, cnt do
            if KitanoiFuncs.ReturnSortedParty()[i] == Player.id then
                KitanoiNavigation.NavAPI.MoveTo(
                    x + radius * math.sin(angle * i),
                    y,
                    z + radius * math.cos(angle * i)
                )
                return {
                    x = x + radius * math.sin(angle * i),
                    y = y,
                    z = z + radius * math.cos(angle * i)
                }
            end
        end
        return {}
    end

    --- @param markerType integer
    function NoobgamKdfProfiles.DoIHaveMarker(markerType)
        for k, v in pairs(KitanoiSettings.knownmarkers) do 
            if v.markertype == markerType and v.target == Player.id then
                return true
            end
        end
        return false
    end

    ---@param echoStacks integer number of echo stacks to get
    ---@param x number x to walk off the cliff
    ---@param y number yto walk off the cliff
    ---@param z number z to walk off the cliff
    ---@param timeOverride integer|nil
    function NoobgamKdfProfiles.FarmEcho(echoStacks, x, y, z, timeOverride)
        local timeToEcho = timeOverride or (3 * 60 * 1000)
        if not Player.alive then
            ---@diagnostic disable-next-line: undefined-global
            KitanoiNavigation.NavAPI.Stop()
            Player:SetAutoFollowOn(false)
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
                    local percent = tonumber(v.line:match("restoration have been increased by (%d+)%%"))
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
        if echoStacksWeHave < echoStacks and TimeSince(KitanoiSettings.InCombatTimer) > timeToEcho then
            Player:SetAutoFollowPos(x, y, z)
            Player:SetAutoFollowOn(true)
            NoobgamKdfProfiles.TryingToWipe = true
            KitanoiSettings.avoidingtime = Now() + 2000
            KitanoiSettings.DisableKDFAvoidance = true
            Player:SetTarget(Player.id)
        else
            KitanoiSettings.DisableKDFAvoidance = false
            NoobgamKdfProfiles.TryingToWipe = false
        end
    end
end

return NoobgamKdfProfiles