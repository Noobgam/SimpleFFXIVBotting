if MsqBootstrap == nil then
    MsqBootstrap = {}
    MsqBootstrap.Enabled = false
    MsqBootstrap.WaitUntil = nil
    MsqBootstrap.WaitCondition = nil
    MsqBootstrap.BreakOutDelayMillis = nil
    MsqBootstrap.LastProfile = nil
end

local function log(msg)
    d("[MsqBootstrap] " .. msg)
end

-- Configuration
local CONFIG = {
    msqProfile = "(Latty) 1-100 [Unlocked]",
    jobProfile = "Class Quests Pack",
    jobMapping = {
        [FFXIV.JOBS.GLADIATOR] = FFXIV.JOBS.PALADIN,
        [FFXIV.JOBS.MARAUDER] = FFXIV.JOBS.WARRIOR,
        [FFXIV.JOBS.ARCHER] = FFXIV.JOBS.BARD,
        [FFXIV.JOBS.ROGUE] = FFXIV.JOBS.NINJA,
        [FFXIV.JOBS.PUGILIST] = FFXIV.JOBS.MONK,
        [FFXIV.JOBS.CONJURER] = FFXIV.JOBS.WHITEMAGE,
    },
    -- quest completion IDs for job quests at each level threshold
    jobQuestCompletion = {
        [30] = {
            [FFXIV.JOBS.PALADIN] = 1055,
            [FFXIV.JOBS.WARRIOR] = 1049,
            [FFXIV.JOBS.DRAGOON] = 1067,
            [FFXIV.JOBS.MONK] = 1061,
            [FFXIV.JOBS.NINJA] = 212,
            [FFXIV.JOBS.BARD] = 1085,
            [FFXIV.JOBS.WHITEMAGE] = 1079,
            [FFXIV.JOBS.SCHOLAR] = 1097,
            [FFXIV.JOBS.BLACKMAGE] = 1073,
            [FFXIV.JOBS.SUMMONER] = 1091,
        },
        [50] = {
            [FFXIV.JOBS.PALADIN] = 1060,
            [FFXIV.JOBS.WARRIOR] = 1054,
            [FFXIV.JOBS.DARKKNIGHT] = 2058,
            [FFXIV.JOBS.DRAGOON] = 1072,
            [FFXIV.JOBS.MONK] = 1066,
            [FFXIV.JOBS.NINJA] = 234,
            [FFXIV.JOBS.SAMURAI] = 2560,
            [FFXIV.JOBS.BARD] = 1090,
            [FFXIV.JOBS.MACHINIST] = 1703,
            [FFXIV.JOBS.WHITEMAGE] = 1084,
            [FFXIV.JOBS.SCHOLAR] = 1102,
            [FFXIV.JOBS.ASTROLOGIAN] = 2018,
            [FFXIV.JOBS.BLACKMAGE] = 1078,
            [FFXIV.JOBS.SUMMONER] = 1096,
            [FFXIV.JOBS.REDMAGE] = 2577,
        },
        [60] = {
            [FFXIV.JOBS.PALADIN] = 2037,
            [FFXIV.JOBS.WARRIOR] = 601,
            [FFXIV.JOBS.DARKKNIGHT] = 2064,
            [FFXIV.JOBS.GUNBREAKER] = 3262,
            [FFXIV.JOBS.DRAGOON] = 1695,
            [FFXIV.JOBS.MONK] = 2031,
            [FFXIV.JOBS.NINJA] = 1688,
            [FFXIV.JOBS.SAMURAI] = 2565,
            [FFXIV.JOBS.BARD] = 1718,
            [FFXIV.JOBS.MACHINIST] = 1712,
            [FFXIV.JOBS.DANCER] = 3250,
            [FFXIV.JOBS.WHITEMAGE] = 1725,
            [FFXIV.JOBS.SCHOLAR] = 1676,
            [FFXIV.JOBS.ASTROLOGIAN] = 2025,
            [FFXIV.JOBS.BLACKMAGE] = 1683,
            [FFXIV.JOBS.SUMMONER] = 2105,
            [FFXIV.JOBS.REDMAGE] = 2582,
        },
        [70] = {
            [FFXIV.JOBS.PALADIN] = 2575,
            [FFXIV.JOBS.WARRIOR] = 2904,
            [FFXIV.JOBS.DARKKNIGHT] = 2919,
            [FFXIV.JOBS.GUNBREAKER] = 3266,
            [FFXIV.JOBS.DRAGOON] = 2914,
            [FFXIV.JOBS.MONK] = 2430,
            [FFXIV.JOBS.NINJA] = 2952,
            [FFXIV.JOBS.SAMURAI] = 2570,
            [FFXIV.JOBS.REAPER] = 4074,
            [FFXIV.JOBS.BARD] = 2894,
            [FFXIV.JOBS.MACHINIST] = 2909,
            [FFXIV.JOBS.DANCER] = 3254,
            [FFXIV.JOBS.WHITEMAGE] = 2418,
            [FFXIV.JOBS.SCHOLAR] = 2927,
            [FFXIV.JOBS.ASTROLOGIAN] = 2413,
            [FFXIV.JOBS.SAGE] = 4068,
            [FFXIV.JOBS.BLACKMAGE] = 2592,
            [FFXIV.JOBS.SUMMONER] = 2629,
            [FFXIV.JOBS.REDMAGE] = 2587,
        },
        [80] = {
            [FFXIV.JOBS.SAGE] = 4072,
            [FFXIV.JOBS.PICTOMANCER] = 4854,
        },
    },
    roleQuestCompletion = {
        [70] = {
            TANK = 3243,
            PHYSICAL_DPS = 3273,
            MAGICAL_RANGED_DPS = 3623,
            HEALER = 3267,
        },
        [72] = {
            TANK = 3244,
            PHYSICAL_DPS = 3274,
            MAGICAL_RANGED_DPS = 3624,
            HEALER = 3268,
        },
        [74] = {
            TANK = 3245,
            PHYSICAL_DPS = 3275,
            MAGICAL_RANGED_DPS = 3625,
            HEALER = 3269,
        },
        [76] = {
            TANK = 3246,
            PHYSICAL_DPS = 3276,
            MAGICAL_RANGED_DPS = 3626,
            HEALER = 3270,
        },
        [78] = {
            TANK = 3247,
            PHYSICAL_DPS = 3277,
            MAGICAL_RANGED_DPS = 3627,
            HEALER = 3271,
        },
        [80] = {
            TANK = 3248,
            PHYSICAL_DPS = 3278,
            MAGICAL_RANGED_DPS = 3628,
            HEALER = 3272,
        },
    },
    -- Job to role mapping for role quests
    jobToRole = {
        [FFXIV.JOBS.PALADIN] = "TANK",
        [FFXIV.JOBS.WARRIOR] = "TANK",
        [FFXIV.JOBS.DARKKNIGHT] = "TANK",
        [FFXIV.JOBS.GUNBREAKER] = "TANK",
        
        [FFXIV.JOBS.MONK] = "PHYSICAL_DPS",
        [FFXIV.JOBS.DRAGOON] = "PHYSICAL_DPS",
        [FFXIV.JOBS.NINJA] = "PHYSICAL_DPS",
        [FFXIV.JOBS.SAMURAI] = "PHYSICAL_DPS",
        [FFXIV.JOBS.REAPER] = "PHYSICAL_DPS",
        [FFXIV.JOBS.BARD] = "PHYSICAL_DPS",
        [FFXIV.JOBS.MACHINIST] = "PHYSICAL_DPS",
        [FFXIV.JOBS.DANCER] = "PHYSICAL_DPS",
        
        [FFXIV.JOBS.BLACKMAGE] = "MAGICAL_RANGED_DPS",
        [FFXIV.JOBS.SUMMONER] = "MAGICAL_RANGED_DPS",
        [FFXIV.JOBS.REDMAGE] = "MAGICAL_RANGED_DPS",
        [FFXIV.JOBS.PICTOMANCER] = "MAGICAL_RANGED_DPS",
        
        [FFXIV.JOBS.WHITEMAGE] = "HEALER",
        [FFXIV.JOBS.SCHOLAR] = "HEALER",
        [FFXIV.JOBS.ASTROLOGIAN] = "HEALER",
        [FFXIV.JOBS.SAGE] = "HEALER",
    },
}

