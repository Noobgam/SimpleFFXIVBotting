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
    jobProfile = "(1-100) Class Quests",
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
        [15] = {
            [FFXIV.JOBS.BARD] = 68,
            [FFXIV.JOBS.PALADIN] = 262,
            [FFXIV.JOBS.WARRIOR] = 316,
            [FFXIV.JOBS.NINJA] = 144,
            [FFXIV.JOBS.MONK] = 558,
        },
        [30] = {
            [FFXIV.JOBS.BARD] = 1085,
            [FFXIV.JOBS.PALADIN] = 1055,
            [FFXIV.JOBS.MONK] = 1061,
            [FFXIV.JOBS.WHITEMAGE] = 1079,
        },
        [50] = {
            [FFXIV.JOBS.BARD] = 1090,
            [FFXIV.JOBS.PALADIN] = 1060,
            [FFXIV.JOBS.WARRIOR] = 1054,
            [FFXIV.JOBS.NINJA] = 234,
            [FFXIV.JOBS.MONK] = 1066,
            [FFXIV.JOBS.WHITEMAGE] = 1084,
        },
        [60] = {
            [FFXIV.JOBS.BARD] = 1718,
            [FFXIV.JOBS.PALADIN] = 2037,
            [FFXIV.JOBS.WARRIOR] = 601,
            [FFXIV.JOBS.NINJA] = 1688,
            [FFXIV.JOBS.MONK] = 2031,
        },
        [70] = {
            [FFXIV.JOBS.NINJA] = 2952,
            [FFXIV.JOBS.PALADIN] = 2575,
            [FFXIV.JOBS.WARRIOR] = 2904,
            [FFXIV.JOBS.BARD] = 2894,
        },
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

local function setMinionQuestingProfile(profileName)
    ---@type string[]
    local allProfiles = Questing.profilesDisplay
    for idx, name in pairs(allProfiles) do
        if name == profileName then
            log("Found profile index: " .. idx)
            gQuestProfileIndex = idx
            gQuestProfile = profileName

            Questing.UpdateSelection(profileName)
        end
    end
    log("[ERROR] Could not find questing profile")
end

--- @param targetProfile string
--- @param aether boolean|nil
local function setQuestingProfile(targetProfile, aether)
    if gBotMode ~= "Quest" then
        log("Switching to Quest mode")
        gBotMode = "Quest"
        ffxivminion.SwitchMode("Quest")
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

    if Player.localmapid == 614
        or Player.localmapid == 613
        or Player.localmapid == 816
        or Quest:GetQuestCurrentStep(4521) == 3
        or Quest:GetQuestCurrentStep(4902) == 1
    then
        subRule = "All"
        gQuestGatherAetherCurrents = false
    end

    if Player.localmapid == 397 then
        gQuestGatherAetherCurrents = false
    end

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
        setMinionQuestingProfile(targetProfile)
        QuestOpts_100_v1_QuestRule = rule
        QuestOpts_100_v1_QuestSubRule = subRule
        return true
    end
    return false
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
        if setQuestingProfile(CONFIG.msqProfile) then
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

        QuestOpts_Q_BuyGreens = true
        QuestOpts_Greens_new = true
        NoobgamPrivateAPI.SetKDFToMsqIntegration()
        return
    elseif profile == "job" then
        setQuestingProfile(CONFIG.jobProfile)
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
        QuestOpts_RoleQuests = false

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
--- @param level 15|30|50|60|70
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

    if Player.levels[Player.job] >= 70 and QuestCompleted(1619) and not doneWithJobQuests(job, 70) then
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

    local haveGc = QuestCompleted(702) or QuestCompleted(701) or QuestCompleted(703)
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
    local timeToJob = not deadlockedByAirship and haveGc and haveChocobo and QuestCompleted(715)

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

local function openJobChests()
    local in_dungeon = table.valid(Duty:GetActiveDutyInfo()) or Player.localmapid == 0
    if in_dungeon then
        return false
    end

    local chestRanges = {
        {20601, 20612}, -- Fending coffer (IL 240) and similar
        {20642, 20670}, -- IL90 coffers
        {20275, 20288}, -- IL 290 job coffers
    }

    for invid = 0, 3 do
        local bag = Inventory:Get(invid)
        if table.valid(bag) then
            for _, item in pairs(bag:GetList()) do
                if item then
                    for _, range in ipairs(chestRanges) do
                        if item.hqid >= range[1] and item.hqid <= range[2] then
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
    end
    return false
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

return MsqBootstrap