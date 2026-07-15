if MsqClearHelper == nil then
    MsqClearHelper = {}
    MsqClearHelper.Role = nil -- "host" or "farmer"
    MsqClearHelper.CurrentDungeonId = nil
    MsqClearHelper.CurrentFarmer = nil
    MsqClearHelper.WaitUntil = nil
    MsqClearHelper.WaitCondition = nil
    MsqClearHelper.BreakOutDelayMillis = nil
    MsqClearHelper.InDungeon = false
    MsqClearHelper.NeedToDisband = false
    MsqClearHelper.LastBroadcast = 0
    MsqClearHelper.HostState = nil -- nil | "creating_pf" | "pf_ready"
    MsqClearHelper.PfReadyAt = nil
    MsqClearHelper.JoinPfScheduled = false
end

local PF_PASSWORD = 1731
local PF_WAIT_TIMEOUT_MS = 90000

local function log(msg)
    d("[MsqClearHelper] " .. msg)
end

local logThrottleState = {}
--- Log a message at most once per intervalMs for a given key.
--- Returns true when the message was actually emitted (useful to gate
--- expensive follow-up dumps behind the same throttle window).
--- @param key string
--- @param intervalMs integer
--- @param msg string
--- @return boolean emitted
local function logThrottled(key, intervalMs, msg)
    local now = Now()
    if logThrottleState[key] == nil or now - logThrottleState[key] >= intervalMs then
        logThrottleState[key] = now
        log(msg)
        return true
    end
    return false
end

