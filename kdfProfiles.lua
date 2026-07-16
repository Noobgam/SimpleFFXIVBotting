local function log(message)
    d("[NoobgamKdfProfiles] " .. message)
end

--- @class MechanicState
--- @field Expiry number
--- @field Start number
--- @field InnerState table
--- @field Expired? boolean

NoobgamKdfProfiles = {
    --- @type table<string, MechanicState>
    State = {},
    Mechanics = {
        --- @param name string
        --- @param duration integer
        Trigger = function(name, duration)
            local expiry = GetTickCount() + duration
            NoobgamKdfProfiles.State[name] = {
                InnerState = {},
                Expiry = expiry,
                Start = GetTickCount()
            }
            log("Mechanic Triggered: " .. name .. " (expires in " .. (duration/1000) .. "s)")
        end,

        IsActive = function(name)
            local mechState = NoobgamKdfProfiles.State[name]
            return mechState ~= nil and mechState.Expiry ~= nil and mechState.Expiry > GetTickCount()
        end,

        Stop = function(name)
            NoobgamKdfProfiles.State[name] = nil
        end,

        UpdateState = function()
            if TimeSince(KitanoiSettings.InCombatTimer) < 3000 then
                if next(NoobgamKdfProfiles.State) ~= nil then
                    NoobgamKdfProfiles.State = {}
                    log("Wipe/New Pull detected: Mechanic State Reset.")
                end
            end
            for k, v in pairs(NoobgamKdfProfiles.State) do
                if v.Expiry < GetTickCount() and not v.Expired then
                    v.Expired = true
                    log("Mechanic " .. tostring(k) .. " expired: " .. NoobgamUtils.tableToString(v))
                end
            end
        end
    }
}

