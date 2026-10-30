---@diagnostic disable: undefined-doc-param, missing-return
---@diagnostic disable: lowercase-global
--- Editor-only declarations: never load/execute this file in the game.
--- Placeholder values are not runtime defaults. Optional addon/profile globals
--- may be nil until their owner loads.

--- @class MLNavigation
--- @field HasPath fun(self: MLNavigation): boolean whether navigation currently has a path selected
--- @field ClearInteractActionHandoff fun(self: MLNavigation)
--- @field ClearNavigationHandoff fun(self: MLNavigation, kind?: string)
--- @field ResetCurrentPath fun(self: MLNavigation)
--- @field DisablePathing fun(self: MLNavigation): boolean
--- @field EnablePathing fun(self: MLNavigation): boolean
--- @field path Position[] this type is not true, in reality it's a lot further
ml_navigation = {}

--- @class MLGlobalInformation
--- @field DrawLoginHandler function
--- @field DrawMiniButtons function

ml_global_information = {}

--- Enables or disables profile in FFXIVMinion (quest/assist/gathering etc)
function ml_global_information.ToggleRun()
end

--- @class FFXIVMinion
--- @field DutyCurrentData table no idea what this is
--- @field GUI table some nested table with windows
--- @field AetherCurrentData table<integer, table<integer, boolean>> mapId -> current slot -> attuned. Populated from Player:GetAetherCurrentsList() by e_getCurrentInfo CNE (requires the AetherCurrent window to be open) and by TaskManager attuneCurrents.
ffxivminion = {}

-- --- @param botMode "Assist" | "Quest" | "Grind"
--- @param botMode string
function ffxivminion.SwitchMode(botMode)
end

--- @class GUI
--- @field WindowFlags_NoTitleBar number
--- @field WindowFlags_NoResize number
--- @field WindowFlags_NoMove number
--- @field WindowFlags_NoScrollbar number
--- @field WindowFlags_NoCollapse number
--- @field WindowFlags_NoBringToFrontOnFocus number
--- @field InputTextFlags_CharsDecimal number
--- @field InputTextFlags_CharsHexadecimal number
--- @field InputTextFlags_CharsUppercase number
--- @field ColorEditMode_NoAlpha number
--- @field ColorEditMode_NoOptions number
--- @field ColorEditFlags_NoPicker nil
--- @field SetCond_Always number
--- @field SetCond_Once number
--- @field SetCond_FirstUseEver number
--- @field SetCond_Appearing number
--- @field StyleVar_WindowPadding number
GUI = {}

--- Create a combo box (drop-down selection)
--- @param self GUI
--- @param label string The label of the combo
--- @param current_item integer The index of the current selected item (1-based)
--- @param items string[] The list of selectable items
--- @param popup_max_height_in_items? integer Maximum number of items to display (optional)
--- @return integer new_index The newly selected index (1-based)
--- @return boolean changed True if the selection changed
function GUI:Combo(label, current_item, items, popup_max_height_in_items) end

--- @param self GUI
--- @param label string
--- @return boolean wither the header is open
function GUI:CollapsingHeader(label) end


--- @param self GUI
--- @param label string
--- @param reason boolean
--- @return boolean wither the header is open
function GUI:RadioButton(label, reason) end


--- Creates a slider for two float values.
--- @param self GUI
--- @param label string The label for the slider.
--- @param value1 number The initial value for the first slider.
--- @param value2 number The initial value for the second slider.
--- @param min number The minimum value for both sliders.
--- @param max number The maximum value for both sliders.
--- @return number value1 The updated value for the first slider.
--- @return number value2 The updated value for the second slider.
--- @return boolean changed Whether the slider values were changed.
function GUI:SliderFloat2(label, value1, value2, min, max) end

--- Creates a slider for three float values.
--- @param self GUI
--- @param label string The label for the slider.
--- @param value1 number The initial value for the first slider.
--- @param value2 number The initial value for the second slider.
--- @param value3 number The initial value for the third slider.
--- @param min number The minimum value for all sliders.
--- @param max number The maximum value for all sliders.
--- @return number value1 The updated value for the first slider.
--- @return number value2 The updated value for the second slider.
--- @return number value3 The updated value for the third slider.
--- @return boolean changed Whether the slider values were changed.
function GUI:SliderFloat3(label, value1, value2, value3, min, max) end

--- Creates a slider for an angle value.
--- @param self GUI
--- @param label string The label for the slider.
--- @param value number The initial value for the angle slider.
--- @param min number The minimum angle value (in degrees).
--- @param max number The maximum angle value (in degrees).
--- @return number value The updated value for the angle slider.
--- @return boolean changed Whether the angle value was changed.
function GUI:SliderAngle(label, value, min, max) end

--- Create an integer slider
--- @param self GUI
--- @param label string Label for the slider
--- @param value integer The current slider value
--- @param min integer Minimum allowed value
--- @param max integer Maximum allowed value
--- @return integer new_value The new slider value
--- @return boolean changed True if the value was changed by the user
function GUI:SliderInt(label, value, min, max) end

--- Start putting everything on the same line
--- @param self GUI
--- @param local_pos_x number|nil The name of the window
--- @param local_spacing_w number|nil Whether the window is open
function GUI:SameLine(local_pos_x, local_spacing_w) end

--- Set the width of a specific column in a multi-column layout
--- @param self GUI
--- @param column_index integer The index of the column (0-based)
--- @param width number The width to set for the column
function GUI:SetColumnWidth(column_index, width) end

--- Open tab bar
--- @param self GUI
--- @param barName string
--- @return boolean whether this tab is selected
function GUI:BeginTabBar(barName) end

--- Close tab bar
--- @param self GUI
function GUI:EndTabBar() end

--- Begin a tab item within an active GUI draw context.
--- @param self GUI
--- @param tabName string Tab label.
--- @param someFlag boolean Open flag; existing callers pass true.
--- @param imguiFlags integer Tab-item flags.
--- @return boolean whether this tab is selected
function GUI:BeginTabItem(tabName, someFlag, imguiFlags) end

--- End the current tab item.
--- @param self GUI
function GUI:EndTabItem() end

--- End a child window that was started with BeginChild
--- @param self GUI
function GUI:EndChild() end

--- Get the position of the current window
--- @param self GUI
--- @return number x The X coordinate of the window (screen space)
--- @return number y The Y coordinate of the window (screen space)
function GUI:GetWindowPos() end

--- Get the size of the current ImGUI window
--- @param self GUI
--- @return number width The width of the window in pixels
--- @return number height The height of the window in pixels
function GUI:GetWindowSize() end

--- Get the size of the current window
--- @param self GUI
--- @return number width The width of the window in pixels
--- @return number height The height of the window in pixels
function GUI:GetScreenSize() end

--- Add an image at the given screen coordinates
--- @param self GUI
--- @param texturePath string Path to the image file (e.g., "Assets/logo.png")
--- @param x1 number Top-left X coordinate on screen
--- @param y1 number Top-left Y coordinate on screen
--- @param x2 number Bottom-right X coordinate on screen
--- @param y2 number Bottom-right Y coordinate on screen
function GUI:AddImage(texturePath, x1, y1, x2, y2) end

--- Begin a child window with specified parameters
--- @param self GUI
--- @param str_id string Unique identifier for the child window
--- @param size_x number Width of the child window (0 for auto-size)
--- @param size_y number Height of the child window (0 for auto-size)
--- @param border? boolean Whether to draw a border around the child window (optional, defaults to false)
--- @param flags? integer Additional window flags (optional)
--- @return boolean Returns true if the child window is visible and should be drawn
function GUI:BeginChild(str_id, size_x, size_y, border, flags) end

--- Pop/restore the last pushed style color from the style color stack
--- @param self GUI
--- @param count? integer Number of colors to pop (optional, defaults to 1)
function GUI:PopStyleColor(count) end

--- Pop/restore the last pushed style var
--- @param self GUI
--- @param count? integer Number of colors to pop (optional, defaults to 1)
function GUI:PopStyleVar(count) end

--- Push a style color onto the style color stack to temporarily change GUI colors
--- @param self GUI
--- @param style_color integer The GUI color style to modify (e.g., GUI.Col_Text, GUI.Col_Button, etc.)
--- @param r number Red component (0.0 to 1.0)
--- @param g number Green component (0.0 to 1.0)
--- @param b number Blue component (0.0 to 1.0)
--- @param a number Alpha component (0.0 to 1.0)
function GUI:PushStyleColor(style_color, r, g, b, a) end


--- Push a style variable onto the stack
--- @param self GUI
--- @param styleVar integer The style variable identifier (use GUI.StyleVar_*)
--- @param valueX number First value (for scalar vars: X, for 2D vars: width)
--- @param valueY number|nil Optional second value (for 2D style vars, e.g. padding)
function GUI:PushStyleVar(styleVar, valueX, valueY) end

--- Set the next window position before calling GUI:Begin
--- @param self GUI
--- @param x number The X coordinate in screen space
--- @param y number The Y coordinate in screen space
--- @param condition integer One of GUI.SetCond_* (controls when the position is applied)
function GUI:SetNextWindowPos(x, y, condition) end

--- Draw an image widget inside the current window
--- @param self GUI
--- @param filepath string Path to the texture file
--- @param width number Image display width in pixels
--- @param height number Image display height in pixels
--- @param uv0_x number|nil UV coordinate 0 (default = 0.0)
--- @param uv0_y number|nil UV coordinate 0 (default = 0.0)
--- @param uv1_x number|nil UV coordinate 1 (default = 1.0)
--- @param uv1_y number|nil UV coordinate 1 (default = 1.0)
--- @param bg_col_R number|nil Background color R (default = 0)
--- @param bg_col_G number|nil Background color G (default = 0)
--- @param bg_col_B number|nil Background color B (default = 0)
--- @param bg_col_A number|nil Background color Alpha (default = 0)
--- @param tint_col_R number|nil Tint color R (default = 1.0)
--- @param tint_col_G number|nil Tint color G (default = 1.0)
--- @param tint_col_B number|nil Tint color B (default = 1.0)
--- @param tint_col_A number|nil Tint color Alpha (default = 1.0)
function GUI:Image(filepath, width, height,
    uv0_x, uv0_y, uv1_x, uv1_y,
    bg_col_R, bg_col_G, bg_col_B, bg_col_A,
    tint_col_R, tint_col_G, tint_col_B, tint_col_A) end

--- GUI Color Style Constants
--- These are used with PushStyleColor to modify the appearance of GUI elements

--- Text color
--- @type integer
GUI.Col_Text = nil

--- Disabled text color
--- @type integer
GUI.Col_TextDisabled = nil

--- Window background color
--- @type integer
GUI.Col_WindowBg = nil

--- Child window background color
--- @type integer
GUI.Col_ChildWindowBg = nil

--- Popup background color
--- @type integer
GUI.Col_PopupBg = nil

--- Border color
--- @type integer
GUI.Col_Border = nil

--- Border shadow color
--- @type integer
GUI.Col_BorderShadow = nil

--- Frame background color (for input fields, checkboxes, etc.)
--- @type integer
GUI.Col_FrameBg = nil

--- Frame background color when hovered
--- @type integer
GUI.Col_FrameBgHovered = nil