-- Quest step to dungeon mapping
--- @type table<number, table<number, number>>
local questStepIdToDungeonId = {
    [1190] = { [7] = 66 },  -- thornmarch (hard)
    [1361] = { [1] = 72 },  -- whorleater (hard)
    [3885] = { [5] = 77 },  -- Ramuh
    [84] = { [4] = 79 },    -- shiva
    [369] = { [3] = 84 },   -- chrysalis
    -- 24 main raids not supported in public addon.
    -- if you know how to create an alliance without a PushButton - I can implement this and make public
    -- they are included here, but ignored in the farmer handle flow
    [1202] = { [2] = 92 },  -- lota
    [1474] = { [4] = 102 }, -- cyrcus
    [494] = { [3] = 111 },  -- woda
    [1616] = { [3] = 86 },
    [1647] = { [4] = 88 },
    [1669] = { [5] = 90 },
    [2245] = { [2] = 169 },
    [2345] = { [8] = 60 },
    [2489] = { [2] = 243 },
    [2532] = { [5] = 263 }, -- emanation
    [2553] = { [3] = 239 }, -- the royal menagerie
    [3074] = { [3] = 537 }, -- castrum fluminis
    [3320] = { [2] = 657 }, -- titania (the dancing plague)
    [3643] = { [5] = 666 }, -- innocence (the crown of the immaculate)
    [3654] = { [9] = 687 }, -- hades (the dying gasp)
    [3778] = { [2] = 738 }, --- WoL (the seat of sacrifice)
    [4398] = { [2] = 802 }, --- zodiark (the dark inside)
    [4464] = { [3] = 796 }, --- endsinger (the Final day)
    [4597] = { [3] = 870 }, --- barbariccia (Storm's Crown)
    [4677] = { [4] = 886 }, --- rubicante (Mount ordeals)
    [4742] = { [2] = 949 }, --- golbez (voidcast dais)
    [4748] = { [5] = 964 }, --- zeromus (abyssal fracture)
    [4959] = { [4] = 984 }, --- the interphos
}
MsqClearHelper.QuestStepIdToDungeonId = questStepIdToDungeonId

local dungeonsToClearInDutyFinder = {
    [738] = true,
    [796] = true,
    [984] = true,
}

local primalDungeons = { 59, 60, 61 }

--- @param millis integer
--- @param breakOutCondition (fun(): boolean)|nil
--- @param breakOutDelayMillis number|nil
local function wait(millis, breakOutCondition, breakOutDelayMillis)
    local suggested = Now() + millis

    if breakOutCondition then
        if MsqClearHelper.WaitCondition == nil or MsqClearHelper.WaitUntil < suggested then
            MsqClearHelper.WaitCondition = breakOutCondition
            MsqClearHelper.WaitUntil = suggested
            MsqClearHelper.BreakOutDelayMillis = breakOutDelayMillis
        end
    else
        if MsqClearHelper.WaitUntil == nil or MsqClearHelper.WaitUntil < suggested then
            MsqClearHelper.WaitCondition = nil
            MsqClearHelper.WaitUntil = suggested
        end
    end
end

--- Shared state file for communication between host and farmers
local sharedStateFolder = GetLuaModsPath() .. "SimpleFFXIVBotting\\shared\\"
local sharedStatePath = sharedStateFolder .. "msq_clear_requests.json"
local pfReadyPath = sharedStateFolder .. "msq_pf_ready.json"

---@class ClearRequest
---@field farmerName string
---@field dungeonId number

---@class SharedClearState
---@field requests ClearRequest[]

---@class PfReadyEntry
---@field recruiterName string
---@field farmerName string
---@field dungeonId number
---@field password integer

---@class PfReadyState
---@field entries PfReadyEntry[]

local function loadSharedState()
    if not FolderExists(sharedStateFolder) then
        FolderCreate(sharedStateFolder)
    end

    if not FileExists(sharedStatePath) then
        FileWrite(sharedStatePath, json.encode({ requests = {} }, { indent = 2 }))
        return { requests = {} }
    end

    local content = NoobgamUtils.ReadFile(sharedStatePath)
    if not content or content == "" then
        return { requests = {} }
    end

    return json.decode(content)
end

local function saveSharedState(state)
    if not FolderExists(sharedStateFolder) then
        FolderCreate(sharedStateFolder)
    end
    FileWrite(sharedStatePath, json.encode(state, { indent = 2 }))
end

local function loadPfReadyState()
    if not FolderExists(sharedStateFolder) then
        FolderCreate(sharedStateFolder)
    end

    if not FileExists(pfReadyPath) then
        return { entries = {} }
    end

    local content = NoobgamUtils.ReadFile(pfReadyPath)
    if not content or content == "" then
        return { entries = {} }
    end

    local decoded = json.decode(content)
    if not decoded or not decoded.entries then
        return { entries = {} }
    end
    return decoded
end

local function savePfReadyState(state)
    if not FolderExists(sharedStateFolder) then
        FolderCreate(sharedStateFolder)
    end
    FileWrite(pfReadyPath, json.encode(state, { indent = 2 }))
end

--- Dump the raw contents of the shared coordination files for debugging.
--- Intended to be called behind a throttle so it does not flood the log.
--- @param reason string tag describing why the dump was requested
local function dumpSharedFiles(reason)
    local reqContent = FileExists(sharedStatePath) and NoobgamUtils.ReadFile(sharedStatePath) or "<missing>"
    local pfContent = FileExists(pfReadyPath) and NoobgamUtils.ReadFile(pfReadyPath) or "<missing>"
    log(string.format("[SharedFiles:%s] %s -> %s", tostring(reason), sharedStatePath, tostring(reqContent)))
    log(string.format("[SharedFiles:%s] %s -> %s", tostring(reason), pfReadyPath, tostring(pfContent)))
end

--- Human-readable snapshot of the current party (regular + crossworld).
--- Used to diagnose farmer-detection failures (e.g. crossworld name
--- mismatch between what the farmer registers and what the host sees).
--- @return string
local function describeParty()
    local parts = {}
    if table.valid(EntityList.myparty) then
        for _, m in pairs(EntityList.myparty) do
            table.insert(parts, string.format("myparty[name=%s leader=%s]", tostring(m.name), tostring(m.isleader)))
        end
    end
    if table.valid(EntityList.crossworldparty) then
        for _, m in pairs(EntityList.crossworldparty) do
            table.insert(parts, string.format("xworld[name=%s world=%s leader=%s online=%s]",
                tostring(m.name), tostring(m.world), tostring(m.isleader), tostring(m.isonline)))
        end
    end
    if #parts == 0 then
        return "<empty>"
    end
    return table.concat(parts, ", ")
end

--- Emit a single, self-contained JSON snapshot of everything relevant to the
--- PF handoff loop (host state, party members, name-match check, shared files,
--- controls, duty). Designed to be pasted straight into a bug report. Call it
--- at failure points (e.g. PF wait timeout) so the log captures the state.
--- @param reason string tag describing why the dump was requested
function MsqClearHelper.DumpDebugState(reason)
    local function collectParty(list)
        local t = {}
        if table.valid(list) then
            for _, m in pairs(list) do
                table.insert(t, {
                    name = m.name,
                    world = m.world,
                    leader = m.isleader,
                    online = m.isonline,
                    id = m.id,
                })
            end
        end
        return t
    end

    -- Recompute the farmer name-match here (rather than calling isPartyReady,
    -- which is declared later in the file and thus not in lexical scope) so the
    -- report is self-contained and shows exactly which names matched.
    local farmer = MsqClearHelper.CurrentFarmer
    local farmerMatches = {}
    if farmer then
        if table.valid(EntityList.myparty) then
            for _, m in pairs(EntityList.myparty) do
                if m.name == farmer then table.insert(farmerMatches, "myparty:" .. tostring(m.name)) end
            end
        end
        if table.valid(EntityList.crossworldparty) then
            for _, m in pairs(EntityList.crossworldparty) do
                if m.name == farmer then table.insert(farmerMatches, "xworld:" .. tostring(m.name)) end
            end
        end
    end
    local farmerMatch = (not farmer) and "no CurrentFarmer"
        or (#farmerMatches > 0 and farmerMatches or ("NO MATCH for '" .. farmer .. "'"))
    local partyReady = farmer ~= nil and #farmerMatches > 0

    local function readShared(path)
        return FileExists(path) and NoobgamUtils.ReadFile(path) or "<missing>"
    end

    local ok, dump = pcall(json.encode, {
        reason = tostring(reason),
        now = Now(),
        playerName = Player.name,
        playerWorld = Player.world,
        localmapid = Player.localmapid,
        config = {
            mode = NoobgamConfigManager and NoobgamConfigManager.Config and NoobgamConfigManager.Config.mode or nil,
            useDutyFinder = NoobgamConfigManager and NoobgamConfigManager.Config and NoobgamConfigManager.Config.useDutyFinder or nil,
        },
        msq = {
            Role = MsqClearHelper.Role,
            CurrentFarmer = MsqClearHelper.CurrentFarmer,
            CurrentDungeonId = MsqClearHelper.CurrentDungeonId,
            HostState = MsqClearHelper.HostState,
            PfReadyAt = MsqClearHelper.PfReadyAt,
            pfReadyElapsedMs = MsqClearHelper.PfReadyAt and (Now() - MsqClearHelper.PfReadyAt) or nil,
            pfWaitTimeoutMs = PF_WAIT_TIMEOUT_MS,
            NeedToDisband = MsqClearHelper.NeedToDisband,
            DisbandScheduled = MsqClearHelper.DisbandScheduled,
            PfStopped = MsqClearHelper.PfStopped,
            JoinPfScheduled = MsqClearHelper.JoinPfScheduled,
            InDungeon = MsqClearHelper.InDungeon,
            LastBroadcast = MsqClearHelper.LastBroadcast,
            SettingsValid = MsqClearHelper.SettingsValid,
            WaitUntil = MsqClearHelper.WaitUntil,
            waitRemainingMs = MsqClearHelper.WaitUntil and (MsqClearHelper.WaitUntil - Now()) or nil,
            hasWaitCondition = MsqClearHelper.WaitCondition ~= nil,
            keyPressQueueLen = MsqClearHelper.KeyPressQueue and #MsqClearHelper.KeyPressQueue or 0,
            partyReady = partyReady,
        },
        myparty = collectParty(EntityList.myparty),
        crossworldparty = collectParty(EntityList.crossworldparty),
        farmerMatch = farmerMatch,
        duty = {
            activeDuty = table.valid(Duty:GetActiveDutyInfo()) and Duty:GetActiveDutyInfo() or nil,
            queueStatus = Duty:GetQueueStatus(),
        },
        controls = {
            ContentsFinder = IsControlOpen("ContentsFinder"),
            ContentsFinderSetting = IsControlOpen("ContentsFinderSetting"),
            ContentsFinderConfirm = IsControlOpen("ContentsFinderConfirm"),
            ContentsFinderMenu = IsControlOpen("ContentsFinderMenu"),
            LookingForGroup = IsControlOpen("LookingForGroup"),
            LookingForGroupDetail = IsControlOpen("LookingForGroupDetail"),
            SelectYesno = IsControlOpen("SelectYesno"),
        },
        sharedFiles = {
            requests = readShared(sharedStatePath),
            pfReady = readShared(pfReadyPath),
        },
        detectedNeededDungeon = MsqClearHelper.DetectNeededDungeon(),
        taskManager = {
            currentTaskType = NoobgamTaskManager.Task and NoobgamTaskManager.Task.type or nil,
            queueLen = NoobgamTaskManager.TaskQueue and #NoobgamTaskManager.TaskQueue or nil,
        },
    }, { indent = 2 })

    if ok then
        log("[DebugState:" .. tostring(reason) .. "] " .. tostring(dump))
    else
        log("[DebugState:" .. tostring(reason) .. "] failed to encode: " .. tostring(dump))
    end
end

--- Host announces a ready PF for a specific farmer
--- @param farmerName string
--- @param dungeonId number
--- @param password integer
function MsqClearHelper.PublishPfReady(farmerName, dungeonId, password)
    log("Publishing PF ready for " .. farmerName .. " dungeon " .. tostring(dungeonId))
    local state = loadPfReadyState()
    local entries = {}
    for _, e in ipairs(state.entries or {}) do
        if e.farmerName ~= farmerName then
            table.insert(entries, e)
        end
    end
    table.insert(entries, {
        recruiterName = Player.name,
        farmerName = farmerName,
        dungeonId = dungeonId,
        password = password,
    })
    savePfReadyState({ entries = entries })
    dumpSharedFiles("PublishPfReady")
end

--- Remove a published PF ready entry (by farmer name)
--- @param farmerName string
function MsqClearHelper.UnpublishPfReady(farmerName)
    log("Unpublishing PF ready for " .. tostring(farmerName))
    local state = loadPfReadyState()
    local entries = {}
    for _, e in ipairs(state.entries or {}) do
        if e.farmerName ~= farmerName then
            table.insert(entries, e)
        end
    end
    savePfReadyState({ entries = entries })
end

--- Find the PF ready entry for the current farmer (by player name)
--- @return PfReadyEntry|nil
function MsqClearHelper.GetPfReadyForMe()
    local state = loadPfReadyState()
    for _, e in ipairs(state.entries or {}) do
        if e.farmerName == Player.name then
            return e
        end
    end
    return nil
end

--- Register that a dungeon needs to be cleared (farmer calls this)
--- @param dungeonId number
function MsqClearHelper.RegisterForClear(dungeonId)
    log("Registering for clear: " .. dungeonId)

    local state = loadSharedState()

    -- Remove any existing request from this farmer
    local newRequests = {}
    for _, req in ipairs(state.requests) do
        if req.farmerName ~= Player.name then
            table.insert(newRequests, req)
        end
    end

    -- Add new request
    table.insert(newRequests, {
        farmerName = Player.name,
        dungeonId = dungeonId
    })

    state.requests = newRequests
    saveSharedState(state)
end

--- Remove registration (farmer calls this when done or host calls it for farmer)
function MsqClearHelper.UnregisterClear(regname)
    local name = regname or Player.name
    log("Unregistering clear for: " .. name)

    local state = loadSharedState()

    local newRequests = {}
    for _, req in ipairs(state.requests) do
        if req.farmerName ~= name then
            table.insert(newRequests, req)
        end
    end

    state.requests = newRequests
    saveSharedState(state)
end

--- Get pending requests (host calls this)
--- @return ClearRequest[]
function MsqClearHelper.GetPendingRequests()
    local state = loadSharedState()
    return state.requests or {}
end

--- Check what dungeon is currently needed based on quest progress
--- @return number|nil dungeonId
function MsqClearHelper.DetectNeededDungeon()
    for questId, steps in pairs(questStepIdToDungeonId) do
        local completed = Quest:IsQuestCompleted(questId, false)
        if not completed then
            local currentStepId = Quest:GetQuestCurrentStep(questId, false)
            if steps[currentStepId] ~= nil then
                local dungeonId = steps[currentStepId]
                return dungeonId
            end
        end
    end

    -- Check for primal dungeons
    if QuestCompleted(89) and not QuestCompleted(363) then
        local allDuties = Duty:GetCompleteDutyList()

        for _, did in pairs(primalDungeons) do
            for _, d in pairs(allDuties) do
                if d.id == did and d.type == 2 and not d.completed and d.canjoin then
                    return did
                end
            end
        end
    end

    return nil
end

local function ensureUnderSizedParty()
    if MsqClearHelper.SettingsValid then
        return true
    end

    if IsControlOpen("ContentsFinderSetting") then
        local data = GetControlData("ContentsFinderSetting", "UnderSizedParty")
        if tostring(data) ~= "true" then
            UseControlAction("ContentsFinderSetting", "UnderSizedParty", 1)
            wait(500)
            return false
        end
        UseControlAction("ContentsFinderSetting", "Confirm")
        wait(500)
        MsqClearHelper.SettingsValid = true
        return false
    end

    if not IsControlOpen("ContentsFinder") then
        ActionList:Get(10, 33):Cast()
        wait(500)
        return false
    end

    UseControlAction("ContentsFinder", "Settings")
    wait(500)
    return false
end

local function pressKeys(actions, wait_override)
    if MsqClearHelper.KeyPressQueue == nil then
        MsqClearHelper.KeyPressQueue = {}
    end
    for i = 1, #actions do
        local action = actions[i]
        if type(action) == "function" then
            table.insert(MsqClearHelper.KeyPressQueue, { callback = action, wait = wait_override or 300 })
        end
    end
end

local function processKeyPress()
    if MsqClearHelper.KeyPressQueue == nil then return false end
    if #MsqClearHelper.KeyPressQueue > 0 then
        local top = MsqClearHelper.KeyPressQueue[1]
        local wait_millis = top.wait
        if top.callback then
            top.callback()
        end
        table.remove(MsqClearHelper.KeyPressQueue, 1)
        wait(wait_millis or 500)
        return true
    end
    return false
end

local function stopPF()
    log("Stopping PF before entering duty")
    pressKeys({
        function() ActionList:Get(10, 57):Cast() end,
        function()
            if IsControlOpen("LookingForGroup") then
                GetControlByName("LookingForGroup"):PushButton(25, 2)
            else
                log("[WARNING] Failed to stop pf - LookingForGroup not open")
            end
        end,
        function()
            if IsControlOpen("LookingForGroupDetail") then
                GetControlByName("LookingForGroupDetail"):PushButton(25, 2)
                log("Stopped pf successfully")
            else
                log("[WARNING] Failed to stop pf - LookingForGroupDetail not open")
            end
        end,
    }, 500)
end

function MsqClearHelper.Reset()
    log("Resetting msq")
    local farmer = MsqClearHelper.CurrentFarmer
    MsqClearHelper.CurrentDungeonId = nil
    MsqClearHelper.CurrentFarmer = nil
    MsqClearHelper.NeedToDisband = false
    MsqClearHelper.LastBroadcast = 0
    MsqClearHelper.HostState = nil
    MsqClearHelper.PfReadyAt = nil
    MsqClearHelper.JoinPfScheduled = false
    if MsqClearHelper.Role == "host" then
        FileDelete(sharedStatePath)
        if farmer then
            MsqClearHelper.UnpublishPfReady(farmer)
        end
    end
end

--- Check whether anyone has joined the party (regular or crossworld).
---
--- We deliberately do NOT match on the farmer's name. Cross-world party member
--- names frequently come back blank/unresolved for a while after a PF join
--- (observed: the farmer shows up as `xworld[name= world=22 leader=false
--- online=true]`), so name-matching deadlocks the host until the PF-wait
--- timeout even though the farmer is sitting right there. Since the host
--- advertises a *private, password-protected* PF, the only person who can join
--- is the invited farmer, so the mere presence of a second party member is
--- sufficient to proceed.
local function isPartyReady()
    if not MsqClearHelper.CurrentFarmer then
        return false
    end

    local count = 0
    if table.valid(EntityList.myparty) then
        for _ in pairs(EntityList.myparty) do count = count + 1 end
    end
    if table.valid(EntityList.crossworldparty) then
        for _ in pairs(EntityList.crossworldparty) do count = count + 1 end
    end

    return count > 1
end


local function updateHost()
    if MsqClearHelper.NeedToDisband then
        log("Scheduling disband")
        NoobgamTaskManager.Schedule({
            type = "disbandParty",
            params = {},
            onEnd = function()
                log("Party disband task ended, resetting")
                MsqClearHelper.DisbandScheduled = false
                MsqClearHelper.Reset()
            end
        })
        wait(2000)
        return true
    end

    if IsControlOpen("ContentsFinderConfirm") then
        log("Confirming dungeon entry")
        UseControlAction("ContentsFinderConfirm", "Confirm")
        wait(2000)
        return true
    end

    if MsqClearHelper.CurrentDungeonId and isPartyReady() then
        if not ensureUnderSizedParty() then
            return true
        end

        -- Stop the PF first before entering dungeon
        if not MsqClearHelper.PfStopped then
            log("Party ready, stopping PF before entering dungeon")
            MsqClearHelper.UnpublishPfReady(MsqClearHelper.CurrentFarmer)
            stopPF()
            MsqClearHelper.PfStopped = true
            wait(2000)
            return true
        end

        log("Party ready, entering dungeon: " .. MsqClearHelper.CurrentDungeonId)
        Duty:JoinDuty(2, MsqClearHelper.CurrentDungeonId)
        wait(2000)
        return true
    end

    -- If we don't have a current farmer, check for pending requests
    if not MsqClearHelper.CurrentFarmer then
        local requests = MsqClearHelper.GetPendingRequests()

        if #requests > 0 then
            local names = {}
            for _, r in ipairs(requests) do
                table.insert(names, string.format("%s->%s", tostring(r.farmerName), tostring(r.dungeonId)))
            end
            log(string.format("Pending clear requests (%d): %s", #requests, table.concat(names, ", ")))
            local req = requests[1]
            log("Selecting request from " .. req.farmerName .. " for dungeon " .. req.dungeonId)
            MsqClearHelper.CurrentDungeonId = req.dungeonId
            MsqClearHelper.CurrentFarmer = req.farmerName
            MsqClearHelper.HostState = nil
            MsqClearHelper.PfReadyAt = nil
        end
    end

    if not MsqClearHelper.CurrentFarmer then
        if logThrottled("host_idle", 15000, "Idle: no farmer assigned and no pending requests.") then
            dumpSharedFiles("host_idle")
        end
        return false
    end

    -- We have a farmer but they're not in party — drive a PF
    if MsqClearHelper.HostState == nil then
        log("Scheduling createPF for farmer: " .. MsqClearHelper.CurrentFarmer)
        local farmer = MsqClearHelper.CurrentFarmer
        local dungeonId = MsqClearHelper.CurrentDungeonId
        MsqClearHelper.HostState = "creating_pf"
        NoobgamTaskManager.Schedule({
            type = "createPF",
            params = { mode = 1, password = PF_PASSWORD },
            onEnd = function()
                if MsqClearHelper.CurrentFarmer ~= farmer then
                    log("Farmer changed during createPF, dropping result")
                    return
                end
                MsqClearHelper.PfStopped = false
                MsqClearHelper.PublishPfReady(farmer, dungeonId, PF_PASSWORD)
                MsqClearHelper.HostState = "pf_ready"
                MsqClearHelper.PfReadyAt = Now()
            end,
        })
        wait(2000)
        return true
    end

    if MsqClearHelper.HostState == "creating_pf" then
        wait(2000)
        return true
    end

    if MsqClearHelper.HostState == "pf_ready" then
        local elapsed = MsqClearHelper.PfReadyAt and (Now() - MsqClearHelper.PfReadyAt) or 0
        log(string.format(
            "Waiting for farmer '%s' (dungeon %s) to join PF. elapsed=%.0fs/%ds partyReady=%s party=[%s]",
            tostring(MsqClearHelper.CurrentFarmer),
            tostring(MsqClearHelper.CurrentDungeonId),
            elapsed / 1000,
            PF_WAIT_TIMEOUT_MS / 1000,
            tostring(isPartyReady()),
            describeParty()))
        if logThrottled("pf_ready_files", 10000, "Dumping shared coordination files while waiting for farmer:") then
            dumpSharedFiles("pf_ready")
        end
        if MsqClearHelper.PfReadyAt and Now() - MsqClearHelper.PfReadyAt > PF_WAIT_TIMEOUT_MS then
            log("PF wait timed out, disbanding. Final party snapshot: [" .. describeParty() .. "]")
            MsqClearHelper.DumpDebugState("pf_wait_timeout")
            MsqClearHelper.UnpublishPfReady(MsqClearHelper.CurrentFarmer)
            MsqClearHelper.NeedToDisband = true
            return true
        end
        wait(2000)
        return true
    end

    return false
end

local function updateFarmer()
    gStuckRemesh = false

    if IsControlOpen("ContentsFinderConfirm") then
        log("Confirming dungeon entry")
        UseControlAction("ContentsFinderConfirm", "Confirm")
        wait(2000)
        return true
    end

    if MsqClearHelper.CurrentDungeonId and (table.valid(EntityList.myparty) or table.valid(EntityList.crossworldparty)) then
        log("In party, waiting for dungeon entry")
        wait(2000)
        return true
    end

    local neededDungeon = MsqClearHelper.DetectNeededDungeon()
    MsqClearHelper.NeededDungeon = neededDungeon
    if neededDungeon == 92 or neededDungeon == 102 or neededDungeon == 111 then
        return false
    end
    if neededDungeon then
        if FFXIV_Common_BotRunning then
            log("Disabling bot, need to clear dungeon")
            ffxivminion.DutyCurrentData = {}
            ml_global_information.ToggleRun()
            wait(5000)
            return
        end
        NoobgamPrivateAPI.SetKDFToNone()
        if NoobgamConfigManager.Config.useDutyFinder and dungeonsToClearInDutyFinder[neededDungeon] then
            if Duty:GetQueueStatus() == 0 then
                log("Registering for duty " .. tostring(neededDungeon))
                Duty:JoinDuty(2, neededDungeon)
                wait(5000)
                return
            end
            wait(5000)
            log("Waiting for queue to pop")
            return true
        end
        if MsqClearHelper.CurrentDungeonId ~= neededDungeon then
            MsqClearHelper.CurrentDungeonId = neededDungeon
            MsqClearHelper.RegisterForClear(neededDungeon)
            MsqClearHelper.JoinPfScheduled = false
            return true
        end

        -- Check for a host-published PF and join it
        local pfReady = MsqClearHelper.GetPfReadyForMe()
        if pfReady and pfReady.dungeonId == neededDungeon and not MsqClearHelper.JoinPfScheduled then
            log("PF ready from " .. pfReady.recruiterName .. ", scheduling joinPF")
            MsqClearHelper.JoinPfScheduled = true
            local recruiter = pfReady.recruiterName
            NoobgamTaskManager.Schedule({
                type = "joinPF",
                params = {
                    recruiterName = recruiter,
                    password = pfReady.password,
                    onFailure = function()
                        log("joinPF failed for " .. recruiter .. ", will retry")
                        MsqClearHelper.JoinPfScheduled = false
                    end,
                },
            })
            wait(2000)
            return true
        end

        -- Periodically refresh registration (every 5 seconds)
        if Now() - MsqClearHelper.LastBroadcast > 5000 then
            log("Refreshing registration for dungeon: " .. neededDungeon)
            MsqClearHelper.RegisterForClear(neededDungeon)
            MsqClearHelper.LastBroadcast = Now()
        end
    end

    return false
end

local function leaveDuty()
    local info = Duty:GetActiveDutyInfo()
    local in_dungeon = table.valid(info)
    MsqClearHelper.NeedToDisband = true

    if KitanoiFuncs.AreKitanoiAddonsRunning("KDF") then
        log("Disabling kit cause leaving duty")
        KitanoiFuncs.EnableAddon("kdf", false)
    end

    if not in_dungeon then
        log("Needtodisband true because leaving dungeon")
        return true
    end
    if not IsControlOpen("ContentsFinderMenu") then
        log("Opening ContentsFinderMenu")
        ActionList:Get(10, 33):Cast()
        wait(2000)
        return
    else
        if not IsControlOpen("SelectYesno") then
            log("Leaving via ContentsFinderMenu")
            UseControlAction("ContentsFinderMenu", "Leave")
            MsqClearHelper.Reset()
            wait(2000)
            return
        else
            log("Setting needToDisband to true while leaving")
            UseControlAction("SelectYesno", "Yes")
            wait(2000)
            return
        end
    end
    return
end

local function fight()
    local playerTarget = Player:GetTarget()
    if playerTarget ~= nil and NoobgamUtils.hasBuff(playerTarget, 775) then
        Player:ClearTarget()
        playerTarget = nil
    end
    if playerTarget == nil then
        log("Finding new target to attack")
        local target = nil
        local entities = EntityList("alive,aggressive,attackable")
        for _, enemy in pairs(entities) do
            -- invincibility
            if not NoobgamUtils.hasBuff(enemy, 775) then
                target = enemy
                break
            end
        end
        if target == nil then
            log("Didn't find aggressive targets. Will lookup non-aggressive")
            local entities = EntityList("alive,attackable")
            for _, enemy in pairs(entities) do
                -- invincibility
                if not NoobgamUtils.hasBuff(enemy, 775) then
                    target = enemy
                    break
                end
            end
        end

        if target == nil then
            return false
        end
        Player:SetTarget(target.id)
        -- our vision is further than setTarget allows.
        Player:MoveTo(
            target.pos.x,
            target.pos.y,
            target.pos.z,
            1
        )
        wait(500)
    end
    return false
end

function MsqClearHelper.HostUpdate()
    MsqClearHelper.Role = "host"
    MsqClearHelper.Update()
end

function MsqClearHelper.Update()
    if MsqClearHelper.WaitUntil and MsqClearHelper.WaitUntil > Now() then
        if MsqClearHelper.WaitCondition and MsqClearHelper.WaitCondition() then
            log("Breaking out of wait")
            MsqClearHelper.WaitUntil = Now() + (MsqClearHelper.BreakOutDelayMillis or 0)
            MsqClearHelper.BreakOutDelayMillis = nil
            MsqClearHelper.WaitCondition = nil
        end
        return true
    end
    
    -- Process queued PF stop key presses
    if processKeyPress() then
        return true
    end

    local exit = NoobgamUtils.PickClosestExit()
    if exit ~= nil and exit.targetable then
        log("Exit is visible")
        return leaveDuty()
    end

    local inDungeon = table.valid(Duty:GetActiveDutyInfo())
    if Player.localmapid == 0 then
        wait(1000)
        return
    end
    if inDungeon then
        -- use KDF profiles here?
        MsqClearHelper.InDungeon = true
        if MsqClearHelper.FightStarted == nil then
            MsqClearHelper.FightStarted = GetTickCount()
        end
        local kdfProfile = NoobgamKdfProfiles.DungeonProfiles[Player.localmapid]
        if kdfProfile ~= nil then
            KitanoiFuncs.LoadDungeonTbl(kdfProfile)
            if not KitanoiFuncs.AreKitanoiAddonsRunning("KDF") then
                log("Enabling KDF")
                KitanoiFuncs.EnableAddon("kdf", true)
                wait(1000)
            end
            return
        end
        if gBotMode ~= "Assist" then
            NoobgamUtils.SwitchMode("Assist")
            wait(1000)
            return
        end
        if not FFXIV_Common_BotRunning then
            log("Enabling bot")
            ffxivminion.DutyCurrentData = {}
            ml_global_information.ToggleRun()
            wait(5000)
            return
        end
        fight()
        return false
    else
        Player:Stop()
        Player:SetAutoFollowOn(false)
        NoobgamPrivateAPI.SetKDFToNone()
        if KitanoiFuncs.AreKitanoiAddonsRunning("KDF") then
            log("Disabling KDF, not in dungeon")
            KitanoiFuncs.EnableAddon("kdf", false)
        end
        if MsqClearHelper.InDungeon then
            log("Left dungeon, marking for disband")
            MsqClearHelper.InDungeon = false
            MsqClearHelper.FightStarted = nil
            MsqClearHelper.NeedToDisband = true
            MsqClearHelper.UnregisterClear()
            if MsqClearHelper.Role == "host" and MsqClearHelper.CurrentFarmer then
                MsqClearHelper.UnpublishPfReady(MsqClearHelper.CurrentFarmer)
            end
            MsqClearHelper.CurrentDungeonId = nil
            MsqClearHelper.HostState = nil
            MsqClearHelper.PfReadyAt = nil
            MsqClearHelper.JoinPfScheduled = false
            MsqClearHelper.BlueEngaged = nil
            MsqClearHelper.BlueWaitUntil = nil
        end
    end

    if MsqClearHelper.Role == "host" then
        return updateHost()
    elseif MsqClearHelper.Role == "farmer" then
        return updateFarmer()
    end

    return false
end

return MsqClearHelper