NoobgamKdfProfiles.DungeonProfiles = {
    [432] = {
        name = "Thok ast Thok (Hard)",
        mesh = "Thok ast Thok",
        dutyid = 432,
        level = 53,
        expansion = 3,
        creator = "Koyote",
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
            3660, -- Ravana -- Ravana Card & (Ravana's Forewing (Synced Only))
        },
        forcemeleerange= {3660},
        enemytargetdistance = 50,
        prioritytarget = {},
        tankat= {
            [1] = {contentid = 3660, frompercent = 100, topercent = 1, pos = {x = 0.77, y = 0, z = -0}, desc = "Tank at this pos from 100-1%"},
        },
        advancedavoid = {},
        hasbuff = {},
        overheadmarkers = {},
        excludeavoid = {},
    },
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        mesh = "[Trial] The Seat of Sacrifice",
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
                    if (NoobgamKdfProfiles.IsMarkerUp(62) and not NoobgamKdfProfiles.DoIHaveMarker(352) and not NoobgamKdfProfiles.DoIHaveMarker(100)) then
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
        enemytargetdistance = 70,
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
    },
    [1202] = {
        meleeavoid = false,
        bossids = {},
        creator = "Noobgam",
        FFA = true,
        level = 100,
        dutyid = 1202,
        mesh = "Interphos",
        enemytargetdistance = 120,
        excludeavoid = {
            36607,
            36608,
            36609,
            39531,
            -- weak raidwide
            36603,
        },
        dontexcludeaoe = {

        },
        reactions = {
        },
        forcemeleerange = {
            --12586,
        },
        hasbuff = {},
        interactdistance = 20,
        interacts = {},
        name = "The interphos",
        objectivedestinations = 
        {
            [1] = {	objective = 1,pos = {x=100,y=0,z=100},},
        },
        overheadmarkers = {
        },
        prioritytarget = {},
        prioritytargetdistance = 50,
        pullenemyoutofpuddle = false,
        puddledata= {
            
        },	
        queuetype = 1,
        requeuetimer = 10,
        type = "duty",
        advancedavoid = {
            -- we want to update interphos on every tick, not on every kdf tick.
            [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                    function customfunction()
                        NoobgamKdfProfiles.Interphos()
                    end
                ]],
            },
        },
    },
    [1270] = {
        meleeavoid = true,
        bossids = {
            13861
        },
        creator = "Noobgam",
        FFA = true,
        level = 100,
        dutyid = 1270,
        mesh = "Recollection",
        enemytargetdistance = 120,
        excludeavoid = {
            43129,
            43085,
            43084,
            43093,
            43479,
            43095,

            43083, -- thunder slash
        },
        dontexcludeaoe = {  
        },
        reactions = {
        },
        forcemeleerange = {
            --12586,
        },
        hasbuff = {},
        interactdistance = 20,
        interacts = {},
        name = "Recollection",
        objectivedestinations =
        {
            [1] = {	objective = 1,pos = {x=100,y=0,z=100},},
        },
        overrideaoedetails = {
            fan = {[43126] = "fan120"}
        },
        overheadmarkers = {
        },
        prioritytarget = {},
        prioritytargetdistance = 50,
        pullenemyoutofpuddle = false,
        puddledata= {

        },
        tankbuster = {43129},
        queuetype = 1,
        requeuetimer = 10,
        type = "duty",
        advancedavoid = {
            -- we want to update recollection on every tick, not on every kdf tick.
            [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                    function customfunction()
                        NoobgamKdfProfiles.Recollection()
                    end
                ]],
            },
        },
    },
    [1245] = {
        name = "Halatali",
        mesh = "[Dungeon] Halatali v2",
        dutyid = 1245,
        level = 20,
        expansion = 2,
        creator = "Latty79",
        notes = "",
        queuetype = 2,
        FFA = false,
        hacks = false,
        objectivedestinations = {
            [1] = {objective = 1, pos = {x = 26.17, y = 0.93, z = 126.78}}, -- Clear the Hall of the Cesti
            [2] = {objective = 2, pos = {x = -183.55, y = -15.31, z = -130.79}}, -- Activate the chain winches
            [3] = {objective = 3, pos = {x = -183.55, y = -15.31, z = -130.79}}, -- Clear the Hall of the Secutores
            [4] = {objective = 4, pos = {x = -271.13, y = 17.23, z = 19.96}}, -- Defeat Tangata
        },
        interactdistance = 45,
        interacts = {
            --[1] = {contentid = 86, req = {}, priority = 1, type = "Loot 1"}, -- Too out of the way
            [2] = {contentid = 89, req = {objective = 1, complete = true}, priority = 2, type = "Boss 1 Loot"},
            [3] = {contentid = 2001619, req = {objective = 1, complete = true}, priority = 3, type = "Aetherial Flow"},
            [4] = {contentid = 2001624, req = {objective = 2, complete = false}, priority = 4, type = "Chain Winch 1"},
            [5] = {contentid = 113, req = {objective = 2, complete = false}, priority = 5, type = "Chain Winch Loot 1"},
            [6] = {contentid = 2001625, req = {objective = 1, complete = true}, priority = 6, type = "Chain Winch 2"},
            [7] = {contentid = 114, req = {objective = 2, complete = false}, priority = 7, type = "Chain Winch Loot 2"},
            [8] = {contentid = 2001626, req = {objective = 2, complete = false}, priority = 8, type = "Chain Winch 3"},
            [9] = {contentid = 115, req = {objective = 2, complete = false}, priority = 9, type = "Chain Winch Loot 3"},
            --[10] = {contentid = 87, req = {objective = 2, complete = false}, priority = 10, type = "Loot 2"}, -- Too out of the way
            [11] = {contentid = 2001627, req = {objective = 2, complete = false}, priority = 11, type = "Chain Winch 4"},
            [12] = {contentid = 116, req = {objective = 2, complete = false}, priority = 12, type = "Chain Winch Loot 4"},
            [13] = {contentid = 2001628, req = {objective = 2, complete = false}, priority = 13, type = "Chain Winch 5"},
            [14] = {contentid = 117, req = {objective = 2, complete = false}, priority = 14, type = "Chain Winch Loot 5"},
            [15] = {contentid = 90, req = {objective = 4, complete = false}, priority = 15, type = "Boss 2 Loot 1"},
            [16] = {contentid = 91, req = {objective = 4, complete = false}, priority = 16, type = "Boss 2 Loot 2"},
            [17] = {contentid = 2001647, req = {objective = 4, complete = false}, priority = 17, type = "Aetherial Flow"},
            --[18] = {contentid = 88, req = {objective = 4, complete = false}, priority = 18, type = "Loot 3"}, -- Too out of the way
            [19] = {contentid = 2001623, req = {objective = 4, complete = false}, priority = 19, type = "Ludus Door"},
            [20] = {contentid = 92, priority = 20, type = "Boss 3 Loot"}, -- The Ludus Orchestrion Roll
        },
        bossids = {
            1194, -- Firemane
            1196, -- Thunderclap Guivre
            1197, -- Tangata
        },
        forcemeleerange = {1197},
        enemytargetdistance = 50,
        prioritytargetdistance = 50,
        prioritytarget = {
            [1] = {contentid = 1187, priority = 1, type = "Damantus"},
            [2] = {contentid = 1195, priority = 2, type = "Noxious"},
            [3] = {contentid = 1197, priority = 3, type = "Tangata"},
        },
        avoidentity = {},
        advancedavoid = {
            [1] = {type = "custom", customdetails = "function", functionname = "Boss 2 & 3 Mechanics", functioncode = [[
                    local targ = Player:GetTarget()
                    if
                        (Player.incombat and KitanoiSettings.SavedMapEffects["112"] ~= nil and
                            TimeSince(KitanoiSettings.SavedMapEffects["112"].timeadded) < 10000)
                    then
                        local point = {x = -183.28, y = -14.27, z = -111.05}
                        KitanoiNavigation.NavAPI.MoveTo(point.x, point.y, point.z)
                        KitanoiSettings.avoidingtime = Now() + 2000
                    end
                    local firstcircle = KitanoiFuncs.ScanForCaster2(40599)
                    if (firstcircle) then
                        KitanoiFuncs.TempBlackListAOE[40600] = {
                            aoeID = 40600,
                            removeat = KitanoiFuncs.Now() + 1000,
                            forceremove = 1000
                        }
                        KitanoiSettings.ExcludeAOES[40600] = true
                        KitanoiFuncs.TempBlackListAOE[40601] = {
                            aoeID = 40601,
                            removeat = KitanoiFuncs.Now() + 1000,
                            forceremove = 1000
                        }
                        KitanoiSettings.ExcludeAOES[40601] = true
                        KitanoiFuncs.API.RemoveAOEbyAOEID(40600)
                        KitanoiFuncs.API.RemoveAOEbyAOEID(40601)
                    else
                        KitanoiFuncs.TempBlackListAOE[40600] = nil
                        KitanoiSettings.ExcludeAOES[40600] = nil
                        KitanoiFuncs.TempBlackListAOE[40601] = nil
                        KitanoiSettings.ExcludeAOES[40601] = nil
                    end
                ]],
            },
            [2] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                    function customfunction()
                        KitanoiFuncs.LoadMesh("[Dungeon] Halatali v2")
                    end
                ]]
            },
        },
        reactions = {},
        overheadmarkers = {},
        overrideaoedetails = {
            innerrad = {
                [40600] = 10,
                [40601] = 20,
            },
        },
        autoblacklist = true,
    },
    [1267] = {
        name = "The Sunken Temple of Qarn",
        mesh = "[Dungeon] The Sunken Temple of Qarn v2",
        dutyid = 1267,
        level = 35,
        expansion = 2,
        creator = "Exmachinas",
        notes = "",
        queuetype = 2,
        FFA = false,
        hacks = false,
        objectivedestinations = {
            [1] = {objective = 1, pos = {x = -70.00, y = -11.95, z = -62.00 }},
            [2] = {objective = 2, pos = {x = 53.52, y = -49.46, z = 1.22}},
            [3] = {objective = 3, pos = {x = 53.52, y = -49.46, z = 1.22}},
            [4] = {objective = 4, pos = {x = 243.00, y = -4.00, z = 0.00}},
            [5] = {objective = 5, pos = {x = 243.00, y = -4.00, z = 0.00}},
        },
        interactdistance = 65,
        interacts = { -- WIP to get every chest
            [1] = {contentid = 2000418, req = {complete = false, objective = 1}, priority = 1, type = "The Helm of Might"},
            [2] = {contentid = 135, priority = 2, type = "Loot 1"},
            [3] = {contentid = 2000417, req = {complete = false, objective = 1}, priority = 3, type = "The Gem of Affluence"},
            [4] = {contentid = 136, priority = 4, type = "Boss 1 Loot"},
            [5] = {contentid = 2000415, req = {complete = true, objective = 2}, priority = 5, type = "The Flame of Magic"},
            [6] = {contentid = 2000416, req = {complete = true, objective = 2}, priority = 6, type = "The Fruit of Knowledge"},
            [7] = {contentid = 137, priority = 7, type = "Boss 2 Loot"},
            --[8] = {contentid = 2000423, req = {complete = true, objective = 3}, priority = 8, type = "Stone Pedestal - Gem of Affluence"}, -- 1
            --[9] = {contentid = 129, priority = 9, type = "Statuette Loot 1"}, -- Shards -- Belah'dian Glass -- Out of Mesh WIP
            --[10] = {contentid = 2000425, req = {complete = true, objective = 3}, priority = 10, type = "Stone Pedestal - Helm of Might"}, -- 0
            --[11] = {contentid = 128, priority = 11, type = "Statuette Loot 2"}, -- Shards -- Belah'dian Glass -- Out of Mesh WIP
            --[12] = {contentid = 2000421, req = {complete = true, objective = 3}, priority = 12, type = "Stone Pedestal - Fruit of Knowledge"}, -- 3
            --[13] = {contentid = 131, priority = 13, type = "Statuette Loot 3"}, -- Shards -- Belah'dian Glass -- Out of Mesh WIP
            --[14] = {contentid = 2000419, req = {complete = true, objective = 3}, priority = 14, type = "Stone Pedestal - Flame of Magic"}, -- 2
            --[15] = {contentid = 130, priority = 15, type = "Statuette Loot 4"}, -- Shards -- Belah'dian Glass -- Out of Mesh WIP
            [16] = {contentid = 2000427, req = {complete = true, objective = 3}, priority = 16, type = "Left Pan - Flame of Magic"}, -- 2
            [17] = {contentid = 2000428, req = {complete = true, objective = 3}, priority = 17, type = "Right Pan - Fruit of Knowledge"}, -- 2
            [18] = {contentid = 2000658, req = {complete = true, objective = 3}, priority = 18, type = "The Scales of Judgment"},
            --[19] = {contentid = 133, req = {complete = true, objective = 4}, priority = 19, type = "Loot 2"}, -- Out of Mesh WIP
            --[20] = {contentid = 132, req = {complete = true, objective = 4}, priority = 20, type = "Loot 3"}, -- Shards -- Belah'dian Glass -- Out of Mesh WIP
            --[21] = {contentid = 134, req = {complete = true, objective = 4}, priority = 21, type = "Loot 4"}, -- Out of Mesh WIP
            [22] = {contentid = 138, priority = 22, type = "Boss 3 Loot"}, -- Belah'dian Glass & Echoes of Ages Past Orchestrion Roll
        },
        bossids = {
            1567, -- Teratotaur
            1569, -- Temple Guardian
            1570, -- Adjudicator
        },
        forcemeleerange = {},
        enemytargetdistance = 30,
        prioritytargetdistance = 30,
        prioritytarget = {
            [1] = {contentid = 1490, priority = 1, type = "Golem Soulstone"},
            [2] = {contentid = 1798, priority = 1, type = "Mythril Verge"},
        },
        ignoretarget = {},
        dontclearfriendlytargets = {2000423,2000425,2000421,2000419,2000427,2000428},
        advancedavoid =	{
            [1] = {type = "custom", customdetails = "function", functionname = "Boss 1 Doom Dispell", functioncode = [[
                    local hasdoom = HasBuff(Player.id, 5187)
                    local AOECount = KitanoiFuncs.HowManyAOES(true)
                    if (hasdoom and AOECount == 0) then
                        local ents = KitanoiFuncs.MEntityList("contentid=2000866;2000867;2000868")
                        if (ents) then
                            for i, e in pairs(ents) do
                                if (i and e and e.eventid == 0 and math.distance2d(Player.pos, e.pos) > 0.8) then
                                    local point = e.pos
                                    if (not Player:IsMoving()) then
                                        local npoint = KitanoiFuncs.randompointInCircle(e.pos.x, e.pos.z, 0.7)
                                        point.x = npoint.x
                                        point.z = npoint.z
                                    end
                                    KitanoiNavigation.NavAPI.MoveTo(point.x, point.y, point.z)
                                    KitanoiSettings.avoidingtime = Now() + 2000
                                end
                            end
                        end
                    end
                ]]
            },
            [2] = {type = "custom", customdetails = "function", functionname = "Place Statuettes", functioncode = [[
                    function customfunction()
                        if IsControlOpen("SelectString") then
                            UseControlAction("SelectString","SelectIndex",2)
                        end
                    end
                ]]
            },
            [3] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                    function customfunction()
                        KitanoiFuncs.LoadMesh("[Dungeon] The Sunken Temple of Qarn v2")
                    end
                ]]
            },
        },
        hasbuff = {},
        overheadmarkers = {},
        excludeavoid = {},
        pullenemyoutofpuddle = false,
        enemylos = true,
    },
    [1330] = {
        name = "Dzemael Darkhold",
        mesh = "[Dungeon] Dzemael Darkhold v2",
        dutyid = 1330,
        level = 44,
        expansion = 2,
        creator = "Exmachinas",
        notes = "",
        queuetype = 2,
        FFA = false,
        hacks = false,
        objectivedestinations = {
            [1] = {objective = 1, pos = {x = 43.21, y = -14.40, z = 73.19}},
            [2] = {objective = 2, pos = {x = -95.29, y = -30.50, z = -33.90}},
            [3] = {objective = 3, pos = {x = 16.34, y = -17.89, z = -162.82}},
            [4] = {objective = 4, pos = {x = 83.48, y = -38.95, z = -169.56}},
        },
        interactdistance = 30,
        interacts = {
            --[1] = {contentid = 170, priority = 1, type = "Loot 1"}, -- Too out of the way
            [2] = {contentid = 174, priority = 2, type = "Boss 1 Loot"},
            [3] = {contentid = 2000458, priority = 3, type = "Magitek Transporter"},
            [4] = {contentid = 172, priority = 4, type = "Loot 2"},
            [5] = {contentid = 173, priority = 5, type = "Loot 3"},
            [6] = {contentid = 175, priority = 6, type = "Boss 2 Loot 1"},
            [7] = {contentid = 176, priority = 7, type = "Boss 2 Loot 2"},
            [8] = {contentid = 2000474, priority = 8, type = "Magitek Transporter"},
            [9] = {contentid = 177, priority = 9, type = "Boss 3 Loot"}, -- The Darkhold Orchestrion Roll
        },
        bossids = {
            1397, -- All-seeing Eye
            1415, -- Taulurd
            1396, -- Batraal -- Ahriman Card
        },
        forcemeleerange = {},
        enemytargetdistance = 40,
        prioritytargetdistance = 50,
        prioritytarget = {
            [1] = {contentid = 2154, priority = 1, type = "Corrupted Crystal"},
            [2] = {contentid = 1396, priority = 2, type = "Batraal"},
        },
        ignoretarget = {},
        tankat = {},
        advancedavoid = {
            [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                    function customfunction()
                        KitanoiFuncs.LoadMesh("[Dungeon] Dzemael Darkhold v2")
                    end
                ]]
            },
        },
        hasbuff = {},
        overheadmarkers = {},
        excludeavoid = {},
        dontexcludeaoe = {1167},
        staybehindentity = {1396},
        puddledata = {},
        pullenemyoutofpuddle = false,
    },
    [1331] = {
        name = "The Aurum Vale",
        mesh = "[Dungeon] Aurum Vale v2",
        dutyid = 1331,
        level = 47,
        expansion = 2,
        creator = "Kitanoi",
        notes = "",
        queuetype = 2,
        FFA = false,
        hacks = false,
        objectivedestinations = {
            [1] = {objective = 1, pos = {x = 27, y = -9.2399997711182, z = 2.6199998855591}},
            [2] = {objective = 2, pos = {x = -156.7200012207, y = -30.430000305176, z = -133.64999389648}},
            [3] = {objective = 3, pos = {x = -156.7200012207, y = -30.430000305176, z = -133.64999389648}},
            [4] = {objective = 4, pos = {x = -340.17001342773, y = -32.119998931885, z = -133.86999511719}},
            [5] = {objective = 5, pos = {x = -406.29000854492, y = -33.119998931885, z = -115.83000183105}},
        },
        interacts = {
            [1] = {contentid = 149, priority = 1, type = "Boss 1 Loot"},
            [2] = {contentid = 153, priority = 2, type = "Loot 1"}, -- Morbol Seedling
            [3] = {contentid = 154, priority = 3, type = "Loot 2"}, -- Mossy Horn
            [4] = {contentid = 151, priority = 4, type = "Boss 2 Loot"},
            [5] = {contentid = 155, priority = 6, type = "Loot 3"}, -- Dodore Wing & Carnivorous Seedling
            [6] = {contentid = 156, priority = 6, type = "Loot 4"},
            [7] = {contentid = 148, priority = 8, type = "Boss 3 Loot"}, -- Miser's Folly Orchestrion Roll
        },
        bossids = {
            1534, -- Locksmith
            1533, -- Coincounter
            1532, -- Miser's Mistress -- Morbol Card
        },
        enemytargetdistance = 30,
        prioritytargetdistance = 5,
        prioritytarget = {
            [1] = {contentid = 1536, priority = 1, type = "Morbol Fruit"},
            [2] = {contentid = 1535, priority = 2, type = "Morbol Seedling"},
        },
        tankat = {},
        faceenemyaway = {},
        useaction = {},
        advancedavoid = {
            [1] = {type = "custom", customdetails = "function", functionname = "customfunction", functioncode = [[
                    function customfunction()
                        KitanoiFuncs.LoadMesh("[Dungeon] Aurum Vale v2")
                    end
                ]]
            },
        },
        hasbuff = {
            [1] = {
                buffid = 302,
                desc = "first boss",
                interactid = "2002648;2002647;2000778;2002649",
                stacksrequired = 2,
                type = "interact",
            },
            [2] = {
                buffid = 303,
                desc = "last boss",
                interactid = "2002663;2002662;2002661;2002660;2002659;2002658;2002657;2002656;2002655;2002654",
                stacksrequired = 3,
                type = "interact",
            },
        },
        overheadmarkers = {},
        staybehindentity = {1534,1533,1532},
    }
}