--- Frame background color when active
--- @type integer
GUI.Col_FrameBgActive = nil

--- Title bar background color
--- @type integer
GUI.Col_TitleBg = nil

--- Title bar background color when active
--- @type integer
GUI.Col_TitleBgActive = nil

--- Title bar background color when collapsed
--- @type integer
GUI.Col_TitleBgCollapsed = nil

--- Menu bar background color
--- @type integer
GUI.Col_MenuBarBg = nil

--- Scrollbar background color
--- @type integer
GUI.Col_ScrollbarBg = nil

--- Scrollbar grab color
--- @type integer
GUI.Col_ScrollbarGrab = nil

--- Scrollbar grab color when hovered
--- @type integer
GUI.Col_ScrollbarGrabHovered = nil

--- Scrollbar grab color when active
--- @type integer
GUI.Col_ScrollbarGrabActive = nil

--- Checkbox/radio button check mark color
--- @type integer
GUI.Col_CheckMark = nil

--- Slider grab color
--- @type integer
GUI.Col_SliderGrab = nil

--- Slider grab color when active
--- @type integer
GUI.Col_SliderGrabActive = nil

--- Button color
--- @type integer
GUI.Col_Button = nil

--- Button color when hovered
--- @type integer
GUI.Col_ButtonHovered = nil

--- Button color when active/pressed
--- @type integer
GUI.Col_ButtonActive = nil

--- Header color (for collapsing headers, tree nodes, etc.)
--- @type integer
GUI.Col_Header = nil

--- Header color when hovered
--- @type integer
GUI.Col_HeaderHovered = nil

--- Header color when active
--- @type integer
GUI.Col_HeaderActive = nil

--- Separator color
--- @type integer
GUI.Col_Column = nil

--- Separator color when hovered
--- @type integer
GUI.Col_ColumnHovered = nil

--- Separator color when active
--- @type integer
GUI.Col_ColumnActive = nil

--- Resize grip color
--- @type integer
GUI.Col_ResizeGrip = nil

--- Resize grip color when hovered
--- @type integer
GUI.Col_ResizeGripHovered = nil

--- Resize grip color when active
--- @type integer
GUI.Col_ResizeGripActive = nil

--- Modern ImGui tab colors below are not exposed by this Minion GUI binding.
--- Kept as explicit nil declarations, not usable PushStyleColor constants.
--- @deprecated
--- @type nil
GUI.Col_Tab = nil

--- @deprecated
--- @type nil
GUI.Col_TabHovered = nil

--- @deprecated
--- @type nil
GUI.Col_TabActive = nil

--- @deprecated
--- @type nil
GUI.Col_TabUnfocused = nil

--- @deprecated
--- @type nil
GUI.Col_TabUnfocusedActive = nil

--- Plot lines color
--- @type integer
GUI.Col_PlotLines = nil

--- Plot lines color when hovered
--- @type integer
GUI.Col_PlotLinesHovered = nil

--- Plot histogram color
--- @type integer
GUI.Col_PlotHistogram = nil

--- Plot histogram color when hovered
--- @type integer
GUI.Col_PlotHistogramHovered = nil

--- Text selection background color
--- @type integer
GUI.Col_TextSelectedBg = nil

--- Drag and drop target color
--- @type integer
GUI.Col_DragDropTarget = nil

--- Navigation highlight color
--- @type integer
GUI.Col_NavHighlight = nil

--- Navigation windowing highlight color
--- @type integer
GUI.Col_NavWindowingHighlight = nil

--- @deprecated
--- @type nil
GUI.Col_NavWindowingDimBg = nil

--- Modal window dim background color
--- @type integer
GUI.Col_ModalWindowDarkening = nil

--- Memoized casting check; wrapper source takes an optional fullcheck flag.
--- @param fullcheck boolean|nil
--- @return boolean
function MIsCasting(fullcheck)
end

--- Stop putting everything on the same line
--- @param self GUI
function GUI:NewLine() end

--- Show line separator
--- @param self GUI
function GUI:Separator() end

---@param count integer Number of columns
---@param id? string Unique identifier for the column set (optional)
---@param border? boolean Whether to draw borders between columns (optional, defaults to true)
function GUI:Columns(count, id, border) end

--- Stop putting everything on the same line
--- @param self GUI
function GUI:NextColumn() end

--- Begin a new window
--- @param self GUI
--- @param name string The name of the window
--- @param open boolean Whether the window is open
--- @param flags? number|nil Optional window flags
--- @return boolean visible Whether the window is visible (not collapsed)
--- @return boolean open Whether the window is still open
function GUI:Begin(name, open, flags) end

--- @param x number
--- @param y number
--- @param flags number SetCondFlags
function GUI:SetNextWindowSize(x, y, flags)
end

--- End the current window
--- @param self GUI
function GUI:End() end

--- Set the width of the next item
--- @param self GUI
--- @param width number The width to set for the next item
function GUI:PushItemWidth(width) end

--- Set the width of the next item
--- @param self GUI
function GUI:PopItemWidth() end

--- Convert RGBA float values to a 32-bit unsigned integer color
--- @param self GUI
--- @param r number Red component (0 to 1)
--- @param g number Green component (0 to 1)
--- @param b number Blue component (0 to 1)
--- @param a number Alpha component (0 to 1)
--- @return number color The 32-bit unsigned integer representing the color
function GUI:ColorConvertFloat4ToU32(r, g, b, a) end

--- Display a label and associated text
--- @param self GUI
--- @param label string The label text
--- @param text string The associated value to display
function GUI:LabelText(label, text) end

--- Create a button
--- @param self GUI
--- @param label string The label of the button
--- @param sizeX number|nil Optional width of the button
--- @param sizeY number|nil Optional height of the button
--- @return boolean clicked Whether the button was clicked
function GUI:Button(label, sizeX, sizeY) end

--- Create a small button
--- @param self GUI
--- @param label string The label of the button
--- @return boolean clicked Whether the button was clicked
function GUI:SmallButton(label, sizeX, sizeY) end

--- Display text
--- @param self GUI
--- @param text string The text to display
function GUI:Text(text) end

--- Create an input text field
--- @param self GUI
--- @param label string The label of the input field
--- @param text string The current text in the field
--- @param flags number|nil Optional input text flags
--- @return string text The updated text
--- @return boolean changed Whether the text was changed
function GUI:InputText(label, text, flags) end

--- Create a checkbox
--- @param self GUI
--- @param label string The label of the checkbox
--- @param checked boolean The current state of the checkbox
--- @return boolean checked The updated state of the checkbox
--- @return boolean pressed Whether the checkbox was pressed
function GUI:Checkbox(label, checked) end

--- Select an item from a list.
--- @param self GUI
--- @param label string
--- @param current_listitem_index integer Selected 1-based index.
--- @param itemlist string[]
--- @param height_in_items integer
--- @return integer selectedIndex
--- @return boolean changed
function GUI:ListBox(label, current_listitem_index, itemlist, height_in_items) end


FFXIV = {}

FFXIV.JOBS = {
    ADVENTURER = 0,
    GLADIATOR = 1,
    PUGILIST = 2,
    MARAUDER = 3,
    LANCER = 4,
    ARCHER = 5,
    CONJURER = 6,
    THAUMATURGE = 7,
    CARPENTER = 8,
    BLACKSMITH = 9,
    ARMORER = 10,
    GOLDSMITH = 11,
    LEATHERWORKER = 12,
    WEAVER = 13,
    ALCHEMIST = 14,
    CULINARIAN = 15,
    MINER = 16,
    BOTANIST = 17,
    FISHER = 18,
    PALADIN = 19,
    MONK = 20,
    WARRIOR = 21,
    DRAGOON = 22,
    BARD = 23,
    WHITEMAGE = 24,
    BLACKMAGE = 25,
    ARCANIST = 26,
    SUMMONER = 27,
    SCHOLAR = 28,
    ROGUE = 29,
    NINJA = 30,
    MACHINIST = 31,
    DARKKNIGHT = 32,
    ASTROLOGIAN = 33,
    SAMURAI = 34,
    REDMAGE = 35,
    BLUEMAGE = 36,
    GUNBREAKER = 37,
    DANCER = 38,
    REAPER = 39,
    SAGE = 40,
    VIPER = 41,
    PICTOMANCER = 42,
    BEASTMASTER = 43
}
FFXIV.GAMESTATE = {
	CHARACTERSCREEN = 1,
	ERROR = 4,
	INGAME = 3,
	MAINMENUSCREEN = 2,
}


---@return string path to mods
function GetLuaModsPath()
	return ""
end

--- Returns true for a file, false for a missing path or a directory.
---@param path string
---@return boolean
function FileExists(path)
	return true
end

---@param path string
---@param var any lua object to store
function FileSave(path, var)
end

---@param path string
---@return any return value of the file saved with FileSave
function FileLoad(path)
	return {}
end

---@param confirm boolean
function PressYesNo(confirm)
end

--- @param event string Event name to listen for
--- @param handler function The function to call when the event is triggered
--- @param identifier string A unique identifier for this event registration
function RegisterEventHandler(event, handler, identifier)
    -- This is just a placeholder for the editor
end

--- Console logger; active addons may wrap this function.
--- @param message any
function d(message)

end

--- Single-buff helper: minimum stacks/duration; 0 ignores
--- that filter. Accepts an entity proxy or entity ID.
--- @param entity Entity|Player|number
--- @param buff_id number
--- @param stacks number|nil
--- @param duration number|nil
--- @param ownerid number|nil
--- @return boolean
function HasBuff(entity, buff_id, stacks, duration, ownerid)
    return false
end

--- @return Entity | nil returns your chocobo
function GetCompanionEntity()
end

--- Buff expression: comma = OR, plus = AND, e.g. "10+20,30".
--- Nonzero stacks requires an exact match; duration is a minimum threshold.
--- @param entity Entity|Player
--- @param buffs string|number
--- @param duration number|nil
--- @param ownerid number|nil
--- @param stacks number|nil
--- @return boolean
function HasBuffs(entity, buffs, duration, ownerid, stacks)
end

--- Missing-buff expression: true if a comma-separated group has ALL its
--- plus-separated buffs absent. This is not simply `not HasBuffs(...)`.
--- @param entity Entity|Player
--- @param buffs string|number
--- @param duration number|nil
--- @param ownerid number|nil
--- @param stacks number|nil
--- @return boolean
function MissingBuffs(entity, buffs, duration, ownerid, stacks)
end

--- @class EorzeaTime
--- @field servertime number
--- @field year number
--- @field moon number
--- @field sun number
--- @field bell number
--- @field minute number

--- Returns the current Eorzea time.
--- @return EorzeaTime
function GetEorzeaTime()
end

--- @param table table
--- @return integer size of the table
function table.size(table)
    -- This is just a placeholder for the editor
    return 1
end

--- Returns false for nil, false, and empty tables.
--- @param table any
--- @return boolean True if the table is valid, false otherwise
function table.valid(table)
    -- This is just a placeholder for the editor
    return table ~= nil and next(table) ~= nil
end

--- Global object `Duty`.
--- @class DutyClass
Duty = {}

--- Join duty by type and id. See dev tools
--- @param type integer type of duty
--- @param id integer duty id (not map id)
function Duty:JoinDuty(type, id)
end

