-- Run from the repository root: lua52 tests/test_skip_credits.lua
-- Offline stubs only; does not attach to a client or read/write account configs.
local tests = 0
local function test(name, run)
    run()
    tests = tests + 1
    print("ok - " .. name)
end

local function copy(value)
    local result = {}
    for key, item in pairs(value) do result[key] = item end
    return result
end

local savedConfig
GetLuaModsPath = function() return "unused/" end
GetMinionAppUUID = function() return "test" end
FolderExists = function() return true end
FileExists = function() return savedConfig ~= nil end
FileWrite = function(_, value) savedConfig = copy(value) end
NoobgamUtils = { ReadFile = function() return copy(savedConfig) end }
json = { encode = copy, decode = copy }
dofile("config.lua")

test("new configs default to skipping credits", function()
    local config = NoobgamConfigManager.ReadConfig()
    assert(config.skipCredits == true)
    assert(savedConfig.skipCredits == true)
end)

test("existing configs default to skipping credits without changing other settings", function()
    savedConfig = { enabled = true, mode = "Helper", useDutyFinder = true }
    local config = NoobgamConfigManager.ReadConfig()
    assert(config.skipCredits == true)
    assert(config.enabled and config.mode == "Helper" and config.useDutyFinder)
end)

test("explicit choices survive save and reload", function()
    for _, value in ipairs({ false, true }) do
        NoobgamConfigManager.Config.skipCredits = value
        NoobgamConfigManager.SaveConfig()
        assert(NoobgamConfigManager.ReadConfig().skipCredits == value)
    end
end)

local handlers = {}
RegisterEventHandler = function(event, callback) handlers[event] = callback end
FFXIV = { GAMESTATE = { INGAME = 1, MAINMENUSCREEN = 0 } }
local gameState, now, busy, handoff
local controls, destroyed, modeUpdates
MGetGameState = function() return gameState end
GetTickCount = function() return now end
d = function() end
local function modeUpdate() modeUpdates = modeUpdates + 1 end
MsqBootstrap = { HoldLattyDungeonHandoff = function() return handoff end, Update = modeUpdate, Reset = function() end }
RavanaFarm = { Update = modeUpdate, Reset = function() end }
MsqClearHelper = { HostUpdate = modeUpdate, Reset = function() end }
NoobgamTaskManager = { Update = function() return busy end }
IsControlOpen = function(name) return controls[name] and controls[name].open or false end
GetControlByName = function(name) return controls[name] end
dofile("main.lua")
local update = handlers["Gameloop.Update"]
local creditNames = { "CreditPlayer", "CreditEnd", "CreditScroll", "Credit" }

local function open(name)
    controls[name] = {
        open = true,
        IsOpen = function(self) return self.open end,
        Destroy = function(self)
            destroyed[name] = (destroyed[name] or 0) + 1
            self.open = false
        end,
    }
end

local function reset()
    gameState, now, busy, handoff = 1, 0, false, false
    controls, destroyed, modeUpdates = {}, {}, 0
    NoobgamConfigManager.Config = { enabled = false, skipCredits = true, mode = "Bootstrap" }
    update() -- Clear any timers left over from the previous test.
    NoobgamConfigManager.Config.enabled = true
end

test("only the four credit controls are destroyed, after 2.5 seconds", function()
    reset()
    for _, name in ipairs(creditNames) do open(name) end
    open("SomeOtherCutscene")
    update()
    now = 2499
    update()
    assert(next(destroyed) == nil)
    now = 2500
    update()
    for _, name in ipairs(creditNames) do assert(destroyed[name] == 1, name) end
    assert(destroyed.SomeOtherCutscene == nil)
    assert(modeUpdates == 3)
end)

test("each credit control has its own timer", function()
    reset()
    open("CreditPlayer")
    update()
    now = 2000
    open("CreditEnd")
    update()
    now = 2500
    update()
    assert(destroyed.CreditPlayer == 1 and destroyed.CreditEnd == nil)
    now = 4500
    update()
    assert(destroyed.CreditEnd == 1)
end)

test("closing and reopening a credit control restarts the delay", function()
    reset()
    open("Credit")
    update()
    now = 2000
    controls.Credit.open = false
    update()
    now = 3000
    open("Credit")
    update()
    now = 5499
    update()
    assert(next(destroyed) == nil)
    now = 5500
    update()
    assert(destroyed.Credit == 1)
end)

for _, gate in ipairs({ "option", "addon", "game state" }) do
    test(gate .. " gates destruction and resets the delay", function()
        reset()
        open("Credit")
        update()
        now = 2000
        if gate == "option" then NoobgamConfigManager.Config.skipCredits = false
        elseif gate == "addon" then NoobgamConfigManager.Config.enabled = false
        else gameState = 0 end
        update()
        now = 10000
        update()
        assert(next(destroyed) == nil)
        NoobgamConfigManager.Config.skipCredits = true
        NoobgamConfigManager.Config.enabled = true
        gameState = 1
        update()
        assert(next(destroyed) == nil)
        now = 12500
        update()
        assert(destroyed.Credit == 1)
    end)
end

test("credits are processed in every mode even during task or handoff waits", function()
    for _, mode in ipairs({ "Bootstrap", "Helper", "Ravana" }) do
        for _, waitType in ipairs({ "task", "handoff" }) do
            reset()
            NoobgamConfigManager.Config.mode = mode
            busy, handoff = waitType == "task", waitType == "handoff"
            open("Credit")
            update()
            now = 2500
            update()
            assert(destroyed.Credit == 1)
            assert(modeUpdates == 0)
        end
    end
end)

test("a control disappearing between lookup and action is harmless", function()
    reset()
    open("Credit")
    update()
    local lookup = GetControlByName
    GetControlByName = function() return nil end
    now = 2500
    update()
    assert(next(destroyed) == nil)
    GetControlByName = lookup
    update()
    assert(destroyed.Credit == 1)
end)

local checkboxSeen, checkboxChoice
IsGUIVisible = function() return true end
GUI = setmetatable({
    Begin = function() return true, true end,
    BeginTabBar = function() return true end,
    BeginTabItem = function(_, name) return name == "Settings" end,
    Combo = function(_, _, current) return current, false end,
    SliderInt = function(_, _, current) return current, false end,
    Checkbox = function(_, name, current)
        if name == "Skip credits" then
            checkboxSeen = current
            if checkboxChoice ~= nil then return checkboxChoice, true end
        end
        return current, false
    end,
}, { __index = function() return function() end end })
dofile("gui.lua")

test("the shared Settings checkbox defaults on and persists opt-out in every mode", function()
    for _, mode in ipairs({ "Bootstrap", "Helper", "Ravana" }) do
        NoobgamConfigManager.Config = { enabled = false, mode = mode }
        checkboxSeen, checkboxChoice = nil, nil
        GUI_Manager.Draw()
        assert(checkboxSeen == true)
        checkboxChoice = false
        GUI_Manager.Draw()
        assert(NoobgamConfigManager.Config.skipCredits == false)
        assert(savedConfig.skipCredits == false)
        checkboxSeen, checkboxChoice = nil, nil
        GUI_Manager.Draw()
        assert(checkboxSeen == false)
    end
end)

print(string.format("Passed %d tests", tests))