-- private profiles.
NoobgamKdfProfiles.DungeonProfiles[160] = {
    name = "Pharos Sirius",
    mesh = "Pharos Sirius",
    dutyid = 160,
    level = 50,
    expansion = 2,
    creator = "Kitanoi",
    notes = "",
    queuetype = 2,
    FFA = true,
    hacks = false,
    objectivedestinations = {
        [1] = {objective = 1, pos = {x = 42, y = 30, z = -56}},
        [2] = {objective = 2, pos = {x = 42, y = 30, z = -56}},
        [3] = {objective = 3, pos = {x = -15, y = 90, z = 0}},
        [4] = {objective = 4, pos = {x = 0, y = 140, z = 0}},
        [5] = {objective = 5, pos = {x = -15, y = 194, z = 0}},
    },
    interactdistance = 65,
    interacts = {
        [1] = {contentid = 230, priority = 1, type = "Loot 1"},
        [2] = {contentid = 234, priority = 2, type = "Boss 1 Loot"},
        [3] = {contentid = 231, priority = 3, type = "Loot 2"},
        [4] = {contentid = 232, priority = 4, type = "Loot 3"},
        --[5] = {contentid = 233, priority = 5, type = "Loot 4"}, -- Too out of the way
        [6] = {contentid = 235, priority = 6, type = "Boss 2 Loot"},
        [7] = {contentid = 2002730, priority = 7, type = "Aether Valve"},
        [8] = {contentid = 2002731, priority = 8, type = "Aether Valve"},
        [9] = {contentid = 236, priority = 9, type = "Boss 3 Loot"},
        [10] = {contentid = 237, priority = 10, type = "Boss 4 Loot"}, -- N/A
    },
    bossids = {
        2259, -- Symond the Unsinkable
        2261, -- Zu
        2264, -- Tyrant
        2265, -- Siren -- Siren Card & Faded Copy of A Light in the Storm
    },
    forcemeleerange = {2259,2261},
    enemytargetdistance = 30,
    prioritytargetdistance = 50,
    prioritytarget = {
        [1] = {contentid = 2260, priority = 1, type = "First Boss Dogs"},
        [2] = {contentid = 2259, priority = 2, type = "First Boss"},
        [3] = {contentid = 2262, priority = 1, type = "Second Boss tether"},
        [4] = {contentid = 2263, priority = 2, type = "Second Boss Adds"},
        [5] = {contentid = 2261, priority = 3, type = "Second Boss"},
        [6] = {contentid = 2256, priority = 1, type = "Third Boss Adds"},
        [7] = {contentid = 2266, priority = 1, type = "Fourth Boss Adds"},
    },
    ignoretarget = {2267},
    tankat = {
        [1] = {contentid = 2259, frompercent = 100, topercent = 0, pos = {x = 41.93, y = 30.00, z = -59.67}, desc = "tank the 1st Boss here"},
        [2] = {contentid = 2261, frompercent = 100, topercent = 0, pos = {x = 5.97, y = 90.14, z = 0.12}, desc = "tank the 1st Boss here"},
    },
    useaction = {},
    advancedavoid = {},
    hasbuff = {},
    overheadmarkers = {},
    excludeavoid = {
        1669 -- Corrupted crystal fall
    },
    staybehindentity = {2261,2265},
    puddledata = {
        [1] = {castid = 1542, desc = "first boss puddle", duration = 20, radius = 15},
    },
}

NoobgamKdfProfiles.DungeonProfiles[437] = {
    name = "The Singularity Reactor",
    mesh = "Singularity Reactor",
    dutyid = 437,
    level = 60,
    expansion = 3,
    creator = "Rinn",
    notes = "",
    queuetype = 2,
    FFA = true,
    hacks = false,
    requeuetimer = 10,
    objectivedestinations = {
        [1] = {objective = 1, pos = {x = 0.00, y = 0.00, z = 0.4}},
    },
    interactdistance = 50,
    interacts = {},
    bossids = {
        3632, -- King Thordan
    },
    enemytargetdistance = 50,
    prioritytarget = {
        [1] = {contentid = 3641, priority = 1, type = "Meteor"},
    },
    avoidentity = {},
    advancedavoid = {},
    excludeavoid = {4219,4221,4220,4218},
}

NoobgamKdfProfiles.DungeonProfiles[1045] = {
    name = "The Bowl of Embers",
    mesh = "[Trial] The Bowl of Embers",
    dutyid = 1045,
    level = 20,
    expansion = 2,
    creator = "Koyote#6642",
    notes = "",
    queuetype = 1,
    FFA = true,
    hacks = false,
    requeuetimer = 10,
    objectivedestinations = {
        [1] = {objective = 1, pos = {x = 15, y = 7.105427357601e-15, z = 0}},
    },
    interactdistance = 20,
    interacts = {},
    bossids = {
        1185, -- Ifrit
    },
    forcemeleerange = {},
    enemytargetdistance = 50,
    prioritytargetdistance = 10,
    prioritytarget = {
        [1] = {contentid = 1186, priority = 1, type = "Nails"},
    },
    advancedavoid = {},
    hasbuff = {},
    overheadmarkers = {},
    excludeavoid = {},
    pullenemyoutofpuddle = false,
}