--- @class DutyObjective
--- @field completed boolean
--- @field name string
--- @field type integer
--- @field values table

--- @return table<number, DutyObjective>|nil Nil when outside a duty.
function Duty:GetActiveDutyObjectives()
end

--- Get the active queue status
--- @return number queue status id. 4 - in dungeon, 3 - commence, 0 - nothing
function Duty:GetQueueStatus()
    -- This is just a placeholder for the editor
    return 3
end

---@class ActiveDutyInfo
---@field timer number The remaining time for the duty
---@field dutytype number The internal ID/type of the duty
---@field name string The display name of the duty
---@field dutystep number The current progression step

--- Get the active duty info.
--- @return ActiveDutyInfo|nil info Nil when outside a duty.
function Duty:GetActiveDutyInfo()
    -- This is just a placeholder for the editor
    return {
        timer = 0,
        dutytype = 0,
        name = "",
        dutystep = 0
    }
end

---@class DutyInfo
--- @field id number Duty ID
--- @field type number Duty type
--- @field name string Duty name
--- @field mapid number Map ID
--- @field requiredlevel number Required level to join
--- @field synclevel number Level sync
--- @field partysize number Required party size
--- @field canjoin boolean Whether player can currently join
--- @field completed boolean Whether duty was completed before

--- Gets a list of all duties available to the player
--- @return table<number, DutyInfo> Numeric lookup keys are NOT generally row.id.
function Duty:GetCompleteDutyList() end

--- Casting data can be an empty table on NPCs/objects; guard its fields.
--- ```lua
--- local target = Player:GetTarget()
--- local cast = target and target.castinginfo
--- if cast and (cast.channelingid or 0) ~= 0 then
---     local remaining = math.max(0, (cast.casttime or 0) - (cast.channeltime or 0))
---     d(tostring(remaining))
--- end
--- ```
--- @class CastingInfo
--- @field ptr number|nil Can be 0; not a validity check.
--- @field castingid number|nil Executing action ID; transient, including instant actions. 0 when idle.
--- @field casttime number|nil Total cast duration in seconds while channeling.
--- @field castingtargetcount number|nil Reported target count.
--- @field castinginterruptible boolean|nil
--- @field castingtargets table<number, number>|nil Numeric target IDs, NOT names/strings.
--- @field lastcastid number|nil Reported last action ID.
--- @field timesincecast number|nil Milliseconds since cast activity; resets during action transitions.
--- @field channelingid number|nil Reported channel action ID.
--- @field channelingtype number|nil Channel type code.
--- @field channeltargetid integer|nil Reported channel target ID.
--- @field channeltime number|nil Elapsed channel time in seconds; counts up toward casttime.

--- @class Buff
--- @field ptr number The memory pointer to the buff data.
--- @field ptr2 number A secondary memory pointer to the buff data.
--- @field id number The unique identifier for the buff.
--- @field duration number Remaining seconds; 0 can represent an indefinite status.
--- @field name string The name of the buff.
--- @field ownerid number The ID of the entity that applied the buff.
--- @field isbuff boolean Whether this is a buff (true) or a debuff (false).
--- @field isdebuff boolean Whether this is a debuff (true) or a buff (false).
--- @field stacks number Raw status parameter, not always a simple stack count.
--- @field slot number The slot index of the buff.
--- @field dispellable boolean Whether the buff is dispellable.

--- @class FlyingInfo
--- @field isflying boolean
--- @field canflyinzone boolean
--- @field pitch number

--- The GLOBAL Player proxy only, NOT arbitrary type=1 entries from EntityList.
--- Even EntityList:Get(Player.id) lacks levels/localmapid/gauge/grandcompany,
--- flying and GetSyncLevel. Use the global Player for these local-client fields.
--- @class Player : Entity
--- @field job number The job or class of the player (represented by an ID).
--- @field pvpteam number The PvP team of the player.
--- @field castinginfo CastingInfo The casting information for the player.
--- @field grandcompany number The grand company affiliation of the player.
--- @field grandcompanyrank number The rank within the grand company.
--- @field aggro boolean Player-proxy aggro flag; use EntityList("aggro") to find threatening entities.
--- @field aggropercentage number The percentage of aggro the player has.
--- @field hasaggro boolean Player-proxy aggro flag; use EntityList("targetingme") for current attackers.
--- @field mp BarData
--- @field gp BarData
--- @field levels table<integer, integer> jobid to level (does not include sync)
--- @field mp.percent number The mana of the party member as a percentage.
--- @field revivestate number The state of revival (e.g., alive, dead, reviving).
--- @field role number The role of the player in a party (e.g., tank, healer, DPS).
--- @field cangather boolean Whether the player can gather resources (specific to gathering jobs).
--- @field spearfishstate number The state related to spearfishing (specific to fishing).
--- @field marker number Numeric marker value.
--- @field gauge table<integer, number> gauge information
--- @field localmapid integer current map id
--- @field mapid integer current map id
--- @field onlinestatus number The online status of the player (e.g., online, offline).
--- @field currentworld integer The current world (server) the player is in.
--- @field homeworld integer The home world (server) of the player.
--- @field guid string The player GUID; preserve as a string.
--- @field lastcomboid integer Last action in the current combo.
--- @field combotimeremain number Seconds remaining in the combo window.
--- @field flying FlyingInfo
--- @field ilvl number current ilvl of the chracter 
--- @field mountid integer
--- @field status integer
Player = {}

--- Does not identify the FATE the player is participating in.
--- Use GetFateList() for FATE data and Entity.fateid for associated enemies.
--- @deprecated
--- @type integer
Player.fateid = 0

--- @type integer
--- Max level difference to pick up side quests
QuestOpts_C_v1_Level = 3

--- Coordinates and rotation structure.
--- @class PlayerPosition : Position
--- @field h number Rotation (heading)
Player.pos = {x = 0, y = 0, z = 0, h = 0}

--- @return integer
function Player:GetFishingState()
end

--- @return integer Synced level, or 0 when not level-synced.
function Player:GetSyncLevel()
end

--- @param npcId integer entity.id of the target
function Player:Interact(npcId)
end

--- @return table<number, Aetheryte>
function Player:GetAetheryteList()
end

--- @param aetheryteId integer entity.id of the target
function Player:Teleport(aetheryteId) end

--- @return Entity|nil targeted entity
function Player:GetTarget() end

--- Attunement status of aether currents per map, read from game memory.
--- Only reliable while the "AetherCurrent" window is (or was recently) open,
--- see e_getCurrentInfo in ffxiv_common_cne.lua.
--- @return table<integer, { mapid: integer, isattuned: boolean, status: table<integer, boolean> }> keyed by mapId
function Player:GetAetherCurrentsList() end

--- Clears the target.
--- @return Entity|nil
function Player:ClearTarget() end

--- @param statId number entity
--- @return integer
function Player:GetStats(statId) end

--- Move to point or target, one of args must be non-nil
--- @param x number
--- @param y number
--- @param z number
--- @param radius number|nil
--- @param floorfilters number|nil
--- @param cubefilters number|nil
--- @param targetid number|nil
function Player:MoveTo(x, y, z, radius, floorfilters, cubefilters, targetid)
end

function Player:SetSpeed(arg, run, backwards, strafe, walk)
end

function Player:ResetSpeed(arg)
end

function Player:Jump()
end

--- @return boolean
function Player:IsMoving()
end


--- @param x number
--- @param y number
--- @param z number
function Player:SetFacing(x, y, z)
end

--- Cancels navigation, exact movement, and autofollow. Current Lua source
--- accepts resetpath but does not use it; movement/path state is always reset.
--- @param resetpath boolean|nil
function Player:Stop(resetpath)
    -- This is just a placeholder for the editor
end

--- @param targetId number target id 
function Player:SetTarget(targetId)
    -- This is just a placeholder for the editor
end


--- Gets distance between two points
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number float distance
function math.distance2d(x1, y1, x2, y2)
    return 0
end

--- @class XZ
--- @field x number X-coordinate
--- @field z number Z-coordinate

--- @class Position : XZ
--- @field y number Y-coordinate

--- @class BarData
--- @field current number
--- @field max number
--- @field percent number 

--- Party-member records are distinct from EntityList player rows.
--- @class PartyMember
--- @field ptr number The memory pointer to the party member data.
--- @field id number The unique identifier for the party member.
--- @field guid string The globally unique identifier for the party member.
--- @field mapid number The map ID where the party member is located.
--- @field isleader boolean Whether the party member is the party leader.
--- @field region string The region the party member is currently in.
--- @field onmesh boolean Whether the party member is currently on a navigation mesh.
--- @field pos Position The position of the party member, with fields `x`, `y`, `z`.
--- @field hp BarData The health information of the party member, with fields `current`, `max`, `percent`.
--- @field mp BarData The mana information of the party member, with fields `current`, `max`, `percent`.
--- @field shield number The shield value of the party member (if applicable).
--- @field job number The job/class of the party member.
--- @field state number The current state of the party member (e.g., alive, dead, in combat).
--- @field level number The current level of the party member.
--- @field name string name of the char

--- Cross-world party member.
--- @class CrossWorldPartyMember
--- @field id number The unique identifier for the party member.
--- @field guid string The globally unique identifier for the party member.
--- @field isleader boolean Whether the party member is the party leader.
--- @field isonline boolean Whether the party member is online.
--- @field iscrossworld boolean Whether the party member is in a crossworld party.
--- @field job number The job/class of the party member.
--- @field level number The current level of the party member.
--- @field name string The name of the party member.
--- @field partyindex number The index of the party member within the party.
--- @field synclevel number The synchronized level of the party member (if applicable).
--- @field world number The world ID of the party member.
local CrossWorldPartyMember = {}

--- Native-backed table: properties must be read directly; pairs() may expose only __object.
--- Type-specific fields can be zero/default even when present.
--- @class Entity
--- @field __object userdata
--- @field attackable boolean
--- @field aggressive boolean
--- @field aggro boolean Entity aggro flag used by the "aggro" filter; distinct from its current target.
--- @field incombat boolean
--- @field interactable boolean
--- @field onmesh boolean
--- @field type number
--- @field chartype number
--- @field fateid number Associated FATE ID for FATE entities; Player.fateid is not a participation lookup.
--- @field ownerid number
--- @field distance2d number
--- @field mp BarData
--- @field gp BarData
--- @field name string The name of the entity
--- @field guid string Entity GUID; meaning depends on entity type.
--- @field currentworld integer World ID for player characters; may be a default on other types.
--- @field homeworld integer Home world ID for player characters; may be a default on other types.
--- @field marker number Raw marker value.
--- @field mountid integer Raw mount ID.
--- @field ismounted boolean Whether the entity is mounted.
--- @field level number Effective level, including level sync. Use Player.levels[Player.job] for base level.
--- @field id number The unique identifier for the entity
--- @field onlinestatus number|nil online status of entity if that's a player
--- @field contentId number The content ID of the entity
--- @field contentid number Alias of contentId.
--- @field alive boolean Whether the player is alive.
--- @field buffs table<number, Buff> Sparse slot-keyed buff map, NOT keyed by buff ID. Use pairs.
--- @field job number The job/class of the entity.
--- @field pos PlayerPosition The position and heading of the entity.
--- @field distance number The distance from the player to the entity
--- @field targetid number The ID of the current target of the entity
--- @field friendly boolean whether it's a friendly entity
--- @field hp BarData The health information of the entity, with fields `current`, `max`, `percent`
--- @field castinginfo CastingInfo May be an empty table on NPCs/objects; guard its fields.
--- @field action number The current action being performed by the entity
--- @field lastaction number The last action performed by the entity
--- @field hitradius number Hitbox radius (not an ID).
--- @field targetable boolean 
--- @field los boolean