--- @param millis integer
--- @param breakOutCondition (fun(): boolean)|nil
--- @param breakOutDelayMillis number|nil
local function wait(millis, breakOutCondition, breakOutDelayMillis)
    local suggested = Now() + millis

    if breakOutCondition then
        if MsqBootstrap.WaitCondition == nil or MsqBootstrap.WaitUntil < suggested then
            MsqBootstrap.WaitCondition = breakOutCondition
            MsqBootstrap.WaitUntil = suggested
            MsqBootstrap.BreakOutDelayMillis = breakOutDelayMillis
        end
    else
        if MsqBootstrap.WaitUntil == nil or MsqBootstrap.WaitUntil < suggested then
            MsqBootstrap.WaitCondition = nil
            MsqBootstrap.WaitUntil = suggested
        end
    end
end

--- @param targetProfile string
--- @param aether boolean|nil
local function setQuestingProfile(targetProfile, aether)
    if gBotMode ~= "Quest" then
        log("Switching to Quest mode")
        NoobgamUtils.SwitchMode("Quest")
        if FFXIV_Common_BotRunning then
            -- switching bot off prior to doing quests once.
            log("Disabling bot once because switched to quest mode")
            ml_global_information.ToggleRun()
        end
    end

    local rule = "MSQ"
    if aether then
        rule = "Side"
    end

    local subRule = "Aether Current Quests"
    if aether == false and rule == "MSQ" then
        subRule = "All"
    end

    gQuestGatherAetherCurrents = true

    if gQuestProfile ~= targetProfile or QuestOpts_100_v1_QuestRule ~= rule or QuestOpts_100_v1_QuestSubRule ~= subRule then
        log("Setting quest profile. " .. json.encode({
            source = {
                questProfile = gQuestProfile,
                questRule = QuestOpts_100_v1_QuestRule,
                questSubRule = QuestOpts_100_v1_QuestSubRule,
            },
            target = {
                questProfile = targetProfile,
                questRule = rule,
                questSubRule = subRule,
            }
        }))
        local res = NoobgamUtils.SetQuestingProfile(targetProfile)
        QuestOpts_100_v1_QuestRule = rule
        QuestOpts_100_v1_QuestSubRule = subRule
        return res
    end
    return true
