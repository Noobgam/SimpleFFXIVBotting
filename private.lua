---@diagnostic disable: duplicate-set-field
NoobgamPrivateAPI = {}

local function log(msg)
    d("[NoobgamPrivateAPI] " .. msg)
end

function NoobgamPrivateAPI.SetKDFToNone()
    if KitanoiSettings == nil or kIO == nil then
        return
    end

    KitanoiFuncs.EnableAddon("kdf", false)

    if KitanoiSettings.KDFIntegration ~= 1 then
        KitanoiSettings.SingleOrQueue = 1
        KitanoiSettings.KDFIntegration = 1
        kIO.save()
    end

    local dungeonName = KDF.Name()
    if dungeonName ~= nil and dungeonName:lower() ~= "none" then
        log("Clearing selected KDF dungeon: " .. dungeonName)
        KitanoiFuncs.LoadDungeonTbl({
            name = "None",
            dutyid = 9999999,
            hacks = false,
            enemylos = true,
            queuetype = 1,
            interactdistance = 5,
            enemytargetdistance = 5,
            prioritytargetdistance = 5,
            objectivedestinations = {},
            hasbuff = {},
            interacts = {},
            dontclearfriendlytargets = {},
            useaction = {},
            tankat = {},
            bossids = {},
            prioritytarget = {},
            forcemeleerange = {},
            advancedavoid = {},
            overheadmarkers = {},
        })
        kIO.save()
    end
end

function NoobgamPrivateAPI.SetKDFToMsqIntegration()
    if KitanoiSettings == nil or kIO == nil then
        return
    end

    if KitanoiSettings.KDFIntegration ~= 2 then
        if not QuestCompleted(4522) then
            QuestOpts_Q_v1_AllaganPiece = false
        end

        KitanoiSettings.AutoTrusts = true
        KitanoiSettings.AutoStoryDungeons = true
        KitanoiSettings.AdditionalQuests = true
        KitanoiFuncs.MSQindex = nil
        KitanoiFuncs.KDFNMJBLG = true
        KitanoiSettings.SingleOrQueue = 1
        KitanoiSettings.KDFIntegration = 2
        kIO.save()
    end
end

return NoobgamPrivateAPI