--- Searches loaded entities with comma-separated filters; results are keyed by entity.id.
--- Pass an empty string for all entities: EntityList(""). EntityList() returns nil.
--- No matches returns {}; use next(rows) or table.valid(rows), not just `if rows`.
--- Get(missingId) returns nil. Re-fetch as entities despawn.
--- Returned player-character rows are Entity proxies, distinct from the global Player API.
---
--- Filter syntax:
--- * Combine distinct conditions with commas: "alive,attackable,targetable".
--- * Flags include alive, dead, attackable, aggressive, friendly, targetable,
---   incombat, notincombat, onmesh, los, targetingme, aggro, gatherable, myparty.
--- * type=N and chartype=N select one type. Use separate queries for multiple types.
--- * contentid=A;B includes either content ID; exclude_contentid=A;B excludes both.
--- * exclude=A;B excludes entity IDs (not content IDs).
--- * name=Text matches the exact, case-sensitive name.
--- * ownerid=N, targeting=N and fateid=N match the corresponding IDs.
--- * minlevel=N and maxlevel=N are inclusive and also require targetable entities.
--- * mindistance/maxdistance use entity.distance; the ...distance2d variants use
---   entity.distance2d. distanceto=N changes the distance origin to a loaded entity.
--- * nearest picks the smallest entity.distance; lowesthealth picks the lowest hp.percent.
---   Both return at most one entry in a table. Choose one selector per query.
--- * targetingme matches targetid == Player.id. aggro matches the entity's aggro flag;
---   these sets can differ. incombat also includes entities fighting other targets.
--- Unknown filters are silently ignored. Property names are not automatically filters:
--- "interactable" does not filter results; inspect entity.interactable in Lua instead.
--- Semicolon lists apply to contentid/exclude_contentid/exclude, not type.
--- Use each value-filter once: "type=1,type=2" uses the last value, not an OR.
---
--- Examples (read-only):
--- ```lua
--- -- Enumerate the loaded set. Use pairs; entity IDs are sparse keys.
--- for id, entity in pairs(EntityList("")) do
---     d(tostring(id) .. ": " .. entity.name)
--- end
---
--- -- Nearby player characters; a horizontal-distance filter.
--- local players = EntityList("type=1,targetable,maxdistance2d=30")
---
--- -- Closest eligible enemy. Always handle an empty result.
--- local matches = EntityList("nearest,alive,attackable,targetable,onmesh,maxdistance=50")
--- local id, enemy = next(matches)
--- if enemy then
---     local current = EntityList:Get(id) -- Re-fetch when using an ID later.
---     if current then d(current.name) end
--- end
---
--- -- Combat queries and the lowest health percentage among nearby enemies.
--- local attackers = EntityList("alive,attackable,targetingme")
--- local threats = EntityList("alive,attackable,aggro")
--- local engaged = EntityList("alive,attackable,incombat")
--- local _, weakest = next(EntityList("lowesthealth,alive,attackable,maxdistance=60"))
---
--- -- A distance band and a level range.
--- local enemies = EntityList("alive,attackable,mindistance=10,maxdistance=30")
--- local lowLevel = EntityList("type=2,alive,minlevel=5,maxlevel=10")
---
--- -- Match several content IDs, e.g. alternative exits/NPCs.
--- local exits = EntityList("contentid=2000139;2006235,targetable")
---
--- -- Build exclusions from known content IDs or loaded entity IDs.
--- local function exceptContent(a, b)
---     return EntityList("alive,attackable,exclude_contentid=" .. a .. ";" .. b)
--- end
--- local function exceptEntities(a, b)
---     return EntityList("targetable,exclude=" .. a .. ";" .. b)
--- end
---
--- -- Exact name lookup (no wildcard or substring matching).
--- local function byName(name)
---     return EntityList("name=" .. name)
--- end
---
--- -- Owned combat entities, such as a character's pet.
--- local function ownedBy(ownerId)
---     return EntityList("type=2,ownerid=" .. ownerId)
--- end
---
--- -- Nearby entities around a known reference rather than around Player.
--- local function nearEntity(entityId)
---     if not EntityList:Get(entityId) then return {} end
---     return EntityList("distanceto=" .. entityId .. ",maxdistance=15")
--- end
---
--- -- Apply properties without a native filter in Lua.
--- for id, entity in pairs(EntityList("targetable,onmesh")) do
---     if entity.interactable then d(tostring(id) .. ": " .. entity.name) end
--- end
--- ```
--- @class EntityList
--- @field myparty table<number, PartyMember> The list of party members in the player's party.
--- @field crossworldparty table<number, CrossWorldPartyMember> The cross-world party members.
--- @field Get fun(self: EntityList, id: number): Entity|nil
--- @overload fun(criteria: string): table<number, Entity>
EntityList = {}

--- @class Action
--- @field ptr number Memory pointer to the action data.
--- @field id number The unique identifier for the action.
--- @field name string The name of the action.
--- @field type number The type of the action.
--- @field skilltype number The skill type of the action.
--- @field cost number The cost to use the action.
--- @field casttime number The time it takes to cast the action.
--- @field recasttime number The time it takes to recast the action.
--- @field isoncd boolean Whether the action is on cooldown.
--- @field cd number Elapsed recast seconds; counts up during cooldown, then resets.
--- @field cdmax number Total recast duration in seconds. Remaining time is math.max(0, cdmax - cd).
--- @field range number The maximum range of the action.
--- @field radius number The radius of the action's effect.
--- @field level number The required level to use the action.
--- @field job number The job associated with the action.
--- @field iscasting boolean Whether the action is currently being cast.
--- @field combospellid number The ID of the spell this action combos with.
--- @field isgroundtargeted boolean Whether the action requires ground targeting.
--- @field attacktype number (Optional) The type of attack (for specific action types).
--- @field cooldowngroup number (Optional) The cooldown group this action belongs to.
--- @field statusgainedid number (Optional) The status effect ID gained from this action.
--- @field secondarycostid number (Optional) The secondary cost ID for this action.
--- @field aspect number (Optional) The aspect of the action.
--- @field category number (Optional) The category of the action.
--- @field primarycosttype number (Optional) The primary cost type of the action.
--- @field highlighted number Action highlight flag: 0 off, 1 on.
--- @field canfly boolean (Optional) Whether the action allows flying (specific to mounts).
--- @field usable boolean Whether the action is currently usable.
--- @field IsReady fun(self: Action, target?: number): boolean Checks if the action is ready to use.
--- @field IsFacing fun(self: Action, target?: number): boolean Checks if the player is facing the target for this action.
--- @field CanCastResult fun(self: Action, target?: number): integer Cast-check status code; 0 is success. Also consult IsReady; a successful check alone does not guarantee readiness.
--- @field Cast fun(self: Action, target?: number): boolean Attempts to cast.
--- @field IsInRange fun(self: Action, target?: number): boolean Checks if the action is in range of cast + LoS checks

--- ActionList class that provides access to actions.
--- @class ActionList
ActionList = {}

--- @return boolean whether we're casting something now (not memoized)
function ActionList:IsCasting()
end

-- hides all minion gui windows.
function ToggleGUI()
end

--- Retrieves an action object based on its type and ID.
--- @param actiontype number The type of the action (e.g., 1 for abilities, 13 for mounts, etc.)
--- @param actionid number The unique identifier of the action.
--- @return Action|nil action The action object if found, or nil if not found.
function ActionList:Get(actiontype, actionid)
    -- Implementation goes here
end

--- ActionList class that provides access to actions.
--- @class Hacks
Hacks = {}

--- @param x number
--- @param y number
--- @param z number
--- @param someBool boolean|nil
function Hacks:TeleportToXYZ(x, y, z, someBool)
end

function ActionList:StopCasting()
end

--- Checks if a specific FFXIV addon UI control/window is open in the game.
--- Control names identify game windows such as `SelectString`, `SelectYesno`,
--- `Shop`, `ContentsFinder`, `RecipeNote`, and `Synthesis`. UI state changes
--- asynchronously; an action issued this frame may open/replace a control later.
--- @param controlName string The name of the UI control to check (e.g., "ContentsFinderMenu").
--- @return boolean isOpen Returns true if the specified UI control is open, false otherwise.
function IsControlOpen(controlName)
    return false
end

--- Performs a named/semantic action on a specified UI control/window.
--- Prefer this (or `Control:Action`) over raw `PushButton`, `DoAction`, and
--- `UIEvent` calls. Action names and optional values are control-specific. Check
--- the control is open first, issue one transition, then verify state later; do
--- not busy-wait for the UI in the same frame.
--- @param controlName string The name of the UI control to interact with (e.g., "ContentsFinderMenu").
--- @param actionName string The action to perform on the control (e.g., "Leave").
--- @param argValue any|nil optional argument to pass to the control
--- @param preDelay number|nil delay before starting the action execution
--- @param postDelay number|nil delay post action execution
function UseControlAction(controlName, actionName, argValue, preDelay,postDelay)
    -- Implementation goes here
end

--- @return number milliseconds
function Now()
    return 0
end

--- Returns Minion's semantic/named data view for a control. This is preferable
--- to raw numeric AtkValue indexes when the control exposes named data. The
--- control should be open and values must be nil-checked because they can change
--- between frames.
--- @param control string name of the control
--- @param data string|number|nil name/index of the data, or nil to get the full semantic table
--- @return unknown
function GetControlData(control, data)
    return true
end

--- @class ChatLine
--- @field code number unique identifier for the type of chat message
--- @field line string the processed message line shown to the user
--- @field name string optional name associated with the chat message (usually empty)
--- @field rawline string raw, unprocessed line including non-printable characters
--- @field subcode number secondary identifier related to the message type
--- @field timestamp number Unix timestamp for when the message was logged

--- @return table<number, ChatLine> table with sequential integer keys and ChatLine values
function GetChatLines()
    return {}
end

-- same as Now() but better
--- @return number milliseconds
function GetTickCount()
	return 1
end


--- A live FFXIV addon window handle. Do not return Control objects through the
--- MCP bridge; extract a plain table of name/data/strings/rawData instead.
--- `PushButton` and `DoAction` are low-level, control-specific operations whose
--- numbers must be discovered for the exact window/build. Prefer `Action` or
--- `UseControlAction` when a semantic action name is known.
--- Return types can depend on the particular window.
--- @class Control
--- @field name string
--- @field PushButton fun(self: Control, pushButtonA: number, pushButtonB: number)
--- @field DoAction fun(self: Control, actionNumber: number)
--- @field Action fun(self: Control, actionName: string, args: any)
--- @field GetStrings fun(self: Control): table<number, string> gets string values and their associated ids
--- @field Close fun(self: Control) closes the control
--- @field Open fun(self: Control) opens the control
--- @field Destroy fun(self: Control) hard closes the control
--- @field IsReady fun(self: Control): boolean Whether the control is ready.
--- @field IsOpen fun(self: Control): boolean Whether the control is open.
--- @field GetData fun(self: Control): table<any, any>
--- @field GetRawData fun(self: Control): table<number, RawData>
--- @field GetActions fun(self: Control): table<number, string> Semantic action names used by UseControlAction.
--- @field SetXY fun(self: Control, x: integer, y: integer)
--- @field GetXY fun(self: Control): integer, integer

