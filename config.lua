if NoobgamConfigManager == nil then
    NoobgamConfigManager = {}
end

---@class BootstrapConfigPart
---@field type "msq"|"novice1"
---@field lvlThreshold? integer - whether to consider bootstrap done when reached specific level
---@field questThreshold? integer - whether to consider bootstrap done when quest is completed

---@class DynamicAccountConfig
---@field enabled boolean
---@field mode "Bootstrap"|"Ravana"|"Helper"
---@field useDutyFinder? boolean - whether to use duty finder for duties where helpers can't help you (for now only seat of sacrifice)
---@field useBlueQuestFilter? boolean - use the Blue Quests sub-rule while gathering aether currents
---@field questLevelCap? integer - Questing level option; defaults to 10
---@field msqTrialOptOuts? table<string, boolean> - unsupported MSQ trials the user opted out of
---@field bootstrapConfig? (BootstrapConfigPart[]|nil)

local folder = GetLuaModsPath() .. "SimpleFFXIVBotting\\configs\\"

--- @type DynamicAccountConfig
local defaultConfig = {
    enabled = false,
    mode="Bootstrap"
}

local function getStaticConfigPath()
    if not FolderExists(folder) then
        FolderCreate(folder)
    end
    return folder .. GetMinionAppUUID() .. ".json"
end

function NoobgamConfigManager.ReadConfig()
    local path = getStaticConfigPath()
    if not FileExists(path) then
        ---@diagnostic disable-next-line: param-type-mismatch
        FileWrite(path, json.encode(defaultConfig, { indent = 2 }))
        NoobgamConfigManager.Config = defaultConfig
        return defaultConfig
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    NoobgamConfigManager.Config = json.decode(NoobgamUtils.ReadFile(path))
    NoobgamConfigManager.Config.mode = NoobgamConfigManager.Config.mode

    return NoobgamConfigManager.Config
end

function NoobgamConfigManager.SaveConfig()
    local path = getStaticConfigPath()
    ---@diagnostic disable-next-line: param-type-mismatch
    FileWrite(path, json.encode(NoobgamConfigManager.Config, { indent = 2 }))
end

return NoobgamConfigManager