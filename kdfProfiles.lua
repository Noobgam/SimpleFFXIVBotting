if NoobgamKdfProfiles == nil then
    NoobgamKdfProfiles = {
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
        }
    }
end

return NoobgamKdfProfiles