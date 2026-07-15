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

local function decStringToHex32(dec)
  dec = tostring(dec):gsub("^0+", "")
  if dec == "" then return ("0"):rep(32) end

  local hex = {}
  while dec ~= "0" do
    local rem, out, started = 0, {}, false
    for i = 1, #dec do
      local n = rem * 10 + (dec:byte(i) - 48)
      local q = math.floor(n / 16)
      rem = n % 16
      if q ~= 0 or started then
        out[#out+1] = string.char(48 + q)
        started = true
      end
    end
    hex[#hex+1] = string.format("%x", rem)
    dec = started and table.concat(out) or "0"
  end

  local s = table.concat(hex):reverse()
  return string.rep("0", 32 - #s) .. s
end

function NoobgamUtils.GetMyAlliance()
    local allAlliances = { "A", "B", "C" }
    local visibleAlliances = {}

    for i = 1, 2 do
        local str = GetControlStrings("_AllianceList" .. i, 2)
        if str ~= nil and str ~= "" then
            local letter = str:match("Alliance (%a)")
            if letter then
                visibleAlliances[letter] = true
            end
        end
    end

    for _, letter in ipairs(allAlliances) do
        if not visibleAlliances[letter] then
            return letter
        end
    end

    return nil
end

function NoobgamUtils.GetMinionAppUUIDHex()
    local decStr = GetMinionAppUUID()
    if decStr == nil then
        error("GetMinionAppUUID() returned nil")
    end
    return decStringToHex32(decStr)
end

function NoobgamUtils.shim_d(log_path)
    local original = original_d or d
    if original_d == nil then
        log("Shimming _G.d to write to " .. log_path)
    else
        log("Moving the shim d to " .. log_path)
    end
    original_d = original

    local function new_d(message)
        if message == nil then
            return
        end
        local status, err = pcall(function()
            local messageContent
            if type(message) == "table" then
                messageContent = json.encode(message)
            else
                messageContent = tostring(message or "<nil>")
            end

            local t = os.date("*t")
            local timestamp = string.format(
                "%04d-%02d-%02d %02d:%02d:%02d",
                t.year, t.month, t.day,
                t.hour, t.min, t.sec
            )

            local line = string.format("[%s] %s\n", timestamp, messageContent)
            FileWrite(log_path, line, true)
        end)
        if not status then
            original_d('[ERROR] Something weird was attempted to be written. Shim ignored. ' .. err)
        end

        original_d(message)
    end

    d = new_d
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

---@param entity Entity
---@param buff_id number
---@return boolean whether buff exists
function NoobgamUtils.hasBuff(entity, buff_id)
    for _, buff in pairs(entity.buffs) do
        if buff.id == buff_id then
            return true
        end
    end
    return false
end

function NoobgamUtils.PickClosestExit()
    return NoobgamUtils.PickFirstEntity("contentid=2006235;2000139;2000370;2000370;2000275;2001610;2001871;2000683;2000605;2000788;2000596;2001161;2000493,maxdistance=75,targetable")
end

--- Calculates the 2D distance between two positions.
--- @param start Position The starting position
--- @param finish Position The ending position
--- @return number The 2D distance between the start and finish positions
function NoobgamUtils.calculateDist(start, finish)
    return math.distance2d(start.x, start.z, finish.x, finish.z)
end

--- @return Entity|nil
function NoobgamUtils.PickFirstEntity(query)
    local entities = EntityList(query)
    for _, enemy in pairs(entities) do
        return enemy
    end
    return nil
end

return NoobgamUtils