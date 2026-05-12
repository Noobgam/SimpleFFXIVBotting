---@diagnostic disable: undefined-global, undefined-field

if NoobgamTaskManager == nil then
    NoobgamTaskManager = {}
end

--- @class Task
--- @field type string
--- @field params table
--- @field onEnd fun()|nil

--- @class TaskWithId : Task
--- @field id integer

--- @type Task|nil
NoobgamTaskManager.Task = nil

--- @type TaskWithId[]
NoobgamTaskManager.TaskQueue = {}

NoobgamTaskManager.CurrentTaskParams = {}
NoobgamTaskManager.TasksDone = {}
NoobgamTaskManager.KeyPressQueue = {}
NoobgamTaskManager._TaskDone = false
NoobgamTaskManager.WaitUntil = nil
NoobgamTaskManager.WaitCondition = nil
NoobgamTaskManager.BreakOutDelayMillis = nil
NoobgamTaskManager.TaskId = 1

-- ---------------------------------------------------------------------------
-- Internal helpers
-- ---------------------------------------------------------------------------

local keyOpcodes = {
    NUM0    = 96,
    NUM1    = 97,
    NUM2    = 98,
    NUM3    = 99,
    NUM4    = 100,
    NUM5    = 101,
    NUM6    = 102,
    NUM7    = 103,
    NUM8    = 104,
    NUM9    = 105,
    NUMSTAR = 106,
    NUMDOT  = 110,
}

local function log(message)
    d("[NoobgamTaskManager] " .. tostring(message))
end

---@param millis integer
---@param breakOutCondition (fun(): boolean)|nil
---@param breakOutDelayMillis number|nil
local function wait(millis, breakOutCondition, breakOutDelayMillis)
    local suggested = GetTickCount() + millis

    if breakOutCondition then
        if NoobgamTaskManager.WaitCondition == nil or NoobgamTaskManager.WaitUntil < suggested then
            NoobgamTaskManager.WaitCondition = breakOutCondition
            NoobgamTaskManager.WaitUntil = suggested
            NoobgamTaskManager.BreakOutDelayMillis = breakOutDelayMillis
        end
    else
        if NoobgamTaskManager.WaitUntil == nil or NoobgamTaskManager.WaitUntil < suggested then
            NoobgamTaskManager.WaitCondition = nil
            NoobgamTaskManager.WaitUntil = suggested
        end
    end
end

---@param actions (number|(fun(): (number|nil)))[]
---@param wait_override number|nil
local function pressKeys(actions, wait_override)
    for i = 1, #actions do
        local action = actions[i]
        if type(action) == "number" then
            table.insert(NoobgamTaskManager.KeyPressQueue, { key = action, wait = wait_override or 400 })
        elseif type(action) == "function" then
            table.insert(NoobgamTaskManager.KeyPressQueue, { callback = action, wait = wait_override or 400 })
        end
    end
end

---@return boolean whether something was pressed
local function processKeyPress()
    if #NoobgamTaskManager.KeyPressQueue == 0 then
        return false
    end

    local top = NoobgamTaskManager.KeyPressQueue[1]
    local wait_millis = top.wait

    if top.key ~= nil then
        log("Pressing key " .. top.key)
        PressKey(top.key)
    elseif top.callback ~= nil then
        local function errorHandler(err)
            log("[EXCEPTION] " .. tostring(err))
        end
        local status, wait_res = xpcall(top.callback, errorHandler)
        if status then
            if wait_res ~= nil then
                wait_millis = wait_res
            end
        else
            NoobgamTaskManager.KeyPressQueue = {}
            log("[ERROR] Callback failed, clearing key queue")
            return false
        end
    end

    table.remove(NoobgamTaskManager.KeyPressQueue, 1)
    wait(wait_millis or 500)
    return true
end

--- Reset current task state back to start
local function restartTask()
    log("Restarting current task.")
    NoobgamTaskManager.CurrentTaskParams = {}
    NoobgamTaskManager.WaitCondition = nil
    NoobgamTaskManager.WaitUntil = nil
    NoobgamTaskManager.KeyPressQueue = {}
end