--- Enumerates controls known to Minion, including closed controls. Filter with
--- `control:IsOpen()` and return only cleaned plain data when using MCP:
--- `{id=id,name=c.name,ready=c:IsReady(),data=c:GetData(),strings=c:GetStrings(),rawData=c:GetRawData()}`.
--- @return table<number, Control> controls by id
function GetControls()
    return {}
end

--- Reads one indexed string, or the whole nonempty string table if id is omitted.
--- Index meanings are control-specific. Missing control/slot or empty data -> nil.
--- @overload fun(name: string): table<number, string>|nil
--- @param name string
--- @param id number
--- @return string|nil
function GetControlStrings(name, id)
    return ""
end

--- @param name string name of the control
--- @return Control|nil Missing controls return no value (nil).
function GetControlByName(name)
    return {}
end

--- One raw FFXIV AtkValue exposed by a control. Common `type` strings include
--- bool/int/uint/string; the exact set is runtime-defined. Numeric indexes and
--- their meaning can change by control state, language, or game patch.
--- @class RawData
--- @field type string
--- @field value any

--- Read a single raw AtkValue slot. Prefer `GetControlData` when semantic data is
--- available. Discover indexes with `Control:GetRawData()` rather than guessing.
--- Omitting index returns the whole nonempty raw-data table. Missing data -> nil.
--- @overload fun(name: string): table<number, RawData>|nil
--- @param name string name of the control
--- @param index integer index of the raw data in question
--- @return RawData|nil
function GetControlRawData(name, index)
    return {
		["type"] = "uint",
		["value"] = 0
	}
end

--- Attempts to dismount if mounted.
function Dismount()
end

--- Attempts to mount by using mount id
--- @param id number|nil moutn id
function Mount(id)
end

---@return boolean casting/doing something
function Busy()
end

---@param vcode integer presses a key by given vcode
function PressKey(vcode)
end

--- Native-backed userdata; table syntax here is editor-only.
KitanoiFuncs = {}

--- @param addon "kdf"
--- @param status boolean
function KitanoiFuncs.EnableAddon(addon, status)
end

--- @param dungeonTable table
function KitanoiFuncs.LoadDungeonTbl(dungeonTable)
end

-- See VaultSpamer/docs/INVENTORY_API.md in the workspace for container
-- coverage, native vs Lua helpers, and quality rules.
-- Proxies expose most properties through __index, not pairs(). Re-fetch before use.

---@class InventoryMateria
---@field itemid integer Materia item ID.
---@field name string Localized materia name.
---@field attribute integer Attribute ID.
---@field value number Attribute value.

--- @class BagItem
--- @field ptr number Can be 0 even on valid items; not a validity check.
--- @field ptr2 number Can be 0 even on valid items.
--- @field id integer Base item ID, including event IDs in the 2000000 range.
--- @field ishq 0|1 Numeric flag: 0 is truthy in Lua, so compare explicitly to 1.
--- @field hqid integer NQ base ID / HQ base+1000000.
--- @field flags integer Raw instance flags; NQ=0, HQ=1.
--- @field isingearset integer Numeric gearset value.
--- @field slot integer Zero-based physical slot; GetList key is slot+1.
--- @field type integer Parent container ID.
--- @field bag integer Parent container ID alias.
--- @field count number Current stack size
--- @field max number Maximum stack size
--- @field mbsellprice number Market listing price; -1 outside retainer listings.
--- @field condition number Whole condition percentage.
--- @field collectability number Collectability value.
--- @field spiritbond number Whole spiritbond percentage.
--- @field spiritbondvalue number Raw spiritbond: 10000=100%, 2647 -> spiritbond 26.
--- @field level number Item.LevelItem (item level).
--- @field requiredlevel number Item.LevelEquip.
--- @field class integer Item.FilterGroup, NOT job ID.
--- @field category integer Item.ClassJobCategory row ID, NOT ItemUICategory.
--- @field uicategory number UI category
--- @field searchcategory number Search category
--- @field canequip boolean Native eligibility; can be true for other-job main hands, not simply current-job compatibility.
--- @field equipslot integer Item.EquipSlotCategory, NOT zero-based equipment slot.
--- @field price number Item.PriceLow (NPC sell metadata), not current shop/market price.
--- @field materiaslotcount integer Static guaranteed materia slots, not current meld count.
--- @field materias table<integer, InventoryMateria>
--- @field rarity number Item rarity
--- @field isunique boolean Whether item is unique
--- @field isuntradeable boolean Whether item cannot be traded
--- @field iscollectable boolean Metadata flag, not proof of an actual rated collectable instance.
--- @field desynthvalue number Raw Item.Desynth field, NOT item level or player's desynthesis skill.
--- @field repairclassjob integer Item.ClassJobRepair.
--- @field repairitem integer ItemRepairResource row/grade, NOT item ID (8 -> dark matter 33916).
--- @field isbinding boolean|nil
--- @field name string Localized name; may initially be empty while metadata loads.
--- @field GetStat fun(self: BagItem, statId: integer, includeHQBonus?: boolean): number False/omitted = base; true adds HQ bonus only on an actual HQ item.
--- @field GetAction fun(self: BagItem): Action|nil Get associated action
--- @field IsReady fun(self: BagItem, targetId?: number): boolean Check if item can be used
--- @field Cast fun(self: BagItem, targetId?: number): boolean Use/cast the item
--- @field Sell fun(self: BagItem): boolean Sell the item
--- @field Discard fun(self: BagItem): boolean Discard the item
--- @field RetrieveMateria fun(self: BagItem): boolean Remove materia
--- @field HandOver fun(self: BagItem): boolean Hand over item
--- @field Gardening fun(self: BagItem): boolean Use for gardening
--- @field Repair fun(self: BagItem): boolean Repair the item
--- @field Salvage fun(self: BagItem): boolean Desynthesize item
--- @field CanCast fun(self: BagItem, actionType: number, actionId: number): boolean Check if action can be used
--- @field Purify fun(self: BagItem): boolean Purify item
--- @field Convert fun(self: BagItem): boolean Convert item
--- @field Meld fun(self: BagItem): boolean Meld materia
--- @field Transmute fun(self: BagItem): boolean Transmute item
--- @field SelectFeed fun(self: BagItem): boolean Select as feed
--- @field Reward? fun(self: BagItem): boolean
--- @field Split fun(self: BagItem, amount: number): boolean Split stack
--- @field Move fun(self: BagItem, bagId: number, slotId: number, amount?: number): boolean Move item
--- @field LowerQuality fun(self: BagItem): boolean Lower item quality
--- @field MBSell fun(self: BagItem, password: string, price: integer, qty: integer): boolean
--- @field MBReturn fun(self: BagItem, inventory: 0|1): boolean returns to your inventory if 0 and retainer if 1

-- Key/event-item metadata can be invalid for ordinary gear fields (see inventory docs).

--- @class Bag
--- @field id integer Container ID.
--- @field ptr number Can be 0 on valid bags.
--- @field size integer Total physical slots; varies by container.
--- @field free integer Free slots, not remaining item quantity.
--- @field used integer Occupied slots; temporary rows may have count=0.
--- @field Get fun(self: Bag, baseId: integer): BagItem|nil First base-ID match in this bag, either quality. No HQ offset or extra args.
--- @field GetItem fun(self: Bag, slot: integer): BagItem|nil Zero-based physical slot; empty/out-of-range -> nil.
--- @field GetList fun(self: Bag): table<integer, BagItem> Sparse slot+1 keyed map. Use pairs, not ipairs/#.
--- @field GetSortedItemList fun(self: Bag): table<integer, BagItem> Sparse display-sorted list. Use item's type/slot for actions.
--- @field RepairAll fun(self: Bag, useDarkMatter?: boolean): boolean True uses dark matter.

---@class InventoryItemLocation
---@field id integer Base ID.
---@field hqid integer Matched stack's quality-aware ID.
---@field bag integer Parent container ID.
---@field slot integer Zero-based physical slot.
---@field count integer Quantity in THIS stack, not aggregate count.
---@field canequip boolean Native eligibility flag.

---@class InventoryItemDetails
---@field id integer Requested ID (HQ offset preserved if supplied).
---@field name string May initially be empty.
---@field ptr number Can be 0.
---@field max number Static maximum stack size.
---@field level integer Item.LevelItem.
---@field requiredlevel integer Item.LevelEquip.
---@field class integer Item.FilterGroup, not job ID.
---@field category integer Item.ClassJobCategory.
---@field uicategory integer Item.ItemUICategory.
---@field searchcategory integer Item.ItemSearchCategory.
---@field equipslot integer Item.EquipSlotCategory.
---@field canequip boolean Native eligibility.
---@field price number Item.PriceLow.
---@field rarity integer Item.Rarity.
---@field isunique boolean
---@field isuntradeable boolean
---@field iscollectable boolean Metadata flag only.
---@field desynthvalue number Raw Item.Desynth.
---@field repairclassjob integer Item.ClassJobRepair.
---@field repairitem integer ItemRepairResource row ID.

---@class InventorySpecialCurrency
---@field itemid integer Currency item ID (note: not `id`).
---@field name string May initially be empty.
---@field count integer Current quantity.

---@class InventoryAPI
Inventory = {}

---Return one bag or all available proxies. No Inventory:GetList() API exists.
---A present empty proxy does not prove retainer/FC/storage contents are loaded.
---@overload fun(self: InventoryAPI): table<integer, Bag>
---@param bagId integer Container ID; advertised IDs can still return nil.
---@return Bag|nil
function Inventory:Get(bagId) end

---Native catalog, not a loaded/nonempty-container list.
---@return integer[]
function Inventory:GetTypes() end

---Native total stack quantity, NQ+HQ; includes main/equipped/armoury/currency/crystals/key items.
---Special currencies excluded.
---Numeric BASE ID only. Do not supply a second argument, even nil.
---@param baseId integer
---@return integer
function Inventory:GetItemCount(baseId) end

---Native HQ quantity by BASE ID, not base+1000000. Missing -> 0.
---@param baseId integer
---@return integer
function Inventory:GetItemCountHQ(baseId) end

---Explicit minimum=0 counts even noncollectable main-bag slots (NOT stack quantities).
---@param baseId integer
---@param minimum? number
---@param maximum? number
---@return integer
function Inventory:GetItemCountCollectable(baseId, minimum, maximum) end

---Native batch totals. Use {[baseId]=true}, NOT an array or string-keyed map.
---Numeric values are also treated as IDs; false values do not exclude numeric keys.
---@param idSet table<integer, boolean>
---@return table<integer, integer> counts Includes requested missing IDs as 0.
function Inventory:GetItemCounts(idSet) end