end

--- @param profile "msq" | "job" | "none"
--- @param job integer|nil
local function ensureProfileEnabled(profile, job)
    QuestOpts_C_v1_Level = 10

    if MsqBootstrap.LastProfile ~= profile then
        local in_dungeon = table.valid(Duty:GetActiveDutyInfo())
        if in_dungeon then
            log("Preventing profile switch while in dungeon")
            wait(5000)
            return
        end
        if job then
            log("Changing profile to " .. profile .. " " .. job)
        else
            log("Changing profile to " .. profile)
        end
        MsqBootstrap.LastProfile = profile
    end

    if profile == "msq" then
        if not setQuestingProfile(CONFIG.msqProfile) then
            return
        end
        

        if KitanoiFuncs and KitanoiFuncs.AreKitanoiAddonsRunning("KDF") then
            log("KDF is still doing something, will let it be. Questing disabled temporarily")
            wait(5000)
            return
        end

        if not FFXIV_Common_BotRunning then
            log("Enabling bot")
            ffxivminion.DutyCurrentData = {}
            ml_global_information.ToggleRun()
            wait(5000)
            return
        end
        -- these two are incompatible with kdf msq levelling, it relies on endprofile.
        gGrindDoFates = false
        gGrindDoHuntlog = false


        QuestOpts_Q_BuyGreens = true
        QuestOpts_Greens_new = true
        NoobgamPrivateAPI.SetKDFToMsqIntegration()
        return
    elseif profile == "job" then
        if not setQuestingProfile(CONFIG.jobProfile) then
            log("job profile could not be set. Assuming it's missing, will try to pick some other")
            local allProfiles = Questing.profilesDisplay
            for _, prof in pairs(allProfiles) do
                if prof:find(" Class Quests", 1, true) ~= nil then
                    CONFIG.jobProfile = prof
                    log("Will use [" .. CONFIG.jobProfile .. "] for sebbs jobs")
                    return
                end
            end
            return
        end
        NoobgamPrivateAPI.SetKDFToNone()

        local sebbsPack = {
            [FFXIV.JOBS.GLADIATOR] = "Paladin",
            [FFXIV.JOBS.ARCHER] = "Bard",
            [FFXIV.JOBS.WARRIOR] = "Warrior",
            [FFXIV.JOBS.PALADIN] = "Paladin",
            [FFXIV.JOBS.SAGE] = "Sage",
            [FFXIV.JOBS.NINJA] = "Ninja",
            [FFXIV.JOBS.BARD] = "Bard",
            [FFXIV.JOBS.WHITEMAGE] = "Whitemage",
        }
        local sebbsVar = sebbsPack[job] or "None"

        QuestOpts_Class90_Job1 = sebbsVar
        QuestOpts_ClassDT_Job1 = sebbsVar
        QuestOpts_GlobalClass_Job1 = sebbsVar
        QuestOpts_RoleQuests = true

        QuestOpts_Q_BuyGreens = true
        QuestOpts_Greens_new = true

        if not FFXIV_Common_BotRunning then
            log("Enabling bot for job quests")
            ffxivminion.DutyCurrentData = {}
            ml_global_information.ToggleRun()
            wait(5000)
            return
        end
        return
    elseif profile == "none" then
        if FFXIV_Common_BotRunning then
            log("Disabling bot")
            ffxivminion.DutyCurrentData = {}
            ml_global_information.ToggleRun()
            wait(5000)
            return
        end
        NoobgamPrivateAPI.SetKDFToNone()
    end
