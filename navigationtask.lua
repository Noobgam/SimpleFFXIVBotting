---@diagnostic disable: undefined-global, undefined-field

NavigationTask = {}
NavigationTask.Data = {
    mapId = 0,
    pos = {},
    remainMounted = false,
    range = 1,
}

local tasks = inheritsFrom(ml_task)
NavigationTask.tasks = tasks

function tasks.Create()
    local newinst = inheritsFrom(tasks)

    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.auxiliary = false
    newinst.process_elements = {}
    newinst.overwatch_elements = {}

    newinst.name = "NAVIGATION"
    newinst.destMapID = NavigationTask.Data.mapId
    newinst.pos = NavigationTask.Data.pos
    newinst.remainMounted = NavigationTask.Data.remainMounted
    newinst.range = NavigationTask.Data.range

    return newinst
end

-- CNE: Move to different map
local cGoToMap = inheritsFrom(ml_cause)
local eGoToMap = inheritsFrom(ml_effect)
tasks.cGoToMap = cGoToMap
tasks.eGoToMap = eGoToMap

function cGoToMap:evaluate()
    local mapId = NavigationTask.Data.mapId
    if Player.localmapid ~= mapId then
        return CanAccessMap(mapId)
    end
    return false
end

function eGoToMap:execute()
    local task = ffxiv_task_movetomap.Create()
    task.destMapID = NavigationTask.Data.mapId
    task.pos = NavigationTask.Data.pos
    task.useTeleport = false
    ml_task_hub:CurrentTask():AddSubTask(task)
end

-- CNE: Move to position on current map
local cGoToPos = inheritsFrom(ml_cause)
local eGoToPos = inheritsFrom(ml_effect)
tasks.cGoToPos = cGoToPos
tasks.eGoToPos = eGoToPos

function cGoToPos:evaluate()
    local mapId = NavigationTask.Data.mapId
    if Player.localmapid == mapId then
        local pos = NavigationTask.Data.pos
        if pos and NavigationManager:IsReachable(pos) then
            local dist = math.distance3d(Player.pos, pos)
            local range = NavigationTask.Data.range or 1
            if dist > range then
                return true
            else
                -- Arrived at destination
                Player:Stop()
                local task = ml_task_hub:CurrentTask()
                if task then
                    task.completed = true
                end
                if ml_task_hub.shouldRun then
                    ml_task_hub.shouldRun = false
                end
            end
        end
    end
    return false
end

function eGoToPos:execute()
    local task = ffxiv_task_movetopos.Create()
    task.pos = NavigationTask.Data.pos
    task.range = NavigationTask.Data.range or 1
    task.remainMounted = NavigationTask.Data.remainMounted or false
    ml_task_hub:CurrentTask():AddSubTask(task)
end

function tasks:Init()
    local goToMap = ml_element:create("Navigation_GoToMap", cGoToMap, eGoToMap, 20)
    self:add(goToMap, self.process_elements)

    local goToPos = ml_element:create("Navigation_GoToPos", cGoToPos, eGoToPos, 15)
    self:add(goToPos, self.process_elements)
end

---@class NavigationParams
---@field mapId number
---@field pos table { x: number, y: number, z: number }
---@field range? number
---@field remainMounted? boolean

---@param params NavigationParams
---@return boolean success
function NavigationTask.MoveTo(params)
    if not params.mapId or not params.pos then
        return false
    end

    if ml_navigation:HasPath() then
        return false
    end

    NavigationTask.Data.mapId = params.mapId
    NavigationTask.Data.pos = {
        x = params.pos.x,
        y = params.pos.y,
        z = params.pos.z
    }
    NavigationTask.Data.range = params.range or 1
    NavigationTask.Data.remainMounted = params.remainMounted or false

    local task = tasks.Create()
    ml_task_hub:ClearQueues()
    ml_task_hub.shouldRun = true
    ml_task_hub:Add(task, REACTIVE_GOAL, TP_IMMEDIATE)

    return true
end

---@return boolean
function NavigationTask.IsActive()
    return ml_task_hub:CurrentTask() ~= nil and ml_task_hub.shouldRun
end

function NavigationTask.Stop()
    Player:Stop()
    ml_task_hub:ClearQueues()
    ml_task_hub.shouldRun = false
end

return NavigationTask