local function nextId()
    local rv = NoobgamTaskManager.TaskId or 1
    if rv > 1000 then
        rv = 1
    end
    NoobgamTaskManager.TaskId = rv + 1
    return rv
end

local function leaveDuty()
    if not IsControlOpen("ContentsFinderMenu") then
        ActionList:Get(10, 33):Cast()
    else
        if not IsControlOpen("SelectYesno") then
            UseControlAction("ContentsFinderMenu", "Leave")
        else
            UseControlAction("SelectYesno", "Yes")
        end
    end
end

-- ---------------------------------------------------------------------------
-- Task: genericGoTo
-- ---------------------------------------------------------------------------

--- @class GenericGoToParams
--- @field map_id number
--- @field position table { x: number, y: number, z: number }
--- @field facing table|nil { x: number, y: number, z: number }
--- @field teleportOverride? integer
--- @field teleportMapId? integer
--- @field threshold? number
--- @field breakCondition? fun(): boolean

---@param params GenericGoToParams
local function genericGoTo(params)
    if MGetGameState() ~= FFXIV.GAMESTATE.INGAME then
        log("[ERROR] Not in game, cannot navigate.")
        return true
    end

    if params.breakCondition and params.breakCondition() then
        log("Break condition met.")
        return true
    end

    if params.map_id == nil then
        log("[ERROR] No map_id specified.")
        return true
    end

    if params.position == nil then
        log("[ERROR] No position specified.")
        return true
    end

    if IsControlOpen("SelectString") then
        GetControlByName("SelectString"):Close()
        wait(1000)
        return false
    end

    if IsControlOpen("JournalAccept") then
        UseControlAction("JournalAccept", "Accept")
        wait(1000)
        return false
    end

    if IsControlOpen("JournalResult") then
        UseControlAction("JournalResult", "Complete")
        wait(1000)
        return false
    end

    if table.valid(Duty:GetActiveDutyInfo()) then
        log("[WARNING] In duty during genericGoTo, leaving.")
        leaveDuty()
        wait(1000)
        return false
    end

    if not Player.alive then
        local yes = GetControlStrings("SelectYesno", 2)
        if yes ~= nil and yes:find("Return to", 1, true) ~= nil then
            PressYesNo(true)
            wait(1000)
            return false
        end
    end

    if Player:GetFishingState() ~= 0 then
        ActionList:Get(1, 299):Cast()
        wait(500)
        return false
    end

    if Player.localmapid == 0 then
        log("Map id is 0, probably loading.")
        wait(1000, function()
            return Player.localmapid ~= 0
        end)
        return false
    end

    local ctp = NoobgamTaskManager.CurrentTaskParams

    -- Teleport override: go to a nearby map first if needed
    if Player.localmapid ~= params.map_id then
        if params.teleportOverride ~= nil then
            if not ctp.Teleported then
                if Player.localmapid ~= (params.teleportMapId or params.map_id) then
                    if not Busy() then
                        Player:Teleport(params.teleportOverride)
                    end
                    wait(1000)
                    return false
                else
                    ctp.Teleported = true
                end
            end
        end
    end

    -- Schedule navigation task if not already running
    if not ctp.ScheduledTask then
        if not NavigationTask.IsActive() then
            local ok = NavigationTask.MoveTo({
                mapId = params.map_id,
                pos   = params.position,
                range = params.threshold or 1,
            })
            if ok then
                ctp.ScheduledTask = true
                wait(1500)
            else
                log("[WARNING] NavigationTask.MoveTo returned false, will retry.")
                wait(1000)
            end
        else
            log("[WARNING] Navigation already active, waiting.")
            wait(1000)
        end
        return false
    end

    -- Stuck detection
    if NavigationTask.IsActive() then
        local sprint = ActionList:Get(1, 3)
        if sprint and sprint:IsReady() then
            sprint:Cast()
        end

        if ctp.LastStuckCheck == nil or ctp.LastStuckCheck < GetTickCount() - 2500 then
            ctp.LastStuckCheck = GetTickCount()
            local dist = (ctp.LastPos ~= nil)
                and math.distance3d(ctp.LastPos, Player.pos)
                or 999
            if dist < 0.2 then
                ctp.LastStuck = ctp.LastStuck or GetTickCount()
            else
                ctp.LastStuck = nil
            end
            ctp.LastPos = Player.pos

            if ctp.LastStuck ~= nil and ctp.LastStuck < GetTickCount() - 30000 then
                local ret = ActionList:Get(1, 6)
                if ret and ret:IsReady() and ret:Cast() then
                    log("Stuck for 30s, cast Return.")
                    wait(5000)
                end
                return false
            end

            wait(3000, function()
                return not NavigationTask.IsActive()
            end)
        end
        return false
    end

    -- Navigation finished — check distance
    local ppos = Player.pos
    local threshold = params.threshold or 0.5
    local distanceToGoal = math.distance2d(
        params.position.x, params.position.z,
        ppos.x, ppos.z
    )

    if distanceToGoal < threshold then
        Player:Stop()
        Player:SetAutoFollowOn(false)
        if Player.ismounted then
            Dismount()
            wait(500)
            return false
        end
        return true
    end

    -- Close enough for fine movement
    if distanceToGoal >= 1.5 then
        local sprint = ActionList:Get(1, 3)
        if sprint and sprint:IsReady() then
            sprint:Cast()
        end
        Player:MoveTo(params.position.x, params.position.y, params.position.z)
        wait(10000, function()
            return math.distance2d(
                params.position.x, params.position.z,
                Player.pos.x, Player.pos.z
            ) < 1.5
        end)
        return false
    end

    if not Player:IsMoving() and Player.ismounted and distanceToGoal < 1.5 then
        Dismount()
        wait(500)
        return false
    end

    if ctp.AutoFollowCorrection == nil then
        Player:Stop()
        Player:SetAutoFollowPos(params.position.x, params.position.y, params.position.z)
        Player:SetAutoFollowOn(true)
        ctp.AutoFollowCorrection = true
        wait(500, function()
            local d = math.distance3d(Player.pos, params.position)
            return d ~= nil and d < 0.1
        end)
    end

    if distanceToGoal < 0.1 and not Player.ismounted then
        if params.facing then
            if not ctp.StoppedMoving then
                Player:SetAutoFollowOn(false)
                Player:SetFacing(params.facing.x, params.facing.y, params.facing.z)
                wait(5000, function()
                    local d = math.distance3d(Player.pos, params.position)
                    return d ~= nil and d < 0.1
                end)
                ctp.StoppedMoving = true
                return false
            end

            if Player:IsMoving() then
                Player:Stop()
                Player:SetAutoFollowOn(false)
                wait(1000)
                return false
            end

            Player:SetFacing(params.facing.x, params.facing.y, params.facing.z)

            local targetAngle = math.atan2(
                params.facing.x - Player.pos.x,
                params.facing.z - Player.pos.z
            )
            local angleDiff = math.abs(targetAngle - Player.pos.h)
            if angleDiff > math.pi then
                angleDiff = 2 * math.pi - angleDiff
            end

            if angleDiff <= 0.01 then
                log("Facing set. Task done.")
                return true
            end
            return false
        end

        log("Arrived. Task done.")
        return true
    end

    log("[WARNING] Dead spot in genericGoTo, restarting.")
    restartTask()
    return false
