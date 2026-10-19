-- Optional VaultSpamer-style recovery. The navigation shim stays installed,
-- but all recovery actions require the addon and circuit-breaker toggle enabled.
if NoobgamCircuitBreaker == nil then NoobgamCircuitBreaker = {} end
local CB = NoobgamCircuitBreaker
local blockingControls = { "SelectString", "SelectIconString", "Shop", "TelepotTown", "Request", "InventoryEvent" }

local function log(message)
    d("[CircuitBreaker] " .. message)
end

function CB.IsEnabled()
    local config = NoobgamConfigManager and NoobgamConfigManager.Config
    return config ~= nil and config.enabled == true and config.circuitBreakers == true
end

local function safeWorld()
    return CB.IsEnabled()
        and MGetGameState() == FFXIV.GAMESTATE.INGAME
        and Player ~= nil and Player.localmapid ~= 0 and Player.alive
        and not Player.incombat
        and not table.valid(Duty:GetActiveDutyInfo())
        and not MsqBootstrap.IsLattyDungeonHandoffActive()
        and not (KitanoiFuncs and KitanoiFuncs.AreKitanoiAddonsRunning("KDF"))
        and not (MsqClearHelper and MsqClearHelper.CurrentDungeonId ~= nil)
end

function CB.ResetLattyRestartDelay()
    CB.StoppedSince, CB.StoppedScope, CB.StoppedMap = nil, nil, nil
end

local function resetStuck()
    CB.History, CB.StuckSince, CB.LastSample = {}, nil, nil
end

function CB.Reset()
    CB.ResetLattyRestartDelay()
    resetStuck()
    CB.WaitUntil, CB.RecoverUntil = nil, nil
    local state = NoobgamTaskManager and NoobgamTaskManager.CurrentTaskParams
    if state then state.LastStuck, state.LastStuckCheck, state.LastPos = nil, nil, nil end
    -- Keep action cooldowns across toggles/resets so a checkbox cannot bypass them.
end

-- Fresh starts and deliberate profile transitions still work when opted out.
function CB.CanStartLatty(core)
    if not MsqBootstrap.LattyWasRunning and not core.fatalStopLatched then return true end
    if not safeWorld() or NoobgamConfigManager.Config.mode ~= "Bootstrap" or Busy() then
        CB.ResetLattyRestartDelay()
        return false
    end
    if MsqBootstrap.LattyWasRunning then
        local now = GetTickCount()
        local scope = NoobgamConfigManager.Config.useBlueQuestFilter == true and "blue" or "aether"
        if CB.StoppedSince == nil or CB.StoppedScope ~= scope or CB.StoppedMap ~= Player.localmapid then
            CB.StoppedSince, CB.StoppedScope, CB.StoppedMap = now, scope, Player.localmapid
            log("Latty stopped unexpectedly; allowing 3s before restart")
            return false
        end
        if now - CB.StoppedSince < 3000 then return false end
    end
    return true
end

function CB.GetLattyStartSource(core)
    if core.fatalStopLatched ~= true then return true, nil end
    if not safeWorld() or NoobgamConfigManager.Config.mode ~= "Bootstrap" or Busy() then return false end
    local now = GetTickCount()
    if CB.LastFatalRecoveryAt and now - CB.LastFatalRecoveryAt < 60000 then return false end
    CB.LastFatalRecoveryAt = now
    log("Recovering Latty fatal stop (60s cooldown): " .. tostring(core.fatalStopReason))
    -- Same source as Latty's START QUESTING button; ordinary API starts cannot clear a latch.
    return true, "ui"
end

function CB.TryReturn(reason, cooldown)
    if not safeWorld() or Busy() then return false end
    local now = GetTickCount()
    if CB.LastReturnAt and now - CB.LastReturnAt < (cooldown or 5000) then return false end
    local action = ActionList:Get(1, 6)
    if action and action:IsReady() and action:Cast() then
        CB.LastReturnAt, CB.WaitUntil = now, now + 5000
        log("Cast Return: " .. reason)
        return true
    end
    return false
end

function CB.InstallNavigationHook()
    if not c_getmovementpath or type(c_getmovementpath.evaluate) ~= "function" then return end
    if CB.HookedCause == c_getmovementpath then return end
    local original = c_getmovementpath.evaluate
    CB.HookedCause = c_getmovementpath
    c_getmovementpath.evaluate = function(self, ...)
        local result = original(self, ...)
        -- This cause returns true on path FAILURE. Preserve its original result.
        if result then CB.TryReturn("Navigation path failure", 3600000) end
        return result
    end