end

--- @param job integer
--- @param level 15|30|50|60|70|80
--- @return boolean
local function doneWithJobQuests(job, level)
    local mapping = CONFIG.jobQuestCompletion[level]
    if mapping == nil then
        return true
    end

    -- check soul crystal at level 30+
    if level >= 30 then
        local baseJobs = {
            FFXIV.JOBS.THAUMATURGE,
            FFXIV.JOBS.GLADIATOR,
            FFXIV.JOBS.ARCHER,
            FFXIV.JOBS.CONJURER,
            FFXIV.JOBS.MARAUDER,
        }
        for _, baseJob in ipairs(baseJobs) do
            if Player.job == baseJob then
                local soul = Inventory:Get(1000):GetList()[14]
                if soul == nil then
                    return false
                end
                break
            end
        end
    end

    local questId = mapping[job]
    if questId == nil then
        return true
    end
    if QuestCompleted(3649) and not QuestCompleted(3650) then
        -- role quests are unlocked sometime before and we can't do next quest without finishing them
        local roleQuest = CONFIG.roleQuestCompletion[80][CONFIG.jobToRole[job]]
        if roleQuest then
            return QuestCompleted(questId) and QuestCompleted(roleQuest)
        end
    end
    return QuestCompleted(questId)
end

--- @param job integer
--- @param targetLevel integer|nil
--- @return boolean whether we're doing job quests
local function doingSomeJobQuests(job, targetLevel)
    targetLevel = targetLevel or 100

    if Player.levels[Player.job] >= 15 then
        if not doneWithJobQuests(job, 15) then
            ensureProfileEnabled("job", job)
            return true
        end
    end

    if targetLevel < 30 then
        return false
    end

    if Player.levels[Player.job] >= 30 and not doneWithJobQuests(job, 30) then
        ensureProfileEnabled("job", job)
        return true
    end

    if targetLevel < 50 then
        return false
    end

    if Player.levels[Player.job] >= 50 and not doneWithJobQuests(job, 50) then
        ensureProfileEnabled("job", job)
        return true
    end

    if targetLevel < 60 then
        return false
    end

    -- Quest 1619 is "Heavensward" completion check
    if Player.levels[Player.job] >= 60 and QuestCompleted(1619) and not doneWithJobQuests(job, 60) then
        ensureProfileEnabled("job", job)
        return true
    end

    if targetLevel < 70 then
        return false
    end

    if Player.levels[Player.job] >= 70
        -- huh?
        and (QuestCompleted(2447))
        and not doneWithJobQuests(job, 70)
    then
        ensureProfileEnabled("job", job)
        return true
    end

    return false
end

--- @param job integer|nil
--- @param jobLevelCap integer|nil
--- @return boolean whether we're doing job stuff
local function doJobStuff(job, jobLevelCap)
    local myJob = CONFIG.jobMapping[Player.job] or Player.job

    local haveChocobo = QuestCompleted(1162)
    local deadlockedByAirship = HasQuest(952) or (QuestCompleted(952) and not QuestCompleted(953))
    local canDoPorta = QuestCompleted(4522)

    -- Always do level 15 job quests first.
    if Player.levels[Player.job] >= 17 then
        if not doneWithJobQuests(myJob, 15) then
            ensureProfileEnabled("job", myJob)
            return true
        end
    end

    -- If job is nil, fallback to our current job
    job = job or myJob

    if myJob ~= job then
        log("[ERROR] adjusting job on the fly is not implemented yet.")
        wait(5000)
        ensureProfileEnabled("msq")
        return true
    end

    -- Quest 715 is "First Contact" - sanity check for job quests
    local timeToJob = not deadlockedByAirship and haveChocobo and QuestCompleted(715)

    if timeToJob then
        if doingSomeJobQuests(job, 50) then
            return true
        end
    end

    if not canDoPorta then
        ensureProfileEnabled("msq")
        return true
    end

    if timeToJob then
        if doingSomeJobQuests(job, jobLevelCap) then
            return true
        end
    end

    return false
end