end

-- ---------------------------------------------------------------------------
-- Task: createPF (startPF)
-- ---------------------------------------------------------------------------
-- NoobgamTaskManager.Schedule({ type="createPF", params={} })

--- @class CreatePFParams
--- @field mode 1|2|nil
--- @field password integer|nil

---@param params CreatePFParams
local function createPF(params)
    local ctp = NoobgamTaskManager.CurrentTaskParams
    if params.mode == nil then
        params.mode = 1
    end
    if params.password == nil then
        params.password = 1731
    end

    -- If we're in a party but not leader, leave first
    if table.valid(EntityList.myparty) then
        local leader = nil
        for _, v in pairs(EntityList.myparty) do
            if v.isleader then
                leader = v
                break
            end
        end
        if leader == nil then
            log("[ERROR] Party leader unknown.")
            wait(1000)
            return false
        end
        if leader.name ~= Player.name then
            log("Not party leader, scheduling leaveParty before createPF.")
            NoobgamTaskManager.Reschedule()
            NoobgamTaskManager.PushSchedule({ type = "leaveParty", params = {} })
            return true
        end
    end

    -- Cleanup path
    if ctp.needCleanup then
        if IsControlOpen("LookingForGroupDetail") then
            GetControlByName("LookingForGroupDetail"):Close()
            wait(500)
            return false
        end
        if IsControlOpen("LookingForGroupPrivate") then
            GetControlByName("LookingForGroupPrivate"):Close()
            wait(500)
            return false
        end
        if IsControlOpen("LookingForGroup") then
            GetControlByName("LookingForGroup"):Close()
            wait(500)
            return false
        end
        if IsControlOpen("LookingForGroupCondition") then
            GetControlByName("LookingForGroupCondition"):Close()
            wait(500)
            return false
        end
        if table.valid(EntityList.crossworldparty) or table.valid(EntityList.myparty) then
            log("Party detected during cleanup, disbanding.")
            NoobgamTaskManager.Reschedule()
            NoobgamTaskManager.PushSchedule({ type = "disbandParty", params = {} })
            return true
        end
        NoobgamTaskManager.CurrentTaskParams = {}
        return false
    end

    if ctp.TaskStarted < GetTickCount() - 50000 then
        log("[WARNING] createPF timed out, cleaning up.")
        ctp.needCleanup = true
        return false
    end

    -- State defaults
    ctp.StartPfState   = ctp.StartPfState   or "PFNotOpen"
    ctp.EnsuredPFMode  = ctp.EnsuredPFMode  or false
    ctp.PFStarted      = ctp.PFStarted      or false

    -- Step 1: ensure LookingForGroupCondition is open
    if ctp.StartPfState == "PFNotOpen" then
        if not IsControlOpen("LookingForGroupCondition") then
            if not IsControlOpen("LookingForGroup") then
                log("Opening PF UI.")
                local pfOpen = ActionList:Get(10, 57)
                if not pfOpen then return false end
                pfOpen:Cast()
                wait(1000)
            else
                log("PF open, opening condition window.")
                pressKeys({
                    function()
                        GetControlByName("LookingForGroup"):PushButton(25, 2)
                    end,
                    function()
                        if IsControlOpen("LookingForGroupCondition") then
                            pressKeys({
                                function()
                                    GetControlByName("LookingForGroupCondition"):PushButton(25, 2)
                                end,
                                function()
                                    PressYesNo(true)
                                end
                            })
                            ctp.StartPfState = "CreatingPF"
                        end
                    end
                })
            end
        else
            ctp.StartPfState = "ReadyToSetup"
        end
        return false
    end

    -- Step 2: configure PF mode
    if not ctp.EnsuredPFMode then
        if params.mode == 1 then
            pressKeys({
                function() UIEvent(130, 3, {{3, 34}, {5, 0}, {0, 0}}) end,
                function() UIEvent(130, 3, {{3, 12}, {5, 0}, {5, 0}}) end,
                function() UIEvent(130, 3, {{3, 21}, {5, 1}, {0, 0}}) end,
                function() UIEvent(130, 3, {{3, 16}, {3, params.password}, {0, 0}}) end,
                function() UIEvent(130, 3, {{3, 32}, {2, 1}, {0, 0}}) end,
                function() ctp.EnsuredPFMode = true end,
            }, 2000)
        elseif params.mode == 2 then
            pressKeys({
                function() UIEvent(130, 3, {{3, 34}, {5, 1}, {0, 0}}) end,
                function() UIEvent(130, 3, {{3, 12}, {5, 5}, {0, 0}}) end,
                function()
                    local lotaIndex = 0
                    for i = 49, 90 do
                        local rd = GetControlRawData("LookingForGroupCondition", i)
                        if rd and rd.value == "The Labyrinth of the Ancients" then
                            lotaIndex = i - 49
                            break
                        end
                    end
                    UIEvent(130, 3, {{3, 13}, {5, lotaIndex}, {0, 0}})
                end,
                function() UIEvent(130, 3, {{3, 21}, {5, 1}, {0, 0}}) end,
                function() UIEvent(130, 3, {{3, 16}, {3, params.password}, {0, 0}}) end,
                function() UIEvent(130, 3, {{3, 32}, {2, 1}, {0, 0}}) end,
                function() ctp.EnsuredPFMode = true end,
            }, 500)
        end
        return false
    end

    -- Step 3: validate and submit
    if not ctp.PFStarted then
        log("Submitting PF.")
        local control = GetControlByName("LookingForGroupCondition")
        if not control then
            log("[ERROR] LookingForGroupCondition not found.")
            return false
        end
        local rd = control:GetRawData()

        if params.mode == 1 then
            if rd[282].value ~= 4 or rd[288].value ~= 4 then
                log("Jobs still requested, cleaning up.")
                ctp.needCleanup = true
                return false
            end
            if rd[45].value ~= 0 then
                log("Not a 'none' PF setup, cleaning up.")
                ctp.needCleanup = true
                return false
            end
        else
            if rd[282].value ~= 4 or rd[304].value ~= 4 then
                log("Jobs still requested, cleaning up.")
                ctp.needCleanup = true
                return false
            end
            if rd[45].value ~= 5 then
                log("Not an alliance PF setup, cleaning up.")
                ctp.needCleanup = true
                return false
            end
        end

        control:PushButton(25, 0)
        ctp.PFStarted = true
        wait(2000)
        return false
    end

    return true