---Native existence by base ID, either quality.
---@param baseId integer
---@return boolean
function Inventory:HasItem(baseId) end

---Native sparse set of FOUND base IDs, not an all/any boolean. Absent IDs omitted.
---@param idSet table<integer, boolean> Use numeric keys and boolean values, not an array.
---@return table<integer, true>
function Inventory:HasItems(idSet) end

---Native first-stack lookup. Result has no BagItem methods; re-fetch by bag/slot.
---@param baseId integer Numeric base ID, matches either quality; extra args break the lookup.
---@return InventoryItemLocation|nil
function Inventory:FindItem(baseId) end

---Native metadata lookup, not a slot/ownership query. Nil can mean pending metadata;
---metadata for unowned items may load later. Retry on later frames, never spin.
---No count/slot/condition/materias. DO NOT call GetStat on this metadata proxy:
---it can cause native access violations that Lua pcall does not report.
---Use actual bag items for GetStat.
---@param itemId integer
---@return InventoryItemDetails|nil
function Inventory:GetItemDetails(itemId) end

---Native ordinary + special currency lookup. Does NOT count crafting crystals.
---@param itemId integer Currency item ID, not currency-bag slot.
---@return integer
function Inventory:GetCurrencyCountByID(itemId) end

---@return table<integer, InventorySpecialCurrency> Keyed by item ID; names may load later.
function Inventory:GetSpecialCurrencies() end

---@return table<integer, number> Condition percentages keyed by ZERO-based equipped slot; empty slots omitted.
function Inventory:GetEquippedConditions() end

---Native game/chat item-search command, NOT a found predicate. Can return true for missing IDs.
---Has side effects and asynchronous chat results; do not use in polling/hot-path code.
---@param itemId integer
---@return boolean
function Inventory:SearchForItem(itemId) end

---Native unlock query; (2,mountId) checks a mount unlock.
---@param unlockType integer
---@param id integer
---@return boolean
function Inventory:IsUnlocked(unlockType, id) end

---Sorts inventory. This method belongs to Inventory, not individual bags.
function Inventory:SortInventory() end

---@class ShopItem
---@field count number    -- The quantity of the item (if applicable)
---@field id number       -- Unique identifier for the item
---@field name string     -- The name of the item
---@field price number    -- The price of the item
---@field ptr number      -- A pointer (or reference) to additional data (if applicable)
---@field questid number  -- Quest identifier if the item is linked to a quest
---@field shopid number   -- The shop identifier for the item
---@field slot number     -- The slot number where the item is placed in the shop

---@return ShopItem[] A list of shop items in the inventory shop list.
function Inventory:GetShopList()
end

---@class ExchangeShopItem
---@field type1 integer
---@field type2 integer
---@field type3 integer
---@field slot integer
---@field id integer
---@field id2 integer
---@field name string
---@field price1 integer
---@field price2 integer
---@field price3 integer
---@field ptr integer

---Returns a list of items available for exchange.
---@return ExchangeShopItem[]
function Inventory:GetItemExchangeList()
end

--- @param itemId integer
--- @param count number|nil how many items to buy, 1 default
function Inventory:BuyShopItem(itemId, count)
end

---Lua slot scan, exact hqid match (base ID = NQ only); custom containers honored.
---Default: main + equipped + currency/crystals/key items + armoury, not remote storage.
---@param hqid integer
---@param inventories? integer[]
---@return BagItem|nil item
---@return Action|nil action
function GetItem(hqid, inventories) end

---@class InventoryItemWithAction
---@field item BagItem
---@field action? Action

---Lua slot scan returning every matching stack in a dense array.
---@param hqids integer[] Exact quality-aware IDs.
---@param inventories? integer[]
---@return InventoryItemWithAction[]
function GetItems(hqids, inventories) end

---Lua wrapper; slot is ONE-based, unlike bag:GetItem(). Defaults 1,2000.
---@param slot? integer
---@param inventoryId? integer
---@return BagItem|nil
function GetItemBySlot(slot, inventoryId) end

---Lua wrapper around native counters. Defaults NQ only; HQ offset -> HQ counter.
---An inventories table is IGNORED by the current implementation. Bool arg2/arg3 enables
---NQ+HQ for base IDs; ItemCount(HQoffset,true) incorrectly forwards the offset and returns 0.
---@param hqid integer|string
---@param inventoriesArg? integer[]|boolean
---@param includehqArg? boolean
---@return integer
function ItemCount(hqid, inventoriesArg, includehqArg) end

---@class InventoryCountRow
---@field id integer Requested quality-aware ID.
---@field count integer Quantity, including zero for absent IDs.

---Lua native-backed wrapper; input ARRAY, output ID-keyed rows. Container tables ignored.
---Unlike ItemCount, HQ offset dispatch still happens when includehq=true.
---@param hqids integer[]
---@param inventoriesArg? integer[]|boolean
---@param includehqArg? boolean
---@return table<integer, InventoryCountRow>
function ItemCounts(hqids, inventoriesArg, includehqArg) end

---@class InventorySnapshotRow
---@field name string
---@field count integer NQ quantity.
---@field HQcount integer HQ quantity.

---Lua snapshot; default bags 0,1,2,3,1000,2004,2000 (NOT armoury/crystals).
---@param inventories? integer[]
---@return table<integer, InventorySnapshotRow> Keyed by base ID.
function GetInventorySnapshot(inventories) end

---Lua free-slot search; hqid only checked for nonzero, NOT stack merging/compatibility.
---@param hqid integer
---@param inventories? integer[]
---@return integer|nil bagId
---@return integer|nil slot ONE-based; subtract 1 before native Move.
function GetFirstFreeSlot(hqid, inventories) end

---@return integer|nil bagId
---@return integer|nil slot ONE-based free slot in bags 0..3.
function GetFirstFreeInventorySlot() end

---@param bagId integer Armoury container ID, not equipment slot.
---@return integer|nil bagId
---@return integer|nil slot ONE-based free slot.
function GetFirstFreeArmorySlot(bagId) end

---Legacy name: returns used>0 BOOLEAN for a resolved bag, numeric 0 fallback.
---@param equippedSlot integer Zero-based equipped slot.
---@return boolean|0
function ArmoryItemCount(equippedSlot) end

json = {}

--- Encodes a JSON-compatible value (including scalars), not only tables.
--- @param t any
--- @param params table|nil
--- @return string
function json.encode(t, params)
end

--- Decodes a JSON value. Returns value,nextPosition on success and
--- nil,errorPosition,errorMessage for invalid JSON. JSON null defaults to nil.
--- @param s string
--- @param position integer|nil Optional starting byte position (1-based).
--- @return any value
--- @return integer nextPosition
--- @return string|nil errorMessage
function json.decode(s, position)
end

function HttpRequest(params)
end

--- @return string id of the account probably
function GetUUID()
end

--- @class AetheryteInfo
--- @field id integer

--- @param mapId integer
--- @param pos Position|nil position to choose better spot to tp to.
--- @return AetheryteInfo|nil aetheryte to tp to, if a suitable route exists
function GetAetheryteByMapID(mapId, pos)
end


--- @return number process id of ffxiv.
function GetCurrentPID()
end

--- Writes a file; omitted/false append truncates, true appends (creating if absent).
--- Does not create parent directories. Returns false for a missing parent or
--- a directory destination; these failures do not throw a Lua error.
---@param path string
---@param message string
---@param append boolean|nil Defaults to false.
---@return boolean success
function FileWrite(path, message, append)
end

--- Deletes a file. Returns false for a missing path or a directory.
---@param path string
---@return boolean success
function FileDelete(path)
end

--- Lists immediate filenames (not full paths) in a 1-based array.
--- Excludes directories and does not recurse. Empty/no matches returns {};
--- a missing path or a file instead of a directory returns false.
--- Filter is a case-sensitive, full-filename regex, NOT a Lua pattern or glob:
--- [[(.*)log$]] matches alpha.log; [[alpha]] does not; [[alpha.*]] does.
--- Omitted/nil/empty filter lists all files. Both slash styles work, with or
--- without a trailing separator. No ordering guarantee is assumed.
---@param path string
---@param filter string|nil e.g. [[(.*)lua$]]
---@return string[]|false
function FolderList(path, filter)
end

--- Returns true for a directory, false for a missing path or a file.
---@param path string
---@return boolean
function FolderExists(path)
    return false
end

--- Creates a directory and any missing parents; true if it already exists.
--- Can also return true for an existing FILE path.
--- Use FolderExists afterward when a directory is required.
---@param path string
---@return boolean result
function FolderCreate(path)
end

--- Recursively deletes a directory AND ITS CONTENTS, including nested files.
--- Returns true on successful removal, false for a missing directory.
---@param path string
---@return boolean success
function FolderDelete(path)
end

--- @return integer amount on character
function GilCount()
end


--- @type boolean
--- whether a profile is running (e.g. assist/quest)
FFXIV_Common_BotRunning = false

--- Live character quest state. Quest IDs here are the in-game IDs used by
--- profiles, not the `Quest.csv` row key. Static actor/listener/location data comes from
--- https://github.com/xivapi/ffxiv-datamining.
--- @class QuestClass
--- @field IsQuestCompleted fun(self: QuestClass, questId: number, something: boolean): boolean Checks if the quest is complete
--- @field HasQuest fun(self: QuestClass, questId: number, leve: boolean|nil): boolean Checks whether the quest is active
--- @field GetQuestCurrentStep fun(self: QuestClass, questId: number, something: boolean|nil): integer Returns the live quest sequence; validate profile `complete.step` values against it
--- @field GetQuestList fun(self: QuestClass): table Live quest list
Quest = {}

--- @param questId integer
--- @return boolean
function HasQuest(questId)
end

--- @param questId integer
--- @return boolean
function QuestCompleted(questId)
end

-- reloads lua
function Reload()
end

---@param command string a command to execute
function SendTextCommand(command)
end

--- @class ServerInfo
--- @field id integer Server ID
--- @field name string Server Name
--- @field ptr integer PTR status (0 for non-PTR servers)

--- @return ServerInfo[] List of available FFXIV servers
function GetServerList()
end

--- @param serverId integer ID of the server to select
--- @return boolean Success status of server selection
function SelectServer(serverId)
end


--- @return number
function MGetGameState()
end

---@param l string
---@param r string
---@return boolean
function string.contains(l, r)
end

--- TensorCore addon
TensorCore = {}

--- Returns whether tensorcore exe is loaded. 
--- @return boolean
function TensorCore.isExeLoaded()
	return false
end

--- Set the auto-follow position for the player
--- @param self Player
--- @param x number The X-coordinate to follow
--- @param y number The Y-coordinate to follow
--- @param z number The Z-coordinate to follow
function Player:SetAutoFollowPos(x, y, z)
end

--- Enables or disables the auto-follow feature for the player.
--- @param enable boolean: If true, auto-follow is enabled; if false, it is disabled.
function Player:SetAutoFollowOn(enable)
end

--- Optional legacy clock offset.
--- @type number|nil
GlobalOffset = 0

Questing = {}

gQuestProfileIndex = 0
gQuestProfile = "(Latty) 1-70 [ARR-HW-SB]"

--- @type string[]
Questing.profilesDisplay = {"(Latty) 1-70 [ARR-HW-SB]", "(Latty) 1-100 [Testing]"}

