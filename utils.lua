-- cherry picked from main repo. Only the essentials.
if NoobgamUtils == nil then
    NoobgamUtils = {}
end

local function log(msg)
    d("[NoobgamUtils] " .. msg)
end

---@param tbl table
---@param element any
---@return number|nil
function NoobgamUtils.findIndex(tbl, element)
    for i, value in pairs(tbl) do
        if value == element then
            return i
        end
    end
    return nil
end

--- @param botMode "Assist" | "Quest" | "Grind"
function NoobgamUtils.SwitchMode(botMode)
    log("Switching bot mode to " .. botMode)

    local botIndex = NoobgamUtils.findIndex(gBotModeList, botMode)
    if botIndex == nil then
        log("[ERROR] Cannot switch mode to " .. botMode .. ", is it in the list?")
        return
    end
    ffxivminion.SwitchMode(botMode)
    gBotMode = botMode
    gBotModeIndex = botIndex
end

function NoobgamUtils.SetQuestingProfile(profileName)
    ---@type string[]
    local allProfiles = Questing.profilesDisplay
    local idx = NoobgamUtils.findIndex(allProfiles, profileName)
    if idx ~= nil then
        log("Found profile index: " .. idx)
        gQuestProfileIndex = idx
        gQuestProfile = profileName

        Questing.UpdateSelection(profileName)
        return true
    else
        log("[ERROR] Could not find questing profile")
        return false
    end
end

--- @return string|nil
function NoobgamUtils.ExtractInviterName()
    local tooltip = GetControlStrings("SelectYesno", 2)
    if tooltip == nil then
        return nil
    end
    if tooltip:sub(1, 5) ~= "Join " then
        return nil
    end
    for i = 6, #tooltip do
        local char = string.sub(tooltip, i, i)
        local byte_val = string.byte(char)
        if byte_val > 126 or byte_val < 32 then
            return tooltip:sub(6, i - 1)
        end
    end
    return nil
end

--- @param path string
--- @return string content
function NoobgamUtils.ReadFile(path)
    local handle = io.open(path)

    if not handle then
        error("Could not open the file")
    end

    local result = handle:read("*a")
    handle:close()
    return result
end

return NoobgamUtils