end

-- ---------------------------------------------------------------------------
-- Task: joinPF
-- ---------------------------------------------------------------------------
-- NoobgamTaskManager.Schedule({ type="joinPF", params={ recruiterName="Filvendor Surionex"} })

--- @class JoinPFParams
--- @field recruiterName string
--- @field allianceId? integer
--- @field password? integer
--- @field onFailure? function

---@param params JoinPFParams
local function joinPF(params)
    local ctp = NoobgamTaskManager.CurrentTaskParams
    if params.password == nil then
        params.password = 1731
    end

    if ctp.TaskStarted < GetTickCount() - 60000 then
        log("[ERROR] joinPF timed out after 60s.")
        if params.onFailure then params.onFailure() end
        return true
    end

    if table.valid(EntityList.crossworldparty) then
        log("In crossworld party — join done.")
        return true
    end

    -- Cleanup path
    if ctp.needCleanup then
        if IsControlOpen("LookingForGroupDetail") then
            GetControlByName("LookingForGroupDetail"):Close()
            wait(500)
            return false
        end
        if IsControlOpen("LookingForGroup") then
            GetControlByName("LookingForGroup"):Close()
            wait(500)
            return false
        end
        if IsControlOpen("SelectYesno") then
            PressYesNo(false)
            wait(500)
            return false
        end
        if IsControlOpen("LookingForGroupPrivate") then
            GetControlByName("LookingForGroupPrivate"):Close()
            wait(500)
            return false
        end

        local retryCount = ctp.retryCount or 0
        NoobgamTaskManager.CurrentTaskParams = { retryCount = retryCount + 1 }
        if retryCount > 2 then
            log("[WARNING] joinPF failed after retries.")
            if params.onFailure then params.onFailure() end
            return true
        end
        return false
    end

    ctp.JoinPfState = ctp.JoinPfState or "PFNotOpen"

    -- Waiting for join confirmation
    if ctp.JoinPfState == "ExpectingJoined" then
        if ctp.WaitingForJoined == nil then
            log("Waiting 5s for join to register.")
            ctp.WaitingForJoined = true
            wait(5000)
            return false
        end
        log("[ERROR] Expected to be in PF but am not. Cleaning up.")
        ctp.needCleanup = true
        return false
    end

    -- Step 1: open PF UI
    if ctp.JoinPfState == "PFNotOpen" then
        if not IsControlOpen("LookingForGroup") then
            log("Opening PF UI.")
            local pfOpen = ActionList:Get(10, 57)
            if not pfOpen then return false end
            pfOpen:Cast()
            wait(1500)
        else
            log("PF open, switching to private tab.")
            GetControlByName("LookingForGroup"):PushButton(25, 13)
            ctp.JoinPfState = "ScrollingThroughPFs"
            wait(1500)
        end
        return false
    end

    -- Step 2: scroll through listings to find recruiter
    if ctp.JoinPfState == "ScrollingThroughPFs" then
        if not IsControlOpen("LookingForGroup") then
            log("[ERROR] LFG closed unexpectedly, cleaning up.")
            ctp.needCleanup = true
            return false
        end

        local compactMode = GetControlRawData("LookingForGroup", 10)
        if compactMode == nil then
            wait(1000)
            return false
        end
        if compactMode.value == false then
            log("[WARNING] Non-compact PF mode detected, cleaning up.")
            GetControlByName("LookingForGroup"):PushButton(25, 16)
            ctp.needCleanup = true
            return false
        end

        local pfCount = GetControlStrings("LookingForGroup", 49)
        if pfCount == nil then
            wait(500)
            return false
        end
        local pfCnt = tonumber(pfCount:match("(%d+).*"))
        ctp.pfIndex = ctp.pfIndex or 0

        if ctp.pfIndex >= pfCnt then
            log("[WARNING] Recruiter not found in PF list, cleaning up.")
            ctp.needCleanup = true
            return false
        end

        pressKeys({
            function()
                UIEvent(130, 1, {{3, 13}, {3, ctp.pfIndex}, {0, 0}})
                log("Hovering PF index: " .. tostring(ctp.pfIndex))
            end,
            function()
                local hoverhint = GetControlRawData("LookingForGroup", 15).value
                if hoverhint and string.find(hoverhint, params.recruiterName, 1, true) then
                    ctp.JoinPfState = "JoiningPF"
                    log("Found recruiter, switching to JoiningPF.")
                else
                    log("Wrong hoverhint: " .. tostring(hoverhint))
                    ctp.pfIndex = ctp.pfIndex + 1
                end
            end,
        }, 100)
        return false
    end

    -- Step 3: join the PF
    if ctp.JoinPfState == "JoiningPF" then
        UIEvent(130, 1, {{3, 11}, {3, ctp.pfIndex}, {3, 0}})

        if IsControlOpen("LookingForGroupDetail") then
            log("Detail control open, proceeding to join.")
            if params.allianceId == nil then
                pressKeys({
                    function()
                        GetControlByName("LookingForGroupDetail"):PushButton(25, 0)
                    end,
                    function() PressYesNo(true) end,
                    function()
                        UIEvent(130, 9, {{3, 0}, {3, params.password}, {0, 0}})
                    end,
                    function()
                        ctp.JoinPfState = "ExpectingJoined"
                    end
                })
            else
                pressKeys({
                    function() log("Waiting 1s before joining PF.") end,
                    function()
                        local control = GetControlByName("LookingForGroupDetail")
                        local picked = params.allianceId
                        if params.allianceId == -1 then
                            picked = math.random(1, 3)
                            log("Random alliance group picked: " .. tostring(picked))
                        end
                        log("Joining alliance " .. tostring(picked))
                        control:PushButton(25, 2 + picked)
                    end,
                    function() PressYesNo(true) end,
                    function() log("Waiting 1s before entering password.") end,
                    function()
                        log("Entering password " .. tostring(params.password))
                        UIEvent(130, 9, {{3, 0}, {3, params.password}, {0, 0}})
                    end,
                    function()
                        local c = GetControlByName("LookingForGroupPrivate")
                        if c and c:IsOpen() then c:Close() end
                        ctp.JoinPfState = "ExpectingJoined"
                    end
                })
            end
            return false
        end

        -- Detail not open yet — verify hover still matches
        local hover = GetControlRawData("LookingForGroup", 15)
        if hover ~= nil and hover.value and string.find(hover.value, params.recruiterName, 1, true) then
            log("Retrying join click.")
            PressKey(keyOpcodes.NUM0)
            wait(1000)
        else
            log("[WARNING] JoiningPF: detail not open and hover lost.")
            wait(5000)
        end
        return false
    end

    return false