end

-- Called by genericGoTo; keeps the old 30s threshold, but opt-in now.
function CB.UpdateNavigationStuck(state)
    if not safeWorld() or Busy() then
        state.LastStuck, state.LastStuckCheck, state.LastPos = nil, nil, nil
        return false
    end
    local now = GetTickCount()
    if state.LastStuckCheck and now - state.LastStuckCheck < 2500 then return false end
    state.LastStuckCheck = now
    local pos = Player.pos
    local distance = state.LastPos and math.distance3d(state.LastPos, pos) or 999
    if distance < 0.2 then state.LastStuck = state.LastStuck or now
    else state.LastStuck = nil end
    state.LastPos = { x = pos.x, y = pos.y, z = pos.z }
    if state.LastStuck and now - state.LastStuck >= 30000 then
        return CB.TryReturn("Navigation stuck for 30s")
    end
    return false
end

local function hasBlockingControl()
    for _, name in ipairs(blockingControls) do
        if IsControlOpen(name) then return true end
    end
    return false
end

-- Called before task/wait early returns; never interfere with party/UI task ownership.
function CB.Update()
    CB.InstallNavigationHook()
    if not safeWorld() then
        CB.Reset()
        return false
    end
    local now = GetTickCount()
    if CB.PlayerID ~= Player.id or CB.MapID ~= Player.localmapid or CB.Mode ~= NoobgamConfigManager.Config.mode then
        if CB.PlayerID ~= Player.id then CB.LastFatalRecoveryAt, CB.LastReturnAt = nil, nil end
        CB.Reset()
        CB.PlayerID, CB.MapID, CB.Mode = Player.id, Player.localmapid, NoobgamConfigManager.Config.mode
    end
    if CB.WaitUntil and now < CB.WaitUntil then return true end
    CB.WaitUntil = nil
    if NoobgamTaskManager.Task or #NoobgamTaskManager.TaskQueue > 0
        or NoobgamConfigManager.Config.mode ~= "Bootstrap" then
        resetStuck()
        CB.RecoverUntil = nil
        return false
    end
    if CB.RecoverUntil then
        -- Latty StopQuesting can be asynchronous. Hold none until it has stopped,
        -- but don't get trapped forever if an upstream stop is rejected.
        if now >= CB.RecoverUntil then CB.RecoverUntil = nil; return false end
        MsqBootstrap.EnsureProfileEnabled("none")
        CB.WaitUntil = now + 1000
        local core = LattyLib.QuestCore
        if core.running or core.stopping or FFXIV_Common_BotRunning then return true end
        for _, name in ipairs(blockingControls) do
            local control = GetControlByName(name)
            if control and control:IsOpen() then
                control:Close()
                log("Closing stuck control: " .. name)
                return true
            end
        end
        CB.TryReturn("Bootstrap stuck for 40s")
        CB.RecoverUntil, CB.WaitUntil = nil, now + 5000
        return true
    end
    if (Busy() and not hasBlockingControl())
        or (not LattyLib.QuestCore.running and not FFXIV_Common_BotRunning)
        or (MsqBootstrap.LastProfile ~= "msq" and MsqBootstrap.LastProfile ~= "job") then
        resetStuck()
        return false
    end
    if CB.Profile ~= MsqBootstrap.LastProfile then
        resetStuck()
        CB.Profile = MsqBootstrap.LastProfile
    end
    if CB.LastSample and now - CB.LastSample < 1000 then return false end
    CB.LastSample = now
    local pos = Player.pos
    local history = CB.History or {}
    CB.History = history
    -- Copy coordinates: Player.pos may be a mutable runtime object.
    history[#history + 1] = { x = pos.x, z = pos.z, at = now }
    while #history > 1 and history[1].at < now - 10000 do table.remove(history, 1) end
    local dx, dz = history[1].x - pos.x, history[1].z - pos.z
    if dx * dx + dz * dz > 4 then CB.StuckSince = nil
    elseif #history >= 2 then CB.StuckSince = CB.StuckSince or now end
    if CB.StuckSince and now - CB.StuckSince >= 40000 then
        resetStuck()
        log("Stationary for 40s; setting profile to none")
        MsqBootstrap.EnsureProfileEnabled("none")
        CB.RecoverUntil, CB.WaitUntil = now + 10000, now + 1000
        return true
    end
    return false
end

return CB
