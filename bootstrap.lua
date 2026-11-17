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

-- Shared loader for addon initialization and bootstrap.
---@return BundledClassQuestAPI
local function classProfile()
    if NoobgamClassQuests == nil then
        local path = GetLuaModsPath() .. "SimpleFFXIVBotting/questing/class_quests.lua"
        local chunk, err = loadfile(path)
        if chunk == nil then error("Cannot load bundled class quests: " .. tostring(err)) end
        chunk()
    end
    ---@cast NoobgamClassQuests BundledClassQuestAPI
    return NoobgamClassQuests
end

---@return boolean|nil registered
---@return string|nil error
function MsqBootstrap.RegisterClassProfile()
    return classProfile().EnsureRegistered()
end

-- Configuration (milestones also feed the GUI).
local CONFIG = {
    jobProfile = "Noobgam Class Quests (Current Job)",
    jobMapping = {
        [FFXIV.JOBS.GLADIATOR] = FFXIV.JOBS.PALADIN,
        [FFXIV.JOBS.MARAUDER] = FFXIV.JOBS.WARRIOR,
        [FFXIV.JOBS.ARCHER] = FFXIV.JOBS.BARD,
        [FFXIV.JOBS.ROGUE] = FFXIV.JOBS.NINJA,
        [FFXIV.JOBS.PUGILIST] = FFXIV.JOBS.MONK,
        [FFXIV.JOBS.CONJURER] = FFXIV.JOBS.WHITEMAGE,
        [FFXIV.JOBS.LANCER] = FFXIV.JOBS.DRAGOON,
        [FFXIV.JOBS.THAUMATURGE] = FFXIV.JOBS.BLACKMAGE,
        [FFXIV.JOBS.ARCANIST] = FFXIV.JOBS.SUMMONER,
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

local function isLattyQuestingRunning()
    return LattyLib.QuestCore.running == true
end

local function isLattyDungeonHandoffActive()
    local handoff = LattyLib.DungeonHandoffCore
    return type(handoff) == "table"
        and type(handoff.active) == "table"
        and handoff.stage ~= "idle", handoff
end
MsqBootstrap.IsLattyDungeonHandoffActive = isLattyDungeonHandoffActive

local function resetLattyRestartDebounce()
    NoobgamCircuitBreaker.ResetLattyRestartDelay()
end

local function holdLattyDungeonHandoff()
    local active, handoff = isLattyDungeonHandoffActive()
    if not active then
        MsqBootstrap.LastLattyHandoffStage = nil
        return false
    end
    resetLattyRestartDebounce()
    local now = GetTickCount()
    if MsqBootstrap.LastLattyHandoffStage ~= handoff.stage
        or MsqBootstrap.LastLattyHandoffLogAt == nil
        or now - MsqBootstrap.LastLattyHandoffLogAt >= 30000
    then
        log("Yielding to Latty dungeon handoff: key=" .. tostring(handoff.active.key)
            .. " stage=" .. tostring(handoff.stage)
            .. " map=" .. tostring(Player.localmapid)
            .. " status=" .. tostring(handoff.lastStatus))
        MsqBootstrap.LastLattyHandoffStage = handoff.stage
        MsqBootstrap.LastLattyHandoffLogAt = now
    end
    return true
end
MsqBootstrap.HoldLattyDungeonHandoff = holdLattyDungeonHandoff

-- Bootstrap's MSQ flow includes either Aether Current quests (default) or Blue
-- Quests when the existing config option requests that filter. Every other side
-- pack stays disabled. Pin and validate before every start because Latty persists
-- the previous UI selection.
local function configureLattyQuesting()
    local settings = LattyLib.Settings
    local useBlueQuests = NoobgamConfigManager.Config.useBlueQuestFilter == true
    local sideRule = useBlueQuests and "BLUE" or "AETHER"
    local changed = false
    local function setValue(tbl, key, value)
        if tbl[key] ~= value then
            log("Changed latty setting from " .. key .. " to " .. tostring(value))
            tbl[key] = value
            changed = true
        end
    end

    setValue(settings, "QuestRule", "MSQ")
    setValue(settings, "SideQuestRule", sideRule)

    if type(settings.SideQuestPacks) ~= "table" then
        settings.SideQuestPacks = {}
        changed = true
    end
    setValue(settings.SideQuestPacks, "AetherCurrent", not useBlueQuests)
    setValue(settings.SideQuestPacks, "BlueQuests", useBlueQuests)
    setValue(settings.SideQuestPacks, "Moogle", false)
    setValue(settings.SideQuestPacks, "Namazu", false)
    setValue(settings.Options, "KDFUseNativeQuesting", true )
    if not settings.Company.GrandCompany or settings.Company.GrandCompany == "None" then
        settings.Company.GrandCompany = "Maelstrom"
        log("Pinned the gc to maelstrom")
        changed = true
    end

    if type(settings.Custom) ~= "table" then
        settings.Custom = {}
        changed = true
    end
    if type(settings.Custom.ChocoboName) ~= "string"
        or settings.Custom.ChocoboName:match("^%s*$") then
        local chocoboNames = {
            "Featherstep", "Sunplume", "Goldbeak", "Stormplume", "Swiftclaw",
            "Amberwing", "Windspur", "Dusktalon", "Brightplume", "Skywhistle",
            "Cloudstride", "Moonclaw", "Starwhistle", "Talongleam", "Sunchaser",
            "Wingflare", "Galesong", "Thunderplume", "Duskrunner", "Brightwing",
        }
        setValue(settings.Custom, "ChocoboName", chocoboNames[math.random(#chocoboNames)])
    end

    if type(settings.Questing) ~= "table" then
        settings.Questing = {}
        changed = true
    end
    setValue(settings.Questing, "CatalogName", "Latty Native Quest Runtime")
    if type(settings.Questing.CatalogVars) ~= "table"
        or next(settings.Questing.CatalogVars) ~= nil
    then
        settings.Questing.CatalogVars = {}
        changed = true
    end

    if changed then
        LattyLib.MarkSettingsDirty()
    end

    local rule = LattyLib.GetQuestRuleValue()
    local effectiveSideRule = LattyLib.GetEffectiveSideQuestRule()
    local includesMSQ = LattyLib.InLattyPackRule("MSQ")
    local includesSide = LattyLib.InLattyPackRule("Side")
    local includesAether = LattyLib.LattyPackAetherQuests()
    local includesBlue = LattyLib.LattyPackBlueQuests()
    if rule ~= "MSQ" or effectiveSideRule ~= sideRule
        or includesMSQ ~= true or includesSide ~= false
        or includesAether ~= (not useBlueQuests) or includesBlue ~= useBlueQuests
    then
        log("[ERROR] Refusing to start Latty questing with unexpected rules: " .. json.encode({
            rule = rule,
            sideRule = effectiveSideRule,
            includesMSQ = includesMSQ,
            includesSide = includesSide,
            includesAether = includesAether,
            includesBlue = includesBlue,
        }))
        return false, changed
    end

    return true, changed
end

local function startLattyQuesting()
    if holdLattyDungeonHandoff() then
        return false
    end
    local inDungeon = table.valid(Duty:GetActiveDutyInfo())
    local kdfActive = KitanoiFuncs ~= nil
        and KitanoiFuncs.AreKitanoiAddonsRunning ~= nil
        and KitanoiFuncs.AreKitanoiAddonsRunning("KDF")
    if inDungeon or kdfActive then
        resetLattyRestartDebounce()
        local now = GetTickCount()
        if MsqBootstrap.LastLattyKDFSuppressionLog == nil
            or MsqBootstrap.LastLattyKDFSuppressionLog < now - 30000
        then
            log("Preventing Latty start while KDF/duty owns execution: " .. json.encode({
                kdfActive = kdfActive,
                inDungeon = inDungeon,
            }))
            MsqBootstrap.LastLattyKDFSuppressionLog = now
        end
        return false
    end

    local configured, changed = configureLattyQuesting()
    if not configured then
        return false
    end

    local core = LattyLib.QuestCore
    if core.running == true then
        MsqBootstrap.LattyWasRunning = true
        resetLattyRestartDebounce()
        if changed then
            core.Resolve(true)
            log("Corrected running Latty questing settings")
        end
        return true
    end

    if core.stopping == true then
        resetLattyRestartDebounce()
        return false
    end

    if not NoobgamCircuitBreaker.CanStartLatty(core) then
        return false
    end

    -- Latty refuses to start while Minion owns the task hub. Relinquish a stale
    -- questMode run first and start Latty on the next update.
    if FFXIV_Common_BotRunning then
        log("Disabling Minion bot before starting Latty questing")
        ffxivminion.DutyCurrentData = {}
        ml_global_information.ToggleRun()
        wait(1000)
        return false
    end

    -- Avoid hammering Start while Latty publishes its execution modules.
    local now = GetTickCount()
    if MsqBootstrap.LastLattyStartAttempt ~= nil
        and MsqBootstrap.LastLattyStartAttempt > now - 3000
    then
        return false
    end
    MsqBootstrap.LastLattyStartAttempt = now
    NoobgamPrivateAPI.SetKDFToMsqIntegration()

    local canStart, startSource = NoobgamCircuitBreaker.GetLattyStartSource(core)
    if not canStart then return false end

    local ok, started, detail
    if startSource ~= nil then
        ok, started, detail = pcall(LattyLib.StartQuesting, startSource)
    else
        ok, started, detail = pcall(LattyLib.StartQuesting)
    end
    if not ok then
        log("[ERROR] LattyLib.StartQuesting failed: " .. tostring(started))
        return false
    end
    if started == false then
        log("[WARNING] LattyLib rejected START QUESTING: " .. tostring(detail))
        return false
    end

    MsqBootstrap.LattyWasRunning = true
    resetLattyRestartDebounce()
    log("Started Latty questing with MSQ + "
        .. (NoobgamConfigManager.Config.useBlueQuestFilter and "Blue" or "Aether") .. " settings: "
        .. tostring(core.lastStatus or core.executionStatus or "starting"))
    return true
end

local function stopLattyQuesting()
    local core = LattyLib.QuestCore
    if core.running ~= true and core.stopping ~= true then
        return false
    end

    local ok, stopped, detail = pcall(LattyLib.StopQuesting)
    if not ok then
        log("[ERROR] LattyLib.StopQuesting failed: " .. tostring(stopped))
        return false
    end
    if stopped == false and core.running == true then
        log("[WARNING] LattyLib deferred STOP QUESTING: " .. tostring(detail))
    else
        log("Stopped Latty questing")
    end
    return true
end

--- Select a Minion Questing profile. The native Latty MSQ flow does not use this;
--- this helper selects the bundled current-job profile.
--- @param targetProfile string
local function setQuestingProfile(targetProfile)
    if gBotMode ~= "questMode" then
        log("Switching to questMode")
        NoobgamUtils.SwitchMode("questMode")
        if FFXIV_Common_BotRunning then
            -- switching bot off prior to doing quests once.
            log("Disabling bot once because switched to questMode")
            ml_global_information.ToggleRun()
        end
    end

    local rule = "MSQ"
    local subRule = "All"
    gQuestGatherAetherCurrents = false

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
    if profile == "none" then
        MsqBootstrap.LattyWasRunning = nil
        resetLattyRestartDebounce()
        QuestOpts_C_v1_Level = NoobgamConfigManager.Config.questLevelCap or 10
        if MsqBootstrap.LastProfile ~= profile then
            log("Changing profile to " .. profile)
            MsqBootstrap.LastProfile = profile
        end
        if stopLattyQuesting() then
            wait(1000)
            return
        end
        if FFXIV_Common_BotRunning then
            log("Disabling bot")
            ffxivminion.DutyCurrentData = {}
            ml_global_information.ToggleRun()
            wait(5000)
            return
        end
        NoobgamPrivateAPI.SetKDFToNone()
        return
    end

    if holdLattyDungeonHandoff() then
        return
    end
    QuestOpts_C_v1_Level = NoobgamConfigManager.Config.questLevelCap or 10

    if MsqBootstrap.LastProfile ~= profile then
        local in_dungeon = table.valid(Duty:GetActiveDutyInfo())
        if in_dungeon then
            resetLattyRestartDebounce()
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
        startLattyQuesting()
        return
    elseif profile == "job" then
        -- This is a planned pause, not an unexpected stop requiring recovery.
        MsqBootstrap.LattyWasRunning = nil
        resetLattyRestartDebounce()
        if isLattyQuestingRunning() then
            stopLattyQuesting()
            wait(1000)
            return
        end
        local registered, err = classProfile().EnsureRegistered()
        if not registered then
            log("[WARNING] " .. tostring(err))
            wait(1000)
            return
        end
        if not setQuestingProfile(CONFIG.jobProfile) then
            log("[ERROR] Bundled class profile is unavailable")
            wait(1000)
            return
        end
        NoobgamPrivateAPI.SetKDFToNone()

        if not FFXIV_Common_BotRunning then
            log("Enabling bot for job quests")
            ffxivminion.DutyCurrentData = {}
            ml_global_information.ToggleRun()
            wait(5000)
            return
        end
        return
    end
end

--- @param job integer|nil
--- @param jobLevelCap integer|nil
--- @return boolean whether class/role quests own this pulse
local function doJobStuff(job, jobLevelCap)
    local myJob = CONFIG.jobMapping[Player.job] or Player.job
    if job ~= nil and job ~= myJob and job ~= Player.job then
        log("[ERROR] Current-job questing does not switch to another job")
        wait(5000)
        return true
    end
    local profile = classProfile()
    -- Reset the captured tank-duty latch when re-entering its solo instance.
    if gCurrQuestID == 3247 and Player.localmapid == 816 then
        profile.NeedsBlock = false
    end
    local available, questOrError = profile.HasWork(jobLevelCap)
    if available == nil then
        log("[WARNING] Class quest availability unknown: " .. tostring(questOrError))
        ensureProfileEnabled("none")
        wait(1000)
        return true
    end
    if available then
        ensureProfileEnabled("job", myJob)
        return true
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
--- @field job integer|nil FFXIV.JOBS job to level; defaults to the current job.
--- @field jobLevelCap integer|nil

--- @param params MsqCycleParams|nil
--- @return boolean whether common msq cycle is still ongoing
function MsqBootstrap.CommonMsqCycle(params)
    if holdLattyDungeonHandoff() then
        return true
    end
    params = params or {}

    if Player.localmapid == 0 then
        resetLattyRestartDebounce()
        return true
    end
    if Busy() then
        resetLattyRestartDebounce()
    end

    -- Quest steps can advance before we leave the duty. Keep driving the helper
    -- until it has released KDF and cleaned up the party, even without a match.
    if MsqClearHelper.Role == "farmer" and (MsqClearHelper.CurrentDungeonId ~= nil
        or MsqClearHelper.NeededDungeon ~= nil or MsqClearHelper.InDungeon
        or MsqClearHelper.NeedToDisband) then
        MsqClearHelper.Update()
        return true
    end

    if openJobChests() then
        return true
    end

    local neededDungeon = MsqClearHelper.DetectNeededDungeon()
    if neededDungeon ~= nil then
        resetLattyRestartDebounce()
        local useDutyFinderWithoutHelpers = NoobgamConfigManager.Config.doNotUseHelpers == true
            and NoobgamConfigManager.Config.useDutyFinder == true
        if (neededDungeon == 92 or neededDungeon == 102 or neededDungeon == 111)
            and not useDutyFinderWithoutHelpers then
            log("[WARNING] we're on a quest step with unskippable trial. Can't do anything")
            wait(15000)
            return true
        end
        MsqClearHelper.Role = "farmer"
        MsqClearHelper.Update()
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

    ensureProfileEnabled("msq")
    return true
end

function MsqBootstrap.Update()
    if holdLattyDungeonHandoff() then
        return
    end
    if Player.localmapid == 0 or Busy() then
        resetLattyRestartDebounce()
    end
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
    MsqBootstrap.LattyWasRunning = nil
    resetLattyRestartDebounce()
    MsqBootstrap.LastLattyHandoffStage = nil
    MsqBootstrap.LastLattyHandoffLogAt = nil
    MsqBootstrap.WaitUntil = nil
    MsqBootstrap.WaitCondition = nil
    MsqBootstrap.BreakOutDelayMillis = nil
    MsqBootstrap.LastProfile = nil
    MsqBootstrap.LastLattyStartAttempt = nil
    MsqBootstrap.LastLattyKDFSuppressionLog = nil
    NoobgamCircuitBreaker.Reset()
    log("Reset complete")
end

function MsqBootstrap.EnsureProfileEnabled(profile, job)
    return ensureProfileEnabled(profile, job)
end

MsqBootstrap.CONFIG = CONFIG

return MsqBootstrap