-- Labyrinth of the Ancients (24-man alliance raid).
-- temporarily commented out. Haven't tested it yet fully
NoobgamKdfProfiles.DungeonProfiles[174] = {
    name = "The Labyrinth of the Ancients",
    mesh = "The Labyrinth of the Ancients",
    dutyid = 174,
    level = 50,
    expansion = 2,
    creator = "Noobgam",
    notes = "24-man. Navigation only, no teleport hacks.\nEach alliance (A/B/C) contests its own atomos spot (1/2/3).",
    queuetype = 2,
    FFA = true,
    hacks = false,
    requeuetimer = 10,
    objectivedestinations = {
    },
    interacts = {},
    bossids = {},
    enemytargetdistance = 70,
    prioritytarget = {},
    tankat = {},
    advancedavoid = {
        [1] = {type = "custom", customdetails = "libraryfunction", functioncode = "NoobgamKdfProfiles.LabyrinthOfTheAncients()"},
    },
    hasbuff = {},
    overheadmarkers = {},
    excludeavoid = {},
}

-- Waypoints / constants for The Labyrinth of the Ancients (mirrors the MsqHelper lota flow).
local LOTA = {
    IRON_GIANT_CONTENT_ID = 730,
    ATOMOS_CONTENT_ID = 1872,
    ATOMOS_POS = {
        { x = 253.6, y = 51, z = 244 },
        { x = 253.6, y = 51, z = 280 },
        { x = 253.6, y = 51, z = 316 },
    },
    -- Alliance A/B/C each parks on atomos spot 1/2/3 respectively.
    ALLIANCE_ATOMOS_SPOT = {
        A = { x = 214, y = 51, z = 244 },
        B = { x = 214, y = 51, z = 280 },
        C = { x = 214, y = 51, z = 316 },
    },
    WAYPOINTS = {
        P5       = { x = -451,   y = 25.6,  z = 20 },
        P6       = { x = 166.44, y = 58.5,  z = 279.3 },
        BEHEMOTH = { x = -108,   y = 68,    z = -347 },
        P7       = { x = 211,    y = 51,    z = 244 },
        THANATOS = { x = 440.4,  y = 66.27, z = 280 },
        DUDE     = { x = -109,   y = 650,   z = 200 },
    },
    FLARE_SPOTS = {
        A = { x = -148.83262634277, y = 650.30261230469, z = 192.06996154785, h = 0.87862992286682 },
        B = { x = -109.96013641357, y = 650.30450439453, z = 221.50909423828, h = -3.0462687015533 },
        C = { x = -71.285591125488, y = 650.30834960938, z = 191.57553100586, h = 2.9060029983521 },
    }
}

-- One big step-detecting function. Detects the current phase from completed
-- duty objectives and walks (never teleports) to the matching waypoint. KDF's
-- ACR handles the actual fighting once we are in range.
function NoobgamKdfProfiles.LabyrinthOfTheAncients()
    if not table.valid(Duty:GetActiveDutyInfo()) then
        return
    end

    -- If the exit is up we are done, let the framework leave.
    local exit = NoobgamUtils.PickClosestExit()
    if exit ~= nil and exit.targetable then
        return
    end

    --- Walk to a position. Returns true once we are within radius.
    local function moveTo(pos, radius)
        radius = radius or 2
        if pos == nil then
            return true
        end
        if NoobgamUtils.calculateDist(Player.pos, pos) > radius then
            KitanoiNavigation.NavAPI.MoveTo(pos.x, pos.y, pos.z)
            KitanoiSettings.avoidingtime = Now()
            local sprint = ActionList:Get(1, 3)
            if sprint and sprint:IsReady() then
                sprint:Cast()
            end
            return false
        end
        return true
    end

    -- Ancient Flare (aoeID 1730) is the final boss's raidwide spread marker.
    -- Whenever we see it being cast, immediately run to our alliance's flare
    -- spot. This takes priority over everything else (even combat).
    local flareUp = false
    for _, v in pairs(Argus.getCurrentAOEs()) do
        if v.aoeID == 1730 then
            flareUp = true
            break
        end
    end
    if flareUp then
        local alliance = NoobgamUtils.GetMyAlliance() or "A"
        local spot = LOTA.FLARE_SPOTS[alliance]
        if spot ~= nil then
            moveTo(spot)
            return
        end
    end

    local completed = NoobgamUtils.CompletedObjectivesCount()
    if completed == 0 and not table.valid(Duty:GetActiveDutyObjectives()) then
        -- then we need to exit kinda, but exit is not visible. Nav to the guy
        moveTo({
            x = -110,
            y = 650,
            z = 165
        })
        return
    end
    
    if completed ~= 3 then
        -- If we are in combat, don't run off to the next waypoint. Join the fight
        -- the rest of the alliance is dealing with. Move toward the enemy that a
        -- friendly is targeting and let the ACR handle the actual rotation.
        local enemy = NoobgamUtils.PickFriendlyTargetEnemy(Player.pos)
            or NoobgamUtils.PickClosestEntity("alive,attackable,targetable", Player.pos)
        if enemy ~= nil then
            if Player.targetid ~= enemy.id then
                Player:SetTarget(enemy.id)
            end
            -- Normally we just set the target and let the ACR fight. Only bother
            -- moving if we're way too far and nothing is selected to fight.
            if (Player.targetid == nil or Player.targetid == 0)
                and NoobgamUtils.calculateDist(Player.pos, enemy.pos) > 30 then
                moveTo(enemy.pos, 5)
            end
            return
        end
    end

    local W = LOTA.WAYPOINTS

    -- Phase mapping mirrors the skips table in the MsqHelper lota config:
    --   objectives >= 3 -> atomos contest, >= 4 -> Thanatos, >= 5 -> Behemoth, >= 7 -> final drop.
    if completed < 3 then
        moveTo(W.P5)
    elseif completed == 3 then
        -- Atomos contest phase. Each alliance parks on its own spot.
        local alliance = NoobgamUtils.GetMyAlliance() or "A"
        local spot = LOTA.ALLIANCE_ATOMOS_SPOT[alliance]
        moveTo(spot)
        -- we don't target anything during atomos things. We just stay afk on platform
        KitanoiFuncs.targettime = Now()
    elseif completed == 4 then
        moveTo(W.THANATOS)
    elseif completed <= 6 then
        moveTo(W.BEHEMOTH)
    elseif completed == 7 then
        moveTo(W.THANATOS)
    end
end

function NoobgamKdfProfiles.UseMits(mits)
    mits = mits or {
        -- common
        7535,
        7531,
        76,
        7405,
        24317,

        -- war
        44,
        40,
        7388,

        -- pld
        25746,
        7382,
        3540,
        3542,

        -- sge
        24298,
        24310,
        24311,
        24305,
        24137,
    }
    for _, v in pairs(mits) do
        if ActionList:Get(1, v):CanCastResult(Player.id) == 0 then
            log("Using mit: " .. v)
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
        if KitanoiSettings.CurrentAOEs[infernoId] == nil then
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

    if (NoobgamKdfProfiles.IsMarkerUp(344)) then
        if not NoobgamKdfProfiles.DoIHaveMarker(344) then
            KitanoiNavigation.NavAPI.MoveTo(100, 0, 105)
            KitanoiSettings.avoidingtime = Now()
            return
        end
        local id = 1
        local tankSpots = {
            { x = 105, y = 0, z = 100 },
            { x = 95,  y = 0, z = 100 },
        }
        for _, entId in pairs(KitanoiFuncs.ReturnSortedParty()) do
            if entId == Player.id then
                KitanoiFuncs.ForceTankCoolDowns()
                KitanoiNavigation.NavAPI.MoveTo(tankSpots[id].x, tankSpots[id].y, tankSpots[id].z)
                KitanoiSettings.avoidingtime = Now()
            end
            if NoobgamKdfProfiles.DoIHaveMarker(344, entId) then
                id = id + 1
            end
        end
        return
    end
    if (KitanoiFuncs.ScanForCaster2(33922) or (NoobgamKdfProfiles.eventide or 0) > GetTickCount()) then
        if NoobgamKdfProfiles.eventide == nil or NoobgamKdfProfiles.eventide < GetTickCount() - 40000 then
            NoobgamKdfProfiles.eventide = GetTickCount() + 10000
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

        if (Player.role == 1) then
            if HasBuff(Player, 2091) then
                log("Need to invuln eventide")
                useIfCan(30)
                useIfCan(43)
            end
        end
        local mypoint = NoobgamKdfProfiles.ClockPositions(100, 0, 100, 11)
        d("eventide spreads: " .. json.encode(mypoint))
        KitanoiNavigation.NavAPI.MoveTo(mypoint.x, 0, mypoint.z)
        KitanoiSettings.avoidingtime = Now()
        return
    end
    local burningShade = KitanoiFuncs.ScanForCaster2(33939)

    if (burningShade) then
        local mypoint = NoobgamKdfProfiles.ClockPositions(100, 0, 100, 11)
        d("burningShade spreads: " .. json.encode(mypoint))
        KitanoiNavigation.NavAPI.MoveTo(mypoint.x, 0, mypoint.z)
        KitanoiSettings.avoidingtime = Now()
        return
    end
    if (NoobgamKdfProfiles.IsMarkerUp(318) and KitanoiFuncs.HowManyAOES(true) == 0) then
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