end

-- ---------------------------------------------------------------------------
-- Task: leaveParty (dependency for createPF)
-- ---------------------------------------------------------------------------

local function leaveParty()
    local ctp = NoobgamTaskManager.CurrentTaskParams

    if ctp.needCleanup then
        if IsControlOpen("Social") then
            GetControlByName("Social"):Close()
            wait(500)
            return false
        end
        if IsControlOpen("SelectYesno") then
            PressYesNo(false)
            wait(500)
            return false
        end
        ctp.needCleanup = false
        return false
    end

    if not table.valid(EntityList.crossworldparty) and not table.valid(EntityList.myparty) then
        log("Not in a party.")
        return true
    end

    if not table.valid(EntityList.crossworldparty) then
        pressKeys({
            function() NoobgamUtils.LeaveParty() end,
            function() PressYesNo(true) end,
        }, 1000)
    else
        pressKeys({
            function() NoobgamUtils.LeaveParty() end,
            keyOpcodes.NUM0,
            keyOpcodes.NUM8,
            keyOpcodes.NUM8,
            keyOpcodes.NUM6,
            keyOpcodes.NUM0,
            function() PressYesNo(true) end,
            function() PressYesNo(true) end,
        }, 1000)
    end
    return false
end

-- ---------------------------------------------------------------------------
-- Task: disbandParty (dependency for createPF)
-- ---------------------------------------------------------------------------

