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
        }
    }
end

return NoobgamKdfProfiles