-- https://github.com/xivapi/ffxiv-datamining/blob/master/csv/en/Item.csv
local chestRanges = {
    {17868, 17868},
    {20275, 20288},
    {20303, 20303},
    {20601, 20612},
    {20620, 20621},
    {20642, 20667},
    {21791, 21791},
    {23980, 23980},
    {24587, 24588},
    {26824, 26902},
    {27266, 27267},
    {29693, 29703},
    {30137, 30141},
    {31691, 31691},
    {31696, 31696},
    {31701, 31701},
    {32144, 32154},
    {32866, 32866},
    {35666, 35743},
    {35872, 35879},
    {35884, 35889},
    {35894, 35899},
    {35904, 35909},
    {35914, 35919},
    {35924, 35929},
    {35935, 35961},
    {36135, 36159},
    {36616, 36617},
    {36813, 36813},
    {38390, 38399},
    {38687, 38687},
    {39584, 39584},
    {40296, 40296},
    {40307, 40316},
    {40355, 40355},
    {41054, 41054},
    {43476, 43538},
    {44274, 44291},
    {44719, 44719},
    {45074, 45078},
    {46709, 46719},
    {46981, 46981},
    {47094, 47094},
    {49737, 49747},
}

local idIsChest = {}
for _, v in pairs(chestRanges) do
    for i = v[1],v[2] do
        idIsChest[i] = true
    end
end

local function openJobChests()
    local in_dungeon = table.valid(Duty:GetActiveDutyInfo()) or Player.localmapid == 0
    if in_dungeon then
        return
    end

    local inventories = { 0, 1, 2, 3 }

    for _, invid in ipairs(inventories) do
        local bag = Inventory:Get(invid)
        if table.valid(bag) then
            for _, item in pairs(bag:GetList()) do
                if idIsChest[item.hqid] then
                    ensureProfileEnabled("none")
                    if Player.mountid ~= 0 then
                        Dismount()
                        return true
                    end
                    item:Cast()
                    return true
                end
            end
        end
    end
end

--- @class MsqCycleParams
--- @field job integer|nil FFXIV.JOBS job to level. If nil will not do any job quests.
--- @field jobLevelCap integer|nil

--- @param params MsqCycleParams|nil
--- @return boolean whether common msq cycle is still ongoing
function MsqBootstrap.CommonMsqCycle(params)
    params = params or {}

    if Player.localmapid == 0 then
        return true
    end

    if openJobChests() then
        return true
    end

    if doJobStuff(params.job, params.jobLevelCap) then
        return true
    end

    if gFFXIVMinionTask == "GRIND_COMBAT" and taskName == "LT_GRIND" and FFXIV_Common_BotRunning then
        log("[WARRIOR] grinding for some reason, will disable main bot")
        wait(5000)
        ml_global_information.ToggleRun()
        return true
    end

    local neededDungeon = MsqClearHelper.CurrentDungeonId or MsqClearHelper.DetectNeededDungeon()
    if neededDungeon ~= nil then
        if neededDungeon == 92 or neededDungeon == 102 or neededDungeon == 111 then
            log("[WARNING] we're on a quest step with unskippable trial. Can't do anything")
            wait(15000)
            return true
        end
        MsqClearHelper.Role = "farmer"
        MsqClearHelper.Update()
        return true
    end

    ensureProfileEnabled("msq")
    return true
end

function MsqBootstrap.Update()
    -- Handle wait conditions
    if MsqBootstrap.WaitUntil ~= nil and MsqBootstrap.WaitUntil > Now() then
        if MsqBootstrap.WaitCondition and MsqBootstrap.WaitCondition() then
            log("Breaking out of wait loop")
            MsqBootstrap.WaitUntil = Now() + (MsqBootstrap.BreakOutDelayMillis or 0)
            MsqBootstrap.BreakOutDelayMillis = nil
            MsqBootstrap.WaitCondition = nil
            return
        else
            return
        end
    end

    -- Setup basic settings
    gACREnabled = true
    gFleeHP = 15
    gSkipTalk = true

    MsqBootstrap.CommonMsqCycle()
end

function MsqBootstrap.Reset()
    MsqBootstrap.WaitUntil = nil
    MsqBootstrap.WaitCondition = nil
    MsqBootstrap.BreakOutDelayMillis = nil
    MsqBootstrap.LastProfile = nil
    log("Reset complete")
end

function MsqBootstrap.EnsureProfileEnabled(profile, job)
    return ensureProfileEnabled(profile, job)
end

MsqBootstrap.CONFIG = CONFIG

return MsqBootstrap