--- @param profileName string
function Questing.UpdateSelection(profileName)
end

--- @param path string
--- @return boolean
--- @nodiscard
function direxists(path)
end

--- @param path string
--- @return boolean
function dircreate(path)
end

--- Task constructors can reset navigation/unstuck state or change gSkipTalk
--- before a task is queued.
--- Fields can be nil until configured; some positions use 0/false sentinels.
--- @class ml_pos
--- @field x number
--- @field y number
--- @field z number
--- @field h number?

--- @class ml_task
--- @field name string
--- @field valid boolean
--- @field completed boolean
--- @field auxiliary boolean
--- @field subtask ml_task?
--- @field process_elements table
--- @field overwatch_elements table
--- @field preserveSubtasks boolean?
--- @field overwatchContinues boolean?
--- @field breakUpdate boolean?
--- @field pos ml_pos|0|false|nil
ml_task = {}

--- Attach a child task to this task. The task hub executes the child before resuming
--- its parent. Used for `ffxiv_task_movetopos.Create()` and other task factories.
--- @param task AnyTask
function ml_task:AddSubTask(task) end

--- @class ml_task_MOVETOMAP : ml_task
--- @field name "MOVETOMAP"
--- @field destMapID number
--- @field tryTP boolean|nil Legacy field; not initialized by current MOVETOMAP constructor.
--- @field useAethernetTickets boolean
--- @field setHomepoint boolean
--- @field delayTimer number|nil Not initialized by current MOVETOMAP constructor.
--- @field delayTime number|nil Not initialized by current MOVETOMAP constructor.
--- @field pos ml_pos|nil

--- @class ml_task_MOVETOPOS : ml_task
--- @field name "MOVETOPOS"
--- @field pos ml_pos|0 Must be configured before scheduling; constructor uses 0.
--- @field range number
--- @field doFacing boolean
--- @field remainMounted boolean
--- @field useFollowMovement boolean
--- @field useTeleport boolean
--- @field dismountDistance number
--- @field destMapID number
--- @field alwaysMount boolean
--- @field gatePos ml_pos?
--- @field customSearch string
--- @field customSearchCompletes boolean
--- @field startMap number
--- @field noFly boolean
--- @field range3d number? Vertical/3D completion range; used alongside `range` by some callers.
--- @field useAethernet boolean? Allow local aethernet travel while routing.
--- @field cubefilters number? Navigation cube-filter flags; commonly `1` to suppress flying.
--- @field floorfilters number? Navigation floor-filter flags.
--- @field nomount boolean? Prevent mounting for this movement task.

--- Factory for Minion's mesh-navigation subtask. `Create()` does not queue movement,
--- but DOES reset NavigationManager's path and unstuck state in current source.
--- Configure the returned task, then attach it to the current task with
--- `ml_task_hub:CurrentTask():AddSubTask(task)`.
---
--- Minimal pattern (from MoogleClickToTravel):
--- ```lua
--- local task = ffxiv_task_movetopos.Create()
--- task.pos = { x = 30.0, y = 4.0, z = 53.2 }
--- task.range = 1
--- task.remainMounted = false
--- ml_task_hub:CurrentTask():AddSubTask(task)
--- ```
---
--- This requires a current parent task. The movement subtask runs asynchronously on
--- subsequent task-hub updates; creating/attaching it does not wait for arrival.
--- @class ffxiv_task_movetopos
ffxiv_task_movetopos = {}

--- Create an unstarted MOVETOPOS task. Set at least `pos`; normally also set `range`.
--- @return ml_task_MOVETOPOS
function ffxiv_task_movetopos.Create() end

--- @class ml_task_MOVETOINTERACT : ml_task
--- @field name "MOVETOINTERACT"
--- @field contentid number
--- @field interact number
--- @field pos ml_pos|false
--- @field range number?
--- @field useTeleport boolean
--- @field dismountDistance number
--- @field killParent boolean
--- @field startMap number
--- @field conversationstring string
--- @field conversationstrings string|table
--- @field conversationindex number
--- @field interactAttempts number
--- @field maxAttempts number
--- @field alwaysMount boolean
--- @field interactRange3d number?
--- @field inflight boolean?
--- @field ignoreAggro boolean?

--- @class ml_task_MOVETOFATE : ml_task
--- @field name "MOVETOFATE"
--- @field fateid number
--- @field pos ml_pos|0
--- @field range number
--- @field actualPos ml_pos|0
--- @field requiresPosRandomize boolean
--- @field alwaysMount boolean
--- @field dismountDistance number

--- @class ml_task_MOVEAETHERNET : ml_task
--- @field name "MOVEAETHERNET"
--- @field contentid number
--- @field interact number
--- @field pos ml_pos|false
--- @field useAethernet boolean
--- @field unlockAethernet boolean
--- @field isResidential boolean?
--- @field conversationstring string
--- @field conversationstrings string|table
--- @field conversationindex number
--- @field startMap number
--- @field alwaysMount boolean
--- @field initiatedPos ml_pos

--- @class ml_task_GRIND_COMBAT : ml_task
--- @field name "GRIND_COMBAT"
--- @field targetid number
--- @field pos ml_pos?
--- @field betterTargetFunction function?
--- @field noTeleport boolean
--- @field noFateSync boolean
--- @field noFlee boolean
--- @field attackThrottle boolean
--- @field attemptPull boolean
--- @field canEngage boolean?
--- @field safeDistance number?

--- @class ml_task_LT_TELEPORT : ml_task
--- @field name "LT_TELEPORT"
--- @field aetheryte number
--- @field mapID number
--- @field setHomepoint boolean
--- @field setEvac boolean
--- @field conversationIndex number

--- @class ml_task_LT_REST : ml_task
--- @field name "LT_REST"

--- @class ml_task_LT_FLEE : ml_task
--- @field name "LT_FLEE"
--- @field pos ml_pos|0
--- @field range number
--- @field useTeleport boolean
--- @field alwaysMount boolean

--- @class ml_task_LT_STEALTH : ml_task
--- @field name "LT_STEALTH"
--- @field addingStealth boolean
--- @field droppingStealth boolean

--- @class ml_task_LT_SUMMON_CHOCOBO : ml_task
--- @field name "LT_SUMMON_CHOCOBO"

--- @class ml_task_LT_USEITEM : ml_task
--- @field name "LT_USEITEM"
--- @field itemid number
--- @field targetid number
--- @field pos ml_pos
--- @field maxTime number
--- @field useAttempts number

--- @class ml_task_AVOID : ml_task
--- @field name "AVOID"
--- @field targetid number
--- @field pos ml_pos|0
--- @field maxTime number
--- @field attackTarget number

--- @class ml_task_NAV_INTERACT : ml_task
--- @field name "NAV_INTERACT"
--- @field contentid number
--- @field interact number
--- @field pos ml_pos|false
--- @field conversationIndex number
--- @field conversationstrings string|table
--- @field destMapID number?
--- @field alwaysMount boolean
--- @field abort function?

--- @class ml_task_MESH_INTERACT : ml_task
--- @field name "MESH_INTERACT"
--- @field interact number

--- @class ml_task_MISC_SHOPPING : ml_task
--- @field name "MISC_SHOPPING"
--- @field itemid number|table
--- @field buyamount number
--- @field id number
--- @field mapid number
--- @field pos ml_pos
--- @field category number?
--- @field subcategory number?
--- @field itemindex number?

--- @class ml_task_MISC_SWITCHCLASS : ml_task
--- @field name "MISC_SWITCHCLASS"
--- @field class number
--- @field override number

--- @class ml_task_MISC_SCRIPEXCHANGE : ml_task
--- @field name "MISC_SCRIPEXCHANGE"
--- @field categories table
--- @field id number
--- @field mapid number
--- @field pos ml_pos
--- @field aethid number?

--- @alias AnyTask
--- | ml_task_MOVETOMAP
--- | ml_task_MOVETOPOS
--- | ml_task_MOVETOINTERACT
--- | ml_task_MOVETOFATE
--- | ml_task_MOVEAETHERNET
--- | ml_task_GRIND_COMBAT
--- | ml_task_LT_TELEPORT
--- | ml_task_LT_REST
--- | ml_task_LT_FLEE
--- | ml_task_LT_STEALTH
--- | ml_task_LT_SUMMON_CHOCOBO
--- | ml_task_LT_USEITEM
--- | ml_task_AVOID
--- | ml_task_NAV_INTERACT
--- | ml_task_MESH_INTERACT
--- | ml_task_MISC_SHOPPING
--- | ml_task_MISC_SWITCHCLASS
--- | ml_task_MISC_SCRIPEXCHANGE
--- | ml_task

--- @type number
REACTIVE_GOAL = 2

--- @type number
TP_IMMEDIATE = 0

ml_task_hub = {}

--- @param task AnyTask
--- @param goal number
--- @param prio number
function ml_task_hub:Add(task, goal, prio) end

--- @return AnyTask|nil Nil when the task hub is idle.
function ml_task_hub:CurrentTask() end

--- @return AnyTask|nil Nil when the task hub is idle.
function ml_task_hub:ThisTask() end

--- KDF funcs thing, stores/loads data in C:\MINIONAPP\Bots\FFXIVMinion64\LuaMods\KitanoiFuncs\Settings\Data
kIO = {}

function kIO.save()
end

function kIO.load()
end

--- Whether to auto skip cutscenes
--- @type boolean
gSkipCutscene = false

--- Whether to skip dialogs
--- @type boolean
gSkipTalk = false

--- Whether to skip unskippable cutscenes
--- @type boolean
gSkipUnsafeCutscene = false


--- Whether to do disable city quests
--- @type boolean
QuestOpts_City_Quests = false

--- do chocobo quests
--- @type boolean
QuestOpts_Q_Mounts = true


--- prio huntlog over quests
--- @type boolean
gQuestPrioritizeHuntlogs = false

KitanoiSettings = {
    SuppressAceLibNavErrors = false,
    SuppressAceLibNavErrorsForce = false,

    --- you can save arbitrary things in kitanoi funcs.
    --- @type any
    CustomVar1 = 0,
}

gBotMode = 'Quest'
gBotModeIndex = 1
gBotModeList = {
    'Assist',
    'Duty'
}

QuestOpts_L_v1_PickGC = "Maelstrom"
QuestOpts_L_v1_PickGC_index = 3
QuestOpts_Q_ChocoboName = "sss"

--- @type table<integer, string>
gACRSelectedProfiles = {
    [1] = "Kitanoi",
    [3] = "Kitanoi",
    [5] = "Kitanoi",
    [7] = "Kitanoi",
    [21] = "Kitanoi",
    [23] = "Kitanoi",
    [29] = "Kitanoi",
    [30] = "Kitanoi",
    [32] = "Kitanoi"
}

--- Whether to collect aether currents while doing questing
--- @type boolean
gQuestGatherAetherCurrents = false

--- Optional BlueMagicLevel addon.
BlueMagicLeveling = {}

--- @type table
BlueMagicLeveling.skilldata = {}

--- @type integer[]
BlueMagicLeveling.IgnoreSkills = {}

--- @type table<integer, table>
BlueMagicLeveling.skillnotlearn = {
    { 
        actionid = 23281,
        learn = false
    }
}