local function disbandParty()
    if IsControlOpen("Social") then
        GetControlByName("Social"):Close()
        wait(500)
        return false
    end
    if IsControlOpen("WebGuidance") then
        GetControlByName("WebGuidance"):Close()
        wait(500)
        return false
    end

    if not table.valid(EntityList.myparty) and not table.valid(EntityList.crossworldparty) then
        log("Party disbanded.")
        return true
    end

    local ctp = NoobgamTaskManager.CurrentTaskParams
    if ctp.needCleanup then
        if IsControlOpen("Social") then
            GetControlByName("Social"):Close()
            wait(500)
            return false
        end
        if IsControlOpen("SelectYesno") then
            PressYesNo(false)
            wait(500)
            return false
        end
        ctp.needCleanup = false
        return false
    end

    if not table.valid(EntityList.crossworldparty) then
        pressKeys({
            function() SendTextCommand("/pcmd breakup") end,
            function() PressYesNo(true) end,
        }, 1000)
    else
        pressKeys({
            function() SendTextCommand("/pcmd breakup") end,
            function() UIEvent(61, 0, {{3, 2}, {3, 3}, {0, 0}, {0, 0}}) end,
            function() PressYesNo(true) end,
            function() PressYesNo(true) end,
        }, 1000)
    end
    return false
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