function NoobgamKdfProfiles.Interphos()
    local Mech = NoobgamKdfProfiles.Mechanics

    -- Target logic
    local queen = KitanoiFuncs.entityList("alive,attackable,targetable")
    if (not Player:GetTarget() and queen ~= nil) then
        local i, e = next(queen)
        if (i and e) then Player:SetTarget(i) end
    end
    if TimeSince(KitanoiSettings.InCombatTimer) < 100 then
        return
    end
    NoobgamKdfProfiles.FarmEcho(5, 100, 0, 75)
    Mech.UpdateState()


    if NoobgamKdfProfiles.TryingToWipe or NoobgamKdfProfiles.StopMovingIfRaising() then
        return
    end


    local fz = 92
    local somethingOngoing = false
    KitanoiSettings.DisableKDFAvoidance = false

    local function handleMechanic(name)
        local mechState = NoobgamKdfProfiles.State[name]
        if mechState == nil then
            return
        end
        somethingOngoing = true
        local start, expiry, innerState = mechState.Start, mechState.Expiry, mechState.InnerState
        if not expiry or not start then return end
        local progress = GetTickCount() - start

        local function dqcon()
            local SHORT_SEGMENT_MS = 3000
            local firstWave = 8500
            local cycle = (progress - firstWave) % (SHORT_SEGMENT_MS * 2)
            local radius = 7
            if progress < firstWave then
            elseif cycle < SHORT_SEGMENT_MS then
                radius = 19
            else
                
                if (ActionList:Get(1, 3):IsReady()) then
                    ActionList:Get(1, 3):Cast(Player.id)
                end
            end

            local centerX, centerZ, y = 100, 86, 0
            local angleStep = -math.pi / 7
            local baseAngle = math.pi
            local idx = NoobgamKdfProfiles.GetSortedIndex()
            if idx then
                local angle = baseAngle + angleStep * (idx - 1)
                KitanoiNavigation.NavAPI.MoveTo(centerX + radius * math.cos(angle), y, centerZ + radius * math.sin(angle))
                KitanoiSettings.avoidingtime = GetTickCount() + 100
            end
        end

        if name == "DivideAndConquer" then
            dqcon()
        elseif name == "Aethertithe" then
            local mid = KitanoiSettings.SavedMapEffects["02562048"]
            if mid and TimeSince(mid.timeadded) < 8000 then
                KitanoiNavigation.NavAPI.MoveTo(106, 0, 86)
            else
                KitanoiNavigation.NavAPI.MoveTo(100, 0, 86)
            end
            NoobgamKdfProfiles.UseMits({
                7535,
                7388,
                3540,
                24298,
                24310,
            })
            KitanoiSettings.avoidingtime = Now()
            KitanoiSettings.DisableKDFAvoidance = true
        elseif name == "FurryPhase" then
            if KitanoiFuncs.HowManyAOES(false) == 0 then
                -- 88 is end of the arena
                KitanoiNavigation.NavAPI.MoveTo(95, 0, 100)
            end
        elseif name == "AbsoluteAuthority" then
            if NoobgamKdfProfiles.IsMarkerUp(327) then
                if innerState.markerUp == nil then
                    innerState.markerUp = GetTickCount()
                    log("Marker detected, will resolve for 5.5s")
                end
                if innerState.markerUp > GetTickCount() - 5500 then
                    if (ActionList:Get(1, 3):IsReady()) then
                        ActionList:Get(1, 3):Cast(Player.id)
                    end
                    NoobgamKdfProfiles.UseMits()
                    local id = 1
                    local pt = { x = 100, z = 100 }
                    local pts = {
                        { x = 90, z =   90},
                        { x = 110, z =  90},
                        { x = 110, z = 110},
                        { x = 90, z =  110},
                    }
                    log("Marker stuff")
                    for _, v in pairs(KitanoiFuncs.ReturnSortedParty()) do
                        if NoobgamKdfProfiles.DoIHaveMarker(327, v) or NoobgamKdfProfiles.DoIHaveMarker2(327, v) then
                            if Player.id == v then
                                pt = pts[id]
                            end
                            id = id + 1
                        end
                    end
                    KitanoiNavigation.NavAPI.MoveTo(pt.x, 0, pt.z)
                    KitanoiSettings.avoidingtime = Now() + 100
                elseif innerState.markerUp > GetTickCount() - 14000 then
                    Player:SetTarget(Player.id)
                end
            end
        elseif name == "Coronation" then
            dqcon()
        elseif name == "CoronationTethers" then
            local cx, cz = 100, 92
            -- stray dude stays behind
            local sx, sz = cx + 5, cz + 5
            local ex, ez = cx - 11, cz - 11

            if not Mech.IsActive("VirtualShiftDiagonal") then
                sx = 100
                ex = 100
            end
            local id = 0

            if progress < 9000 then
                for _, v in pairs(KitanoiFuncs.ReturnSortedParty()) do
                    if NoobgamKdfProfiles.DoIHaveMarker(1, v) and id == 0 then
                        if Player.id == v then
                            KitanoiNavigation.NavAPI.MoveTo(sx, 0, sz)
                        end
                        id = id + 1
                    else
                        if Player.id == v then
                            KitanoiNavigation.NavAPI.MoveTo(ex, 0, ez)
                        end
                    end
                end
            else
                if (ActionList:Get(1, 3):IsReady()) then
                    ActionList:Get(1, 3):Cast(Player.id)
                end
                if progress > 13800 then
                    if Mech.IsActive("Aethertithe") then
                        log("Stopping tether processing, time to solve aether")
                        Mech.Stop("CoronationTethers")
                    else
                        KitanoiNavigation.NavAPI.MoveTo(cx, 0, cz)
                    end
                end
            end

            NoobgamKdfProfiles.UseMits({
                7535,
                7388,
                3540,
                24298,
                24310,
            })
        elseif name == "LegitimateForce" then
            local cid = innerState.channelId
            local floating = Mech.IsActive("VirtualShiftFloating")
            local lx, rx = 98, 102
            if floating then
                lx, rx = 95, 105
            end
            -- 38 L L
            -- 39 L R
            -- 40 R R
            -- 41 R L 
            if progress < 1500 then
                -- always have enough time to dodge + there are some quirks with the wall mech
            elseif progress < 7700 then
                if cid == 36638 or cid == 36639 then
                    KitanoiNavigation.NavAPI.MoveTo(rx, 0, fz)
                else
                    KitanoiNavigation.NavAPI.MoveTo(lx, 0, fz)
                end
            else
                if cid == 36638 or cid == 36641 then
                    KitanoiNavigation.NavAPI.MoveTo(rx, 0, fz)
                else
                    KitanoiNavigation.NavAPI.MoveTo(lx, 0, fz)
                end
            end
            KitanoiSettings.avoidingtime = Now() + 600
        elseif name == "DownBurst" then
            if innerState.spot == nil then
                --- @type (DirectionalAOE|GroundAOE|nil)
                local kb = nil
                for k, v in pairs(Argus.getCurrentAOEs()) do
                    if v.aoeID == 36610 then
                        kb = v
                        break
                    end
                end
                if kb ~= nil then
                    local dx = 100 - kb.x
                    local dz = fz - kb.z
                    if math.abs(dx) < 2 then
                        innerState.spot = {
                            x = 98,
                            z = 90
                        }
                    else
                        local len = math.sqrt(dx * dx + dz * dz)
                        innerState.spot = {
                            x = kb.x + dx / len,
                            z = kb.z + dz / len
                        }
                    end
                end
            end
            if innerState.spot == nil then
                KitanoiNavigation.NavAPI.MoveTo(100, 0, fz)
            else
                KitanoiNavigation.NavAPI.MoveTo(mechState.InnerState.spot.x, 0, mechState.InnerState.spot.z)
            end
        elseif name == "Castellation" then
            -- platform borders
            -- local lx1, rx1 = 88, 96
            -- local lx2, rx2 = 104, 112

            local walls = {
                KitanoiSettings.SavedMapEffects["31632"],
                KitanoiSettings.SavedMapEffects["364128"],
                KitanoiSettings.SavedMapEffects["3256512"],
                KitanoiSettings.SavedMapEffects["310242048"],
            }

            local latestWall = nil
            for _, wall in pairs(walls) do
                if wall ~= nil then
                    if latestWall == nil or wall.timeadded > latestWall.timeadded then
                        latestWall = wall
                    end
                end
            end

            local floating = HasBuff(Player, 3814)

            -- 3 4 4096 wall go brrr

            -- 3 16 32
            -- 1L: 1
            -- 1U: 4        
            -- 2L: 4
            -- 2U: 2
            -- upper: 000100000100
            -- lower: 100001000001

            -- 3 64 128
            -- 1L: 4
            -- 1U: 1
            -- 2L: 2
            -- 2U: 4

            -- 3 256 512

            -- 1L: -
            -- 1U: 1
            -- 2L: 3
            -- 2U: -

            -- 3 1024 2048
            -- 1U: 2
            -- 1L: 4
            -- 2L: -
            -- 2U: 4
            if latestWall and TimeSince(latestWall.timeadded) < 7500 then
                if not floating then
                    if latestWall.a2 == 16 and latestWall.a3 == 32 then
                        KitanoiNavigation.NavAPI.MoveTo(89, 0, fz)
                    else
                        KitanoiNavigation.NavAPI.MoveTo(95, 0, fz)
                    end
                else
                    if latestWall.a2 == 16 and latestWall.a3 == 32 then
                        -- 1U: 4, 2U: 2
                        KitanoiNavigation.NavAPI.MoveTo(95, 0, fz)
                    elseif latestWall.a2 == 64 and latestWall.a3 == 128 then
                        -- 1U: 1, 2U: 4
                        KitanoiNavigation.NavAPI.MoveTo(89, 0, fz)
                    elseif latestWall.a2 == 256 and latestWall.a3 == 512 then
                        -- 1U: 1
                        KitanoiNavigation.NavAPI.MoveTo(89, 0, fz)
                    elseif latestWall.a2 == 1024 and latestWall.a3 == 2048 then
                        -- 1U: 2
                        KitanoiNavigation.NavAPI.MoveTo(91, 0, fz)
                    end
                end

            else
                KitanoiNavigation.NavAPI.MoveTo(89, 0, fz)
            end

        end
    end

    if KitanoiFuncs.ScanForCaster2(36612) or KitanoiFuncs.ScanForCaster2(36611) then
        if (ActionList:Get(1, 7548):IsReady()) then
            ActionList:Get(1, 7548):Cast(Player.id)
        end
        if (ActionList:Get(1, 7559):IsReady()) then
            ActionList:Get(1, 7559):Cast(Player.id)
        end
    end

    local lfc = NoobgamKdfProfiles.ScanForCasts(36638, 36639, 36640, 36641)
    if lfc ~= nil and not Mech.IsActive("LegitimateForce") then
        if Mech.IsActive("VirtualShiftFloating") then
            -- we have to extend the mech if we're flotaing
            Mech.Trigger("LegitimateForce", 18000)
        else
            Mech.Trigger("LegitimateForce", 12000)
        end
        NoobgamKdfProfiles.State["LegitimateForce"].InnerState.channelId = lfc
    end

    if (KitanoiFuncs.ScanForCaster2(36609) or KitanoiFuncs.ScanForCaster2(36610)) and not Mech.IsActive("DownBurst") then
        Mech.Trigger("DownBurst", 7600)
    end

    if KitanoiFuncs.ScanForCaster2(36636) and not Mech.IsActive("DivideAndConquer") then
        Mech.Trigger("DivideAndConquer", 20000)
    end

    if KitanoiFuncs.ScanForCaster2(36604) and not Mech.IsActive("Aethertithe") then
        Mech.Trigger("Aethertithe", 35000)
        if Mech.IsActive("Coronation") then
            Mech.Stop("Coronation")
            Mech.Trigger("CoronationAetherite", 20000)
        end
    end

    if KitanoiFuncs.ScanForCaster2(36613) and not Mech.IsActive("Castellation") then
        Mech.Trigger("Castellation", 40000)
    end

    if KitanoiFuncs.ScanForCaster2(39531) and not Mech.IsActive("AbsoluteAuthority") then
        Mech.Trigger("AbsoluteAuthority", 80000)
    end

    if IsControlOpen("TalkSubtitle") and not Mech.IsActive("FurryPhase") then
        Mech.Trigger("FurryPhase", 240000)
    end
    KitanoiSettings.ExcludeLOSs[13029] = true

    if KitanoiFuncs.ScanForCaster2(36629)
        and not Mech.IsActive("Coronation")
        and not Mech.IsActive("CoronationTethers")
        and not Mech.IsActive("AbsoluteAuthority")
    then
        local vshiftFloating = NoobgamKdfProfiles.State["VirtualShiftFloating"]
        if vshiftFloating ~= nil and vshiftFloating.Expiry > GetTickCount() - 30000 then
            log("Ignoring corontion trigger, it's not a real cast")
        else
            Mech.Trigger("Coronation", 32000)
        end
    end

    if KitanoiFuncs.ScanForCaster2(36606) and not Mech.IsActive("VirtualShiftDiagonal") then
        Mech.Trigger("VirtualShiftDiagonal", 70000)
        local c = GUI:ColorConvertFloat4ToU32(1, 1, 0.5, 1)
        Argus2.ShapeDrawer:new(c, nil, c):addTimedCone(70000, 100, 0, 90, 6.5, 3.14/2, 3.14)
        Argus2.ShapeDrawer:new(c, nil, c):addTimedCone(70000, 100, 0, 94, 6.5, 3.14/2, 0)
    end

    if KitanoiFuncs.ScanForCaster2(36607) and not Mech.IsActive("VirtualShiftFloating") then
        Mech.Trigger("VirtualShiftFloating", 77000)
    end

    if NoobgamKdfProfiles.IsMarkerUp(1) and Mech.IsActive("Coronation") then
        log("Tethers detected, updating Coronation state")
        Mech.Trigger("CoronationTethers", 17000)
        Mech.Stop("Coronation")
    end

    if Mech.IsActive("AbsoluteAuthority") then
        handleMechanic("AbsoluteAuthority")
    end

    if Mech.IsActive("FurryPhase") then
        handleMechanic("FurryPhase")
    end

    if Mech.IsActive("CoronationAetherite")
        or Mech.IsActive("LegitimateForce")
        -- soak this one. We suck becaause of no mesh
        or Mech.IsActive("VirtualShiftDiagonal")
    then
        KitanoiSettings.DFIndexedExcludeAvoid[36633] = true
    else
        KitanoiSettings.DFIndexedExcludeAvoid[36633] = nil
    end

    if Mech.IsActive("DivideAndConquer") then
        if Mech.IsActive("Coronation") then
            NoobgamKdfProfiles.UseMits()
            NoobgamKdfProfiles.UseMits({
                24288,
                24288,
                24299,
                24300,

            })
            -- to make sure we can cast mits
            Player:SetTarget(Player.id)
        end
    end

    if Mech.IsActive("Aethertithe") then
        if not Mech.IsActive("Coronation") and not Mech.IsActive("CoronationTethers") then
            handleMechanic("Aethertithe")
        end
    end
    if Mech.IsActive("LegitimateForce") then
        if not Mech.IsActive("Coronation") then
            handleMechanic("LegitimateForce")
        end
    end
    if Mech.IsActive("DownBurst") then handleMechanic("DownBurst") end
    if Mech.IsActive("Coronation") then
        if not Mech.IsActive("VirtualShiftDiagonal") and not Mech.IsActive("DivideAndConquer") then
            handleMechanic("Coronation")
        end
    end
    if Mech.IsActive("CoronationTethers") then
        handleMechanic("CoronationTethers")
    end
    if Mech.IsActive("Castellation") then
        handleMechanic("Castellation")
    end

    if Mech.IsActive("VirtualShiftFloating") then
        handleMechanic("VirtualShiftFloating")
    end

    -- mesh transitions are marked as ongoing mech.
    if not somethingOngoing and KitanoiFuncs.HowManyAOES(true) == 0 then
        KitanoiNavigation.NavAPI.MoveTo(100, 0, 92)
    end