--- @param mapId integer
--- @return boolean
function HasAllCurrents(mapId)
    return false
end

--- One field aether current orb (EObj) from ffxiv_aethercurrent_data(DT).
--- @class AetherCurrentEntry
--- @field id integer slot index in the zone's status array (as in ffxivminion.AetherCurrentData[mapId])
--- @field aethid integer EObj contentid of the orb (e.g. 2013961), usable in EntityList "contentid=" queries
--- @field x number
--- @field y number
--- @field z number
--- @field requires? fun(): boolean quest/section gate; orb only exists when this returns true

--- Legacy pre-Dawntrail data global. Current helpers use
--- FFXIVLib.API.AetherCurrent.GetAetherCurrentsByTerritoryId instead.
--- @type table<integer, AetherCurrentEntry[]>|nil keyed by mapId
ffxiv_aethercurrent_data = {}

--- Legacy Dawntrail data global.
--- @type table<integer, AetherCurrentEntry[]>|nil keyed by mapId
ffxiv_aethercurrent_dataDT = {}

--- Cached attunement status for a map from ffxivminion.AetherCurrentData.
--- Returns {} when the cache is cold (e.g. right after a reload).
--- @param mapid integer
--- @return table<integer, boolean> current slot -> attuned
function GetAetherCurrentData(mapid)
    return {}
end

--- whether to use tphack while questing. (careful)
--- @type boolean
gTeleportHack = false

ml_mesh_mgr = {}
--- @param mapId integer
---@param name string
---@param enfore boolean
function ml_mesh_mgr.SetDefaultMesh(mapId, name, enfore)
end

gStuckRemesh = true

--- current quest id that questing is doing
gCurrQuestID = 123
--- quest step id
gCurrQuestObjective = 3
--- internal quest step thing
gCurrQuestStep = 2

--- Optional external addon.
erduytashit = {}

function erduytashit.Update()
end

--- @type boolean
gUseMount = true

--- @type boolean
gGrindDoHuntlog = false

--- @type boolean
gGrindDoFates = false

--- @type number
gFleeHP = 13

---@class GameSetting
---@field ptr number Memory pointer address
---@field name string Setting name/identifier
---@field type integer Native setting type code.
---@field value any Current setting value
---@field SetValue fun(self: GameSetting, value: number) Sets the setting value

---@return table<number, GameSetting> settings List of game settings indexed by ID, or nil if unavailable
function GetGameSettings()
	return {}
end

--- @return integer Numeric game build/version value.
function GetGameVersion()
end

--- @deprecated
AceLib = {}

-- Profile-dependent options, absent until the relevant fishing profile loads.
-- disable vendoring
--- @type boolean|nil
QuestOpts_Fishing_100_DT_Armor = true
-- disable quests
--- @type boolean|nil
QuestOpts_Fishing_Quest_Disable = false

--- @param i integer
--- @return integer
function GetUIPermission(i)
end

--- stores original d after shim
--- @type (fun(s: string|nil)|nil)
original_d = d

--- @param vcode integer
function KeyUp(vcode)
end

--- @param vcode integer
function KeyDown(vcode)
end

--- @param localmapid integer
--- @param mapid integer
--- @param x number
--- @param z number
function SetMapFlagPosition(localmapid, mapid, x, z)
end

--- @class MapFlagPosition
--- @field localmapid integer
--- @field mapid integer
--- @field x number
--- @field z number

--- @return MapFlagPosition|false|nil
function GetMapFlagPosition()
end

--- @type boolean
--- whether to summon chocobo while grinding
gChocoGrind = false


--- @type boolean
--- whether to summon chocobo while grinding
gChocoAssist = false


--- @type boolean
--- whether to summon chocobo while grinding
gChocoQuest = false


--- @return boolean whether UI is visible
function IsGUIVisible()
end

--- @type table
ffxiv_unstuck = {
    GUI = {}
}

--- @type table
NavigationManager = {
    ShowFloorMesh = false
}

--- @return string /r/n separated lines, exactly as in console
function GetConsoleLines()
end

-- clears all messages in minion console
function ClearConsole()
end

--- @param enable boolean|nil whether to enable reduce ram.
--- @return boolean whether it's enabled now 
function ReduceRam(enable)
    return false
end

--- @return string actual UID from Accounts.json
function GetMinionAppUUID()
end


SkillMgr = {}

-- will cust current selected ACR thing without acr itself being enabled.
function SkillMgr.Cast()
end

-- hacks repair (whether to try to repair items with menders or other ways)
gRepair = true

--- some global task that questing sets I think
--- @type string|nil Can be nil while idle.
taskName = "LT_GRIND"

--- some global task that questing sets I think
--- @type string|nil Can be nil while idle.
gFFXIVMinionTask = "GRIND_COMBAT"

--- Fires a low-level UI event to a registered FFXIV agent via InputHandler
--- (ProcessEvent). This is the lowest-level control API: agent/event IDs and
--- argument positions are specific to an exact window and game build. Prefer
--- `UseControlAction` or `Control:Action`; do not guess UIEvent sequences.
--- UI transitions are asynchronous, so verify the resulting control later.
--- Examples captured for specific controls/builds:
---  UIEvent(130, 3, {{3, 21}, {5, 1}, {0, 0}}) - enables password
---  UIEvent(130, 3, {{3, 16},  {3, 3}, {0, 0}}) - sets the password in PF to 0003
---  UIEvent(130, 3, {{3, 32},  {2, 1}, {0, 0}}) - remove role restrictions
---  UIEvent(130, 3, {{3, 34},  {5,0}, {0, 0}}) - picks Alliance
---  UIEvent(130, 3, {{3, 34},  {5,1}, {0, 0}}) - picks Alliance
---  UIEvent(130, 3, {{3, 12},  {5,5}, {0, 0}}) - refresh ui (need after pick alliance/normal)
--- local laby = 0; for i = 49,70 do if GetControlRawData("LookingForGroupCondition", i).value == "The Labyrinth of the Ancients" then laby = i - 49; break; end end;  UIEvent(130, 3, {{3, 13}, {5, laby}, {0, 0}})
--- @param agentIndex integer|string The agent index (0-based)
--- @param eventId integer The event command ID
--- @param args {[1]: 0|2|3|4|5|6|7, [2]: any}[] Array of {AtkValueType, value} pairs
--- AtkValueType: None(0), Bool(2), Int(3), Int64(4), UInt(5), UInt64(6), Float(7)
--- @return nil
function UIEvent(agentIndex, eventId, args)
end

--- Milliseconds elapsed since a Now()-compatible timestamp. Nil raises an error.
--- @param arg number
--- @return number
function TimeSince(arg)
end

MEntityList = EntityList

--- @class KnownMarker
--- @field target integer
--- @field markertype integer
--- @field deletetime integer
--- @field entityID2 integer

--- @type table<string, KnownMarker>
KitanoiSettings.knownmarkers = KitanoiSettings.knownmarkers

KitanoiNavigation = {}
KitanoiNavigation.NavAPI = {}

--- @param x number
--- @param y number
--- @param z number
function KitanoiNavigation.NavAPI.MoveTo(x, y, z)
end

function KitanoiNavigation.NavAPI.Stop()
end

--- Represents a single aetheryte entry in the aetheryte list.
--- @class Aetheryte
--- @field id number The unique identifier of the aetheryte.
--- @field name string The display name of the aetheryte.
--- @field territory number The territory ID where the aetheryte is located.
--- @field region number The region ID where the aetheryte is located.
--- @field price number The gil cost to teleport to this aetheryte.
--- @field isattuned boolean Whether the player is attuned to this aetheryte.
--- @field isfavpoint boolean Whether this aetheryte is marked as a favourite point.
--- @field ishomepoint boolean Whether this aetheryte is set as the player's home point.
--- @field islocalmap boolean Whether this aetheryte is a local map point (hamlet/inn).
--- @field ptr number Internal pointer reference.
local Aetheryte = {}

--- Compatibility wrapper over FFXIVLib.API.Map.GetAetherytes.
--- force is retained but unused; true/false maps to attuned/unattuned filters.
--- @param force boolean|nil Legacy argument, currently unused.
--- @param attunementFlag 0|1|2|boolean|nil 0/all (default), 1/true attuned, 2/false unattuned.
--- @return table<number, Aetheryte> Keyed by aetheryte ID, not a dense array.
function GetAetheryteList(force, attunementFlag) end


--- @param id integer
--- @return Position|nil Nil when no location resolves.
function GetAetheryteLocation(id)
end

--- @class KBuy
--- @field mysettings table kitanoi-formatted table to buy
--- @field enable boolean

--- @type KBuy
kBuy = nil

--- Whether to only check for map reachability
--- @type boolean
KitanoiFuncs.BypassVisibleNPCCheck = true

--- @param mapId integer
--- @return boolean
function CanAccessMap(mapId)
end

--- @param mapId integer
--- @return string
function GetMapName(mapId)
end

--- Proxy class mapped to settings
--- @type table
Settings = {}

--- @class Fate
--- @field ptr number Can be 0; not a validity check.
--- @field id integer FATE ID, used by EntityList("fateid=" .. id).
--- @field name string FATE name.
--- @field description string FATE description.
--- @field type integer FATE category code.
--- @field status integer Status code: 2 active, 5 finished, 7 awaiting activation.
--- @field duration number Remaining seconds; a finished row can retain a positive value.
--- @field completion number Completion percentage (0-100).
--- @field level integer Recommended FATE level.
--- @field maxlevel integer Level-sync ceiling.
--- @field radius number Fate area radius
--- @field x number World X coordinate
--- @field y number World Y coordinate
--- @field z number World Z coordinate
--- @field postype number Position type

--- Lists FATEs in the current zone, including ones outside the loaded entity range.
--- Returns an array; its indices are not FATE IDs and can shift between calls.
--- Coordinates are top-level x/y/z fields. Use f.id when retaining an identity.
---
--- ```lua
--- -- Index by FATE ID for this snapshot, and find loaded enemies for active FATEs.
--- local byId = {}
--- for _, f in ipairs(GetFateList()) do
---     byId[f.id] = f
---     if f.status == 2 and f.completion < 100 then
---         local enemies = EntityList("alive,attackable,fateid=" .. f.id)
---         for id, enemy in pairs(enemies) do d(tostring(id) .. ": " .. enemy.name) end
---     end
--- end
--- ```
--- @return Fate[]
function GetFateList() end

gUseAutoFollowPath = false

-- Optional native bridge declarations live in the workspace's
-- VaultSpamer/.vscode/noobgam_offload.lua, NOT alongside this file.
-- Prose and examples: VaultSpamer/docs/NATIVE_LUA_BRIDGE.md.
-- Do not assume the native bridge is installed for public addon users.


--- @param line string
--- @return string filtered string
function CleanConvoLine(line)
    -- sample impl, remove common special chars.
    local clean = string.gsub(line,"[()-/\x02\x16\x01\x03]","")
    return clean
end

--- @param posa Position
--- @param posb Position
--- @return number
function math.distance3d(posa, posb)
    return 0.0
end

--- @return boolean
function MIsLoading()
    return false
end

KDF = {
}

--- @return string name of current dungeon profile or "None"
function KDF.Name()
    return "Seat of Sacrifice"
end