function NoobgamTaskManager.Reset()
    log("Reset.")
    NoobgamTaskManager.Task = nil
    NoobgamTaskManager.KeyPressQueue = {}
    NoobgamTaskManager.TaskQueue = {}
    NoobgamTaskManager.TasksDone = {}
    NoobgamTaskManager.CurrentTaskParams = {}
    NoobgamTaskManager._TaskDone = false
    NoobgamTaskManager.WaitUntil = nil
    NoobgamTaskManager.WaitCondition = nil
end

---@param task Task
---@param onEnd fun()|nil
---@return integer
function NoobgamTaskManager.Schedule(task, onEnd)
    local id = nextId()
    log("Scheduled [" .. task.type .. "] id=" .. id)
    table.insert(NoobgamTaskManager.TaskQueue, {
        id     = id,
        type   = task.type,
        params = task.params,
        onEnd  = task.onEnd or onEnd,
    })
    return id
end

---@param task Task
---@param onEnd fun()|nil
---@return integer
function NoobgamTaskManager.PushSchedule(task, onEnd)
    local id = nextId()
    log("PushScheduled [" .. task.type .. "] id=" .. id)
    table.insert(NoobgamTaskManager.TaskQueue, 1, {
        id     = id,
        type   = task.type,
        params = task.params,
        onEnd  = task.onEnd or onEnd,
    })
    return id
end

---@param tasks Task[]
function NoobgamTaskManager.PushMultiple(tasks)
    if not tasks or #tasks == 0 then return end
    for i = #tasks, 1, -1 do
        NoobgamTaskManager.PushSchedule(tasks[i])
    end
end

function NoobgamTaskManager.Reschedule()
    log("Rescheduling current task.")
    table.insert(NoobgamTaskManager.TaskQueue, 1, NoobgamTaskManager.Task)
    NoobgamTaskManager.Task = nil
    NoobgamTaskManager.CurrentTaskParams = {}
end

---@param mapId number
---@param pos table
---@param teleportOverride number|nil
---@param threshold number|nil
---@return integer
function NoobgamTaskManager.GoTo(mapId, pos, teleportOverride, threshold)
    return NoobgamTaskManager.Schedule({
        type   = "genericGoTo",
        params = {
            map_id          = mapId,
            position        = pos,
            teleportOverride = teleportOverride,
            threshold       = threshold,
        }
    })
end

---@return integer|nil
function NoobgamTaskManager.TaskDone(id)
    return NoobgamTaskManager.TasksDone[id]
end

-- ---------------------------------------------------------------------------
-- Update loop — call this every frame / on_update
-- ---------------------------------------------------------------------------

---@return boolean whether the task manager is busy
function NoobgamTaskManager.Update()
    -- Wait logic
    if NoobgamTaskManager.WaitUntil ~= nil and NoobgamTaskManager.WaitUntil > GetTickCount() then
        if NoobgamTaskManager.WaitCondition and NoobgamTaskManager.WaitCondition() then
            NoobgamTaskManager.WaitUntil = GetTickCount() + (NoobgamTaskManager.BreakOutDelayMillis or 0)
            NoobgamTaskManager.BreakOutDelayMillis = nil
            NoobgamTaskManager.WaitCondition = nil
        end
        return true
    end

    if processKeyPress() then
        return true
    end

    local function taskDone()
        if NoobgamTaskManager.Task == nil then
            log("[WARNING] taskDone called with no active task.")
            return
        end
        log("Task done: " .. NoobgamTaskManager.Task.type)
        local tid = NoobgamTaskManager.Task.id
        local endCallback = NoobgamTaskManager.Task.onEnd
        NoobgamTaskManager.TasksDone[tid] = GetTickCount()
        NoobgamTaskManager.Task = nil
        NoobgamTaskManager._TaskDone = false
        NoobgamTaskManager.CurrentTaskParams = {}
        if endCallback then
            pcall(endCallback)
        end
    end

    if NoobgamTaskManager._TaskDone then
        taskDone()
    end

    -- Timeout check
    local ctp = NoobgamTaskManager.CurrentTaskParams
    if ctp.TaskStarted ~= nil and ctp.TimeOut ~= nil then
        if GetTickCount() - ctp.TaskStarted > ctp.TimeOut then
            log("[WARNING] Task timed out.")
            NoobgamTaskManager._TaskDone = true
        end
    end

    -- Dequeue next task
    if #NoobgamTaskManager.TaskQueue > 0 and NoobgamTaskManager.Task == nil then
        NoobgamTaskManager.Task = NoobgamTaskManager.TaskQueue[1]
        NoobgamTaskManager.CurrentTaskParams = {}
        table.remove(NoobgamTaskManager.TaskQueue, 1)
        log("Dequeued task: " .. NoobgamTaskManager.Task.type)
    end

    local taskMapping = {
        genericGoTo  = genericGoTo,
        createPF     = createPF,
        joinPF       = joinPF,
        leaveParty   = leaveParty,
        disbandParty = disbandParty,
    }

    if NoobgamTaskManager.Task ~= nil then
        if NoobgamTaskManager.CurrentTaskParams.TaskStarted == nil then
            NoobgamTaskManager.CurrentTaskParams.TaskStarted = GetTickCount()
        end

        local executor = taskMapping[NoobgamTaskManager.Task.type]
        if executor == nil then
            log("[ERROR] Unknown task type: " .. tostring(NoobgamTaskManager.Task.type))
            NoobgamTaskManager._TaskDone = true
            return true
        end

        local done, res = executor(NoobgamTaskManager.Task.params)
        if done then
            taskDone()
        end
        if res ~= nil then
            return res
        end
        return true
    end

    return false
end

return NoobgamTaskManager