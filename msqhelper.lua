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
end

local function log(msg)
    d("[MsqClearHelper] " .. msg)
end

-- Quest step to dungeon mapping
local questStepIdToDungeonId = {
    [1190] = { [7] = 66 },  -- thornmarch (hard)
    [1361] = { [1] = 72 },  -- whorleater (hard)
    [3885] = { [5] = 77 },  -- Ramuh
    [84] = { [4] = 79 },    -- shiva
    [369] = { [3] = 84 },   -- chrysalis
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
    [2553] = { [3] = 239 }  -- the royal menagerie
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

---@class ClearRequest
---@field farmerName string
---@field dungeonId number

---@class SharedClearState
---@field requests ClearRequest[]

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

--- Remove registration (farmer calls this when done)
function MsqClearHelper.UnregisterClear()
    log("Unregistering clear for: " .. Player.name)

    local state = loadSharedState()

    local newRequests = {}
    for _, req in ipairs(state.requests) do
        if req.farmerName ~= Player.name then
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

--- Initialize as host
function MsqClearHelper.InitAsHost()
    log("Initializing as host")
    MsqClearHelper.Role = "host"
    MsqClearHelper.CurrentDungeonId = nil
    MsqClearHelper.CurrentFarmer = nil
    MsqClearHelper.NeedToDisband = false
end

--- Initialize as farmer
function MsqClearHelper.InitAsFarmer()
    log("Initializing as farmer")
    MsqClearHelper.Role = "farmer"
    MsqClearHelper.CurrentDungeonId = nil
    MsqClearHelper.LastBroadcast = 0
end

--- Check if farmer is in party
local function isFarmerInParty()
    if not MsqClearHelper.CurrentFarmer then
        return false
    end

    if table.valid(EntityList.myparty) then
        for _, member in pairs(EntityList.myparty) do
            if member.name == MsqClearHelper.CurrentFarmer then
                return true
            end
        end
    end

    return false
end

local function handleInvites()
    if not IsControlOpen("SelectYesno") then
        return
    end

    local inviter = NoobgamUtils.ExtractInviterName()
    if not inviter then
        UseControlAction("SelectYesno", "No")
    else
        UseControlAction("SelectYesno", "Yes")
    end
    wait(500)
end

local function updateHost()
    if MsqClearHelper.NeedToDisband then
        if not table.valid(EntityList.myparty) then
            log("Party disbanded, resetting")
            MsqClearHelper.NeedToDisband = false
            MsqClearHelper.CurrentDungeonId = nil
            MsqClearHelper.CurrentFarmer = nil
            return true
        end

        log("Disbanding party")
        SendTextCommand("/pcmd breakup")
        wait(2000)
        return true
    end

    if MsqClearHelper.CurrentDungeonId and isFarmerInParty() then
        log("Party ready, entering dungeon: " .. MsqClearHelper.CurrentDungeonId)
        Duty:JoinDuty(2, MsqClearHelper.CurrentDungeonId)
        wait(2000)
        return true
    end

    -- If we don't have a current farmer, check for pending requests
    if not MsqClearHelper.CurrentFarmer then
        local requests = MsqClearHelper.GetPendingRequests()

        if #requests > 0 then
            local req = requests[1]
            log("Found request from " .. req.farmerName .. " for dungeon " .. req.dungeonId)
            MsqClearHelper.CurrentDungeonId = req.dungeonId
            MsqClearHelper.CurrentFarmer = req.farmerName
        end
    end

    -- If we have a current farmer but they're not in party, invite them
    if MsqClearHelper.CurrentFarmer and not isFarmerInParty() then
        log("Inviting farmer: " .. MsqClearHelper.CurrentFarmer)
        NoobgamPrivateAPI.InviteToParty(MsqClearHelper.CurrentFarmer)
        wait(3000)
        return true
    end

    return false
end

local function updateFarmer()
    handleInvites()

    if IsControlOpen("ContentsFinderConfirm") then
        log("Confirming dungeon entry")
        UseControlAction("ContentsFinderConfirm", "Confirm")
        wait(2000)
        return true
    end

    if MsqClearHelper.CurrentDungeonId and table.valid(EntityList.myparty) then
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
        if MsqClearHelper.CurrentDungeonId ~= neededDungeon then
            MsqClearHelper.CurrentDungeonId = neededDungeon
            MsqClearHelper.RegisterForClear(neededDungeon)
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
    local exit = NoobgamUtils.PickClosestExit()
    if exit ~= nil and exit.targetable then
        log("Exit is visible")
        return leaveDuty()
    end
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

    local inDungeon = table.valid(Duty:GetActiveDutyInfo())
    if inDungeon then
        -- use KDF profiles here?
        NoobgamUtils.SwitchMode("Assist")
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
        if MsqClearHelper.InDungeon then
            log("Left dungeon, marking for disband")
            MsqClearHelper.InDungeon = false
            MsqClearHelper.NeedToDisband = true
            MsqClearHelper.UnregisterClear()
            MsqClearHelper.CurrentDungeonId = nil
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