end

function NoobgamKdfProfiles.Recollection()
    local Mech = NoobgamKdfProfiles.Mechanics

    -- Target logic
    local queen = KitanoiFuncs.entityList("alive,attackable,targetable")
    if (not Player:GetTarget() and queen ~= nil) then
        local i, e = next(queen)
        if (i and e) then Player:SetTarget(i) end
    end
    if TimeSince(KitanoiSettings.InCombatTimer) < 100 then
        return
    end
    NoobgamKdfProfiles.FarmEcho(5, 100, 0, 75)
    Mech.UpdateState()

    if NoobgamKdfProfiles.TryingToWipe or NoobgamKdfProfiles.StopMovingIfRaising() then
        return
    end

    -- map effects:
    -- 2 8 16 [visual shit outside]
    -- 3 1 2 [visual full circle top]
    -- 3 4 8 [circle go down]
    -- 10 1 2 [arena turn to shit]
    -- 1 1 2  [center arena go ]
    -- there are no mapeffects on spawning triangle

    local somethingOngoing = false
    local CANONICAL = {
        -math.pi,                  -- -3.14159
        -2 * math.pi / 3,          -- -2.0944
        -math.pi / 3,              -- -1.0472
        0,
        math.pi / 3,              --  1.0472
        2 * math.pi / 3,          --  2.0944
    }

    local function handleMechanic(name)
        local mechState = NoobgamKdfProfiles.State[name]
        if mechState == nil then
            return
        end
        somethingOngoing = true
        local start, expiry, innerState = mechState.Start, mechState.Expiry, mechState.InnerState
        if not expiry or not start then return end
        local progress = GetTickCount() - start

        if name == "Shock" then
            local mypoint = NoobgamKdfProfiles.ClockPositions(100, 0, 100, 7, true)
            if progress > 7500 then
                mypoint = NoobgamKdfProfiles.ClockPositions(100, 0, 100, 13, true)
            end

            KitanoiNavigation.NavAPI.MoveTo(mypoint.x, 0, mypoint.z)
            KitanoiSettings.avoidingtime = Now()
            NoobgamKdfProfiles.UseMits()
            return
        elseif name == "InOut" then
            local boomIn, boomOut = nil, nil
            for _, e in pairs(Argus.getCurrentAOEs()) do
                if e.aoeID == 43084 then boomIn = e
                elseif e.aoeID == 43085 then boomOut = e end
            end
            if boomIn == nil and boomOut == nil then
                Mech.Stop("InOut")
                return
            end
            if Mech.IsActive("ThunderSlash") then
                return
            end

            if boomOut == nil or (boomIn ~= nil and boomOut.startTime > boomIn.startTime) then
                KitanoiNavigation.NavAPI.MoveTo(100, 0, 109)
            else
                KitanoiNavigation.NavAPI.MoveTo(100, 0, 106)
            end
            KitanoiSettings.avoidingtime = Now()
            return
        elseif name == "Tankbuster" then
            local pt = KitanoiFuncs.ReturnSortedParty()
            local cnt = 0
            if not NoobgamKdfProfiles.IsMarkerUp(471) then
                return Mech.Stop("Tankbuster")
            end
            for i = 1, 8 do
                if NoobgamKdfProfiles.DoIHaveMarker(471, pt[i]) then
                    cnt = cnt + 1
                    if (pt[i] == Player.id) then
                        if cnt == 1 then
                            KitanoiNavigation.NavAPI.MoveTo(100, 0, 105)
                        else
                            KitanoiNavigation.NavAPI.MoveTo(95, 0, 105)
                        end
                    end
                else
                    if (pt[i] == Player.id) then
                        KitanoiNavigation.NavAPI.MoveTo(100, 0, 95)
                    end
                end
            end
            KitanoiSettings.avoidingtime = Now()
            return
        elseif name == "ThunderSlash" then
            -- gather currently-active cones
            local EPS = 0.05
            NoobgamKdfProfiles.UseMits()

            local function matchCanonical(h)
                for _, c in ipairs(CANONICAL) do
                    if math.abs(((h - c + math.pi) % (2 * math.pi)) - math.pi) < EPS then
                        return c
                    end
                end
                return nil
            end

            -- gather currently-active cones
            local active = {}
            local activeSet = {}  -- canonical heading -> aoe entry
            for _, e in pairs(Argus.getCurrentAOEs()) do
                if e.aoeID == 43083 or e.aoeID == 43078 then
                    local c = matchCanonical(e.heading)
                    if c ~= nil then
                        active[#active + 1] = { heading = c, startTime = e.startTime }
                        activeSet[c] = { heading = c, startTime = e.startTime }
                    end
                end
            end

            -- snapshot once we have at least 5 cones; infer the 6th
            if innerState.headings == nil then
                if #active < 5 then
                    -- not enough yet; safe to hold center (none have fired)
                    KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
                    KitanoiSettings.avoidingtime = Now() + 2000
                    return
                end

                innerState.headings = {}
                local missing = nil
                for _, c in ipairs(CANONICAL) do
                    if activeSet[c] ~= nil then
                        innerState.headings[#innerState.headings + 1] = activeSet[c]
                    else
                        missing = c
                    end
                end

                if missing ~= nil then
                    -- the missing cone is the latest-firing one
                    -- give it a startTime > all known ones so it's chosen for bait
                    local maxStart = 0
                    for _, c in ipairs(innerState.headings) do
                        if c.startTime > maxStart then maxStart = c.startTime end
                    end
                    table.insert(innerState.headings, { heading = missing, startTime = maxStart + 1 })
                    log("ThunderSlash inferred missing cone heading=" .. tostring(missing))
                end

                for _, c in ipairs(innerState.headings) do
                    log("ThunderSlash snapshot heading=" .. tostring(c.heading) .. " startTime=" .. tostring(c.startTime))
                end
            end

            -- radius from overlapping in/out
            local radius = 6
            if Mech.IsActive("InOut") then
                local boomIn, boomOut = nil, nil
                for _, e in pairs(Argus.getCurrentAOEs()) do
                    if e.aoeID == 43084 then boomIn = e
                    elseif e.aoeID == 43085 then boomOut = e end
                end
                if boomIn ~= nil then
                    radius = 9
                else
                    radius = 6
                end
            end

            -- a snapshot heading has fired iff it's no longer in the live AOE table
            local function stillActive(h)
                for _, a in ipairs(active) do
                    if math.abs(((a.heading - h + math.pi) % (2 * math.pi)) - math.pi) < EPS then
                        return true
                    end
                end
                return false
            end

            -- find the latest-firing cone (we baited it during snapshot)
            local latest = innerState.headings[1]
            for _, c in ipairs(innerState.headings) do
                if c.startTime > latest.startTime then latest = c end
            end

            -- collect all fired (safe) headings — those no longer in active table
            local firedHeadings = {}
            for _, c in ipairs(innerState.headings) do
                if not stillActive(c.heading) then
                    firedHeadings[#firedHeadings + 1] = c.heading
                end
            end

            local target = latest.heading
            if #firedHeadings > 0 then
                local best = nil
                local bestDiff = math.huge
                for _, h in ipairs(firedHeadings) do
                    local diff = math.abs((h - latest.heading + math.pi) % (2 * math.pi) - math.pi)
                    if diff < bestDiff - EPS then
                        bestDiff = diff
                        best = h
                    end
                end
                if best ~= nil then
                    target = best
                end
            end

            local dx = 100 + radius * math.sin(target)
            local dz = 100 + radius * math.cos(target)
            KitanoiNavigation.NavAPI.MoveTo(dx, 0, dz)
            KitanoiSettings.avoidingtime = Now()
            return
        end
        --  D = "[Evasion] Detected aoe: {[\"aoeAnimationInfo\"] = {[\"aoeAnimationTypeEnd\"] = 14572, [\"aoeCastVFX\"] = 0, [\"aoeAnimationTimelineHit\"] = 5996, [\"aoeAnimationTypeStart\"] = 8}, [\"aoeName\"] = \"Specter of the Lost\", [\"aoeCastType\"] = 13, [\"coneWidth\"] = 135, [\"aoeEffectInfo\"] = {[\"aoeEffectCastType\"] = 0, [\"aoeEffectLargeScale\"] = 1, [\"aoeEffectName\"] = \"\", [\"aoeEffectRestrictYScale\"] = false}, [\"heading\"] = -0.46747449605563, [\"startTime\"] = 108638130.179, [\"entityID\"] = 1073752818, [\"aoeLength\"] = 50, [\"aoeType\"] = 0, [\"friendly\"] = false, [\"aoeID\"] = 43129, [\"y\"] = 0, [\"x\"] = 100, [\"duration\"] = 5.3999996185303, [\"z\"] = 100, [\"goOffTimestamp\"] = 108643530.17862, [\"isAreaTarget\"] = false, [\"targetAttach\"] = 269241221, [\"aoeWidth\"] = 0}"

    end

    if NoobgamKdfProfiles.IsMarkerUp(590) then
        log("Stack marker")
        KitanoiNavigation.NavAPI.MoveTo(100, 0, 105)
        KitanoiSettings.avoidingtime = Now()
        return
    end

    if KitanoiFuncs.ScanForCaster2({ 43095 }) then
        KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
        KitanoiSettings.avoidingtime = Now()
        return
    end

    if NoobgamKdfProfiles.IsMarkerUp(581) and not Mech.IsActive("Shock") then
        log("Thunder marker")
        Mech.Trigger("Shock", 14500)
    end

    if KitanoiFuncs.ScanForCaster2({ 43078 }) and not Mech.IsActive("ThunderSlash") then
        Mech.Trigger("ThunderSlash", 20000)
    end

    if KitanoiFuncs.ScanForCaster2({ 43085, 43084 }) and not Mech.IsActive("InOut") then
        local boomIn = nil
        local boomOut = nil
        for _, ee in pairs(Argus.getCurrentAOEs()) do
            if ee.aoeID == 43084 then
                boomIn = ee
            else
                boomOut = ee
            end
        end
        if boomIn ~= nil or boomOut ~= nil then
            Mech.Trigger("InOut", 15000)
        end
    end

    -- P1: N/S first pattern
    -- P2: NW/SE safe second pattern ++ left
    -- P3: S/NW/NE unsafe + shard
    -- P4: W/E unsafe + shard + holy hazard
    -- P5: S/NW/NE unsafe + shard

    -- 43093 bloom?
    local bloomId = 430931231
    KitanoiSettings.AvoidThisArea[bloomId] = {
        type = "circle",
        entity = bloomId,
        target = 0,
        aoeID = bloomId,
        name = "noname",
        radius = 4.5,
        length = 4.5,
        width = 4.5,
        pos = {x=100,y=0,z=100},
        heading = 0,
        casttime = 2,
        channelingtime = 0,
        deletetime = Now() + 5000,
    }

    if NoobgamKdfProfiles.IsMarkerUp(471) and not Mech.IsActive("Tankbuster") then
        Mech.Trigger("Tankbuster", 20000)
    end

    if Mech.IsActive("Shock") then
        handleMechanic("Shock")
    end

    if Mech.IsActive("InOut") then
        handleMechanic("InOut")
    end

    -- 43446 rose in boom
    -- 43447 rose out boom

    if Mech.IsActive("ThunderSlash") then
        handleMechanic("ThunderSlash")
    end

    if Mech.IsActive("Tankbuster") then
        handleMechanic("Tankbuster")
    end

    if KitanoiFuncs.ScanForCaster2({ 43112, 43113 }) then
        NoobgamKdfProfiles.UseMits()
    end

    if Player.hp.percent < 40 then
        NoobgamKdfProfiles.UseMits()
    end

    if not somethingOngoing and KitanoiFuncs.HowManyAOES(true) <= 0 then
        local r = 5
        local dx = r * math.sin(1.45)
        local dz = r * math.cos(1.45)
        KitanoiNavigation.NavAPI.MoveTo(100 + dx, 0, 100 + dz)
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
            24298,
            24310,
        })
        KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
        KitanoiSettings.avoidingtime = Now() + 2000
    end
    -- avoiding bubbles doesn't work like this. 
    -- local bubbles = KitanoiFuncs.entityList("contentid=12588")
    -- if table.valid(bubbles) then
    --     KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
    --     KitanoiSettings.avoidingtime = Now() + 2000
    --     -- for i, e in pairs(bubbles) do
    --     --     if (i and e and TensorCore.getEntitySpeed(i) > 0) then
    --     --         local poly1 = KitanoiFuncs.SquarePolygon(e.pos, 4, 6, e.pos.h, 1)
    --     --         KitanoiFuncs.CurrentAOEs[i] = {
    --     --             type = "rectangle",
    --     --             entity = i,
    --     --             target = i,
    --     --             pos = point1,
    --     --             length = 4,
    --     --             width = 4,
    --     --             heading = -1.570796,
    --     --             aoeID = 0000,
    --     --             name = "",
    --     --             poly = poly1,
    --     --             casttime = 2,
    --     --             channelingtime = 2,
    --     --             deletetime = Now() + 750,
    --     --         }
    --     --         KitanoiSettings.AvoidThisArea[i] = {}
    --     --         KitanoiSettings.AvoidThisArea[i].poly = poly1
    --     --         KitanoiSettings.AvoidThisArea[i].timer = Now() + 750
    --     --         local start, mid, endC, outlineColor, outlineThickness = TensorCore.getMoogleColors()
    --     --         Argus2.addTimedRectFilled(750, e.pos.x, e.pos.y, e.pos.z, 6, 4, e.pos.h, start, endC, mid, 0, nil,
    --     --             nil, outlineColor, outlineThickness)
    --     --     end
    --     -- end
    -- end
    if (soaks ~= nil and soaks ~= false and HMAOES == 0 and not NoobgamKdfProfiles.IsMarkerUp(197)) then
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

    if (NoobgamKdfProfiles.IsMarkerUp(376) and not NoobgamKdfProfiles.IsMarkerUp(100)) then
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
    if (NoobgamKdfProfiles.IsMarkerUp(376) and Player.role == 4 and not Player:IsMoving()) then
        KitanoiFuncs.HealDoomMulti()
    end
    if (NoobgamKdfProfiles.IsMarkerUp(376) and Player.role == 1) then
        -- local action = ActionList:Get(5,3)
        -- if ( action ) then
        -- action:Cast()
        -- end
    end
    if (NoobgamKdfProfiles.IsMarkerUp(197) and not NoobgamKdfProfiles.DoIHaveMarker(197) and HMAOES == 0) then
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
    if (NoobgamKdfProfiles.IsMarkerUp(100) and HMAOES == 0) then
        KitanoiNavigation.NavAPI.MoveTo(100, 0, 100)
        KitanoiSettings.avoidingtime = Now() + 2000
    end
    if (NoobgamKdfProfiles.IsMarkerUp(364)) then
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
        and (Player.castinginfo.casttime - Player.castinginfo.channeltime < 4)
    then
        KitanoiSettings.DisableKDFAvoidance = true
        return true
    else
        KitanoiSettings.DisableKDFAvoidance = false
        return false
    end
end

function NoobgamKdfProfiles.CountMaxLevel()
    local count = 0
    for _, v in pairs(EntityList.myparty) do
        if v.level >= 100 then count = count + 1 end
    end
    return count
end

function NoobgamKdfProfiles.GetSortedIndex()
    for i, entId in pairs(KitanoiFuncs.ReturnSortedParty()) do
        if entId == Player.id then
            return i
        end
    end
    return nil
end

function NoobgamKdfProfiles.ClockPositions(x, y, z, radius, dontgo)
    dontgo = dontgo or false
    local cnt = NoobgamUtils.tableSize(KitanoiFuncs.ReturnSortedParty())
    local angle = 2 * 3.14159265 / cnt
    for i, entId in pairs(KitanoiFuncs.ReturnSortedParty()) do
        if entId == Player.id then
            if not dontgo then
                KitanoiNavigation.NavAPI.MoveTo(
                    x + radius * math.sin(angle * i),
                    y,
                    z + radius * math.cos(angle * i)
                )
            end
            return {
                x = x + radius * math.sin(angle * i),
                y = y,
                z = z + radius * math.cos(angle * i)
            }
        end
    end
    return {}
end

function NoobgamKdfProfiles.ScanForCasts(...)
    local args = {...}
    for _, chanId in ipairs(args) do
        local ent = KitanoiFuncs.ScanForCaster2(chanId, nil, nil, true)
        if ent ~= nil and ent ~= false then
            return chanId, ent
        end
    end
    return nil, nil
end

--- @param markerType integer
function NoobgamKdfProfiles.IsMarkerUp(markerType)
    for _, v in pairs(KitanoiSettings.knownmarkers) do
        if v.markertype == markerType then
            return true
        end
    end
    return false
end

--- @param markerType integer
--- @param id integer|nil
function NoobgamKdfProfiles.DoIHaveMarker(markerType, id)
    id = id or Player.id
    for _, v in pairs(KitanoiSettings.knownmarkers) do
        if v.markertype == markerType and v.target == id then
            return true
        end
    end
    return false
end

--- @param markerType integer
--- @param id integer|nil
function NoobgamKdfProfiles.DoIHaveMarker2(markerType, id)
    id = id or Player.id
    for _, v in pairs(KitanoiSettings.knownmarkers) do
        if v.markertype == markerType and v.entityID2 == id then
            return true
        end
    end
    return false
end

--- Estimate the number of Echo stacks (buff 42) we currently have by comparing
--- our current max HP against the base (0-stack) max HP recorded on instance entry.
--- Each Echo stack adds a flat 10% of *base* max HP (additive), so:
---   stacks = round((currentMaxHp / baseMaxHp - 1) / 0.10)
--- No Echo buff => 0 stacks.
---@return integer
function NoobgamKdfProfiles.DetectEchoStacks()
    if not HasBuff(Player, 42) then
        return 0
    end
    local baseHp = KitanoiSettings.StoreVar.EchoBaseHp
    local maxHp = Player.hp and Player.hp.max
    if not baseHp or baseHp <= 0 or not maxHp or maxHp <= 0 then
        -- Can't estimate yet; keep whatever we had.
        return KitanoiSettings.StoreVar.EchoStacks or 0
    end
    local stacks = math.floor((maxHp / baseHp - 1) * 10 + 0.5)
    if stacks < 0 then
        stacks = 0
    end
    return stacks
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

    -- Stack detection now happens in the update flow (see UpdateEchoStacks), we just consume it here.
    local echoStacksWeHave = KitanoiSettings.StoreVar.EchoStacks or 0

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

--- Records base HP on first instance entry and re-estimates Echo stacks after a wipe.
--- Runs from the update flow regardless of whether the echo stacker (FarmEcho) is in use.
local function UpdateEchoStacks()
    local mapid = Player.localmapid
    if mapid == 0 then
        -- Not inside an instance: forget the instance-specific baseline.
        KitanoiSettings.StoreVar.EchoBaseMapId = nil
        KitanoiSettings.StoreVar.EchoBaseHp = nil
        KitanoiSettings.StoreVar.EchoStacks = nil
        return
    end

    -- First time we enter this instance: record the base (0-stack) max HP.
    -- Guard on "no Echo buff" so we capture a clean baseline.
    if KitanoiSettings.StoreVar.EchoBaseMapId ~= mapid then
        local maxHp = Player.hp.max
        if maxHp and maxHp > 0 and not HasBuff(Player, 42) then
            KitanoiSettings.StoreVar.EchoBaseMapId = mapid
            KitanoiSettings.StoreVar.EchoBaseHp = maxHp
            KitanoiSettings.StoreVar.EchoStacks = 0
            d("[EchoStacker] recorded base HP " .. maxHp .. " for map " .. mapid)
        end
        return
    end

    -- Re-estimate stacks right after a wipe/new pull (same signal as the mechanic-state reset),
    -- or once if we have no reading yet.
    if Player.alive and (KitanoiSettings.StoreVar.EchoStacks == nil or TimeSince(KitanoiSettings.InCombatTimer) < 3000) then
        local es = NoobgamKdfProfiles.DetectEchoStacks()
        if es ~= KitanoiSettings.StoreVar.EchoStacks then
            KitanoiSettings.StoreVar.EchoStacks = es
            d("[EchoStacker] recorded base HP " .. Player.hp.max .. ", echo= " .. es)
        end
    end
end

-- kdf doesn't run on every tick. this sucks ass.
local function update()
    UpdateEchoStacks()
    -- we need to get this working again.
    if Player.localmapid == 1202 then
        -- NoobgamKdfProfiles.Interphos()
    elseif Player.localmapid == 1270 then
        -- NoobgamKdfProfiles.Recollection()
    end
end

RegisterEventHandler([[Gameloop.Update]], update, [[NoobgamKdfProfiles.Update]])

return NoobgamKdfProfiles