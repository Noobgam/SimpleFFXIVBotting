---@meta
---@diagnostic disable: missing-return
---@diagnostic disable: lowercase-global
--- Type definitions primarily for the globally available scope.

--- @class MLNavigation
--- @field HasPath fun(self: MLNavigation): boolean whether navigation currently has a path selected
--- @field ClearInteractActionHandoff fun(self: MLNavigation)
--- @field ClearNavigationHandoff fun(self: MLNavigation, kind?: string)
--- @field ResetCurrentPath fun(self: MLNavigation)
--- @field DisablePathing fun(self: MLNavigation): boolean
--- @field EnablePathing fun(self: MLNavigation): boolean
--- @field path Position[] Path nodes with x/y/z and additional navigation metadata.
--- @field DisableAutoFollow fun(self: MLNavigation, force?: boolean, source?: string)
--- @field canPath boolean
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
--- @return boolean open Whether the header is expanded.
function GUI:CollapsingHeader(label) end


--- @param self GUI
--- @param label string
--- @param active boolean Whether the radio button is selected.
--- @return boolean pressed Whether the button was pressed.
function GUI:RadioButton(label, active) end


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
--- @param local_pos_x number|nil Horizontal offset from the window/group origin.
--- @param local_spacing_w number|nil Spacing from the preceding item.
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

--- Unsupported modern ImGui tab-color constants.
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
--- @return boolean visible Whether the window is visible.
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

--- Create a small button. Size-argument behavior is undocumented.
--- @param self GUI
--- @param label string The label of the button
--- @param sizeX number|nil
--- @param sizeY number|nil
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

--- Serializes a Lua value to a file, replacing any existing contents.
--- Parent directories must exist; returns false when the file cannot be written.
---@param path string
---@param var any lua object to store
---@return boolean success
function FileSave(path, var)
end

--- Loads a value saved with FileSave. Missing files return nil.
---@param path string
---@return any return value of the file saved with FileSave
function FileLoad(path)
	return {}
end

---@param confirm boolean
function PressYesNo(confirm)
end

--- Registers a callback. Reusing an identifier adds another callback.
--- A nil handler leaves existing callbacks registered.
--- For temporary callbacks, use a closure guard to disable them after completion.
--- @param event string Event name to listen for
--- @param handler function The function to call when the event is triggered
--- @param identifier string Label for this event registration
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
--- plus-separated buffs absent.
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

--- True only for a non-empty table (including sparse tables and false-valued entries).
--- Nil, non-table values, and empty tables return false without throwing.
--- @param value? any
--- @return boolean
function table.valid(value)
    -- Non-empty-table predicate.
    return type(value) == "table" and next(value) ~= nil
end

--- Global object `Duty`.
--- @class DutyClass
Duty = {}

--- Join duty by type and id. See dev tools
--- @param type integer type of duty
--- @param id integer Duty ID.
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
--- @return table<number, DutyInfo> Duty records indexed by native lookup key.
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
--- @field ptr number|nil Raw pointer field; can be 0.
--- @field castingid number|nil Executing action ID; transient, including instant actions. 0 when idle.
--- @field casttime number|nil Total cast duration in seconds while channeling.
--- @field castingtargetcount number|nil Reported target count.
--- @field castinginterruptible boolean|nil
--- @field castingtargets table<number, number>|nil Numeric target IDs.
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
--- @field stacks number Raw status parameter.
--- @field slot number The slot index of the buff.
--- @field dispellable boolean Whether the buff is dispellable.

--- Nested host reads produce fresh snapshot tables.
--- @class FlyingInfo
--- @field isflying boolean Current airborne state.
--- @field canflyinzone boolean Flight unlocked/allowed in the current territory.
--- @field pitch number Flight pitch; separate from camera.pitch.

--- @class DivingInfo
--- @field isdiving boolean
--- @field isswimming boolean
--- @field candiveinzone boolean Territory capability; can be true while standing on land.
--- @field heightlevel number Water-height/depth threshold used by GetDiveHeight/IsDiveDepth.

--- @class PlayerCamera : Position
--- @field h number Camera heading in radians.
--- @field pitch number Camera pitch in radians. Coordinates use the host camera reference.

--- Snapshot of movement settings; use Player setters to change settings.
--- @class PlayerMovementSettings
--- @field autoface boolean
--- @field movemode integer Installed navigation treats 0 as standard and 1 as legacy.

--- Crafting/gathering stat summary.
--- @class PlayerCraftGatherStats
--- @field craftmanship number Craftsmanship stat.
--- @field control number
--- @field gathering number
--- @field perception number

--- @class EurekaInfo
--- @field level integer Elemental level; -1 when unavailable outside Eureka.
--- @field element integer Elemental value; -1 when unavailable outside Eureka.

--- Nearest mesh-point snapshot.
--- @class EntityMeshPosition : Position
--- @field meshdistance number 3D distance from this entity's position to the mesh point.
--- @field distance number 3D distance from Player.pos to this mesh point.

--- Global Player proxy with local-client attributes and methods.
--- Properties require a loaded character; loading states can make them unavailable.
--- @class Player : Entity
--- @field job number The job or class of the player (represented by an ID).
--- @field castinginfo CastingInfo The casting information for the player.
--- @field grandcompany number The grand company affiliation of the player.
--- @field grandcompanyrank number The rank within the grand company.
--- @field aggro boolean Player-proxy aggro flag; use EntityList("aggro") to find threatening entities.
--- @field hasaggro boolean Player-proxy aggro flag; use EntityList("targetingme") for current attackers.
--- @field mp BarData
--- @field gp BarData
--- @field levels table<integer, integer> Unsynced levels by job ID; class/job partners can share a level. Can include reserved IDs beyond FFXIV.JOBS.
--- @field revivestate number Raw revival-state code.
--- @field role number ClassJob.Role code (PLD=1 tank).
--- @field cangather boolean Whether the player can gather resources (specific to gathering jobs).
--- @field marker number Numeric marker value.
--- @field gauge table<integer, number> Job-specific gauge slots; no universal slot layout.
--- @field localmapid integer TerritoryType row ID; use for TaskManager travel/territory comparisons.
--- @field mapid integer Map-sheet row ID.
--- @field onlinestatus number Raw online-status code.
--- @field currentworld integer The current world (server) the player is in.
--- @field homeworld integer The home world (server) of the player.
--- @field guid string The player GUID; preserve as a string.
--- @field lastcomboid integer Raw combo/action ID.
--- @field combotimeremain number Reported combo timer in seconds; interpret alongside job/action state.
--- @field flying FlyingInfo
--- @field diving DivingInfo
--- @field camera PlayerCamera
--- @field settings PlayerMovementSettings
--- @field stats PlayerCraftGatherStats
--- @field pet Entity|nil Job pet when available.
--- @field race integer Race-sheet code; unavailable on generic Entity-list rows.
--- @field ilvl number Reported item level.
--- @field mountid integer
--- @field status integer Raw activity/status value.
Player = {}

--- Legacy Player FATE field.
--- Use GetFateList() for FATE data and Entity.fateid for associated enemies.
--- @deprecated
--- @type integer
Player.fateid = 0

--- @type integer
--- Max level difference to pick up side quests
QuestOpts_C_v1_Level = 3

--- Coordinates and rotation structure.
--- @class PlayerPosition : Position
--- @field h number Rotation (heading) in radians.
Player.pos = {x = 0, y = 0, z = 0, h = 0}

--- @return integer
function Player:GetFishingState()
end

--- @return integer Synced level; 0 while unsynced.
function Player:GetSyncLevel()
end

--- @param npcId integer entity.id of the target
function Player:Interact(npcId)
end

--- Native lookup-keyed rows, including unattuned aetherytes.
--- @return table<number, Aetheryte>
function Player:GetAetheryteList()
end

--- Request an in-game teleport; true indicates submission.
--- @param aetheryteId integer Aetheryte ID (row.id).
--- @return boolean
function Player:Teleport(aetheryteId) end

--- @return Entity|nil targeted entity
function Player:GetTarget() end

--- Attunement status of aether currents per map, read from game memory.
--- Only reliable while the "AetherCurrent" window is (or was recently) open.
--- @return table<integer, { mapid: integer, isattuned: boolean, status: table<integer, boolean> }> keyed by mapId
function Player:GetAetherCurrentsList() end

--- Clears the target.
--- @return boolean success
function Player:ClearTarget() end

--- Numeric stat accessor using native stat indices.
--- @param statId number Native stat index; validate the desired stat against a live context.
--- @return integer
function Player:GetStats(statId) end

--- Build/follow a navigation path. All three coordinates are required, even with targetid.
--- Cancels MoveToExact. Positive values indicate a path result.
--- @param x number
--- @param y number
--- @param z number
--- @param radius number|nil Final arrival radius; positive values clamped to 0.1..50.
--- @param floorfilters number|nil
--- @param cubefilters number|nil
--- @param targetid number|nil Optional path target hint; 0 is normalized to nil.
--- @return number Path result; 0 invalid/no path, negative errors, -1337 player-controlled transport.
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

--- Cancels navigation, exact movement, and autofollow.
--- The resetpath argument is ignored; movement/path state is always reset.
--- @param resetpath boolean|nil
function Player:Stop(resetpath)
    -- This is just a placeholder for the editor
end

--- @param targetId number target id
--- @return boolean success
function Player:SetTarget(targetId)
    -- This is just a placeholder for the editor
end


--- Gets planar distance. Position overload uses x/z in FFXIV.
--- @overload fun(a: XZ, b: XZ): number
--- @param x1 number
--- @param z1 number
--- @param x2 number
--- @param z2 number
--- @return number float distance
function math.distance2d(x1, z1, x2, z2)
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
--- @field percent number Truncated whole percentage; 0 when max is 0.

--- Host HP data. Values on non-character objects are object-type dependent.
--- @class HealthData : BarData
--- @field extra number Undocumented raw host field.

--- Party-member record.
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
--- Type-specific fields can be zero/default or unrelated-looking numeric data even when present.
--- Shared properties on non-character objects have object-type-dependent meanings.
--- @class Entity
--- @field __object userdata
--- @field attackable boolean
--- @field aggressive boolean
--- @field aggro boolean Entity aggro flag used by the "aggro" filter.
--- @field aggropercentage number Raw enmity percentage.
--- @field incombat boolean
--- @field interactable boolean
--- @field onmesh boolean
--- @field type number Host object type: 1 player, 2 battle NPC, 3 event NPC, 5 aetheryte, 6 gathering, 7 event object, 8 mount object.
--- @field chartype number Raw character-kind discriminator.
--- @field fateid number Associated FATE ID.
--- @field ownerid number
--- @field distance2d number X/Z center distance minus both entities' hitbox radii; can be negative.
--- @field mp BarData
--- @field gp BarData
--- @field cp BarData Crafting resource on applicable characters; unrelated-looking values can appear on objects.
--- @field pvpteam number Raw host team code.
--- @field spearfishstate number Raw spearfishing-related state; can be -1 and is object-type dependent.
--- @field eurekainfo EurekaInfo
--- @field name string The name of the entity
--- @field guid string Entity GUID; meaning depends on entity type.
--- @field currentworld integer World ID for player characters; may be a default on other types.
--- @field homeworld integer Home world ID for player characters; may be a default on other types.
--- @field marker number Raw marker value.
--- @field mountid integer Raw mount ID.
--- @field ismounted boolean Whether the entity is mounted.
--- @field mountcanfly boolean Mount flight capability.
--- @field level number Effective level, including level sync. Use Player.levels[Player.job] for base level.
--- @field id number The unique identifier for the entity
--- @field onlinestatus number|nil Raw online-status code.
--- @field contentId number The content ID of the entity
--- @field contentid number Alias of contentId.
--- @field alive boolean hp.current > 0.
--- @field buffs table<number, Buff> Sparse slot-keyed buff map. Use pairs.
--- @field job number ClassJob ID on applicable characters; non-character rows can contain values outside the playable job range.
--- @field pos PlayerPosition The position and heading of the entity.
--- @field meshpos EntityMeshPosition Mesh-point data requires a loaded mesh.
--- @field distance number 3D center-to-center distance from Player.
--- @field targetid number The ID of the current target of the entity
--- @field friendly boolean Host friendliness flag.
--- @field hp HealthData Host health-shaped data; meaningful combat HP is type-dependent.
--- @field castinginfo CastingInfo May be an empty table on NPCs/objects; guard its fields.
--- @field action number Raw host action state.
--- @field lastaction number Raw previous host action state.
--- @field eventid number Raw event-state value.
--- @field iconid number Raw displayed-icon value.
--- @field cangather boolean Host gathering flag.
--- @field gatherattempts number Raw remaining gathering attempts; meaningful only on applicable entity types.
--- @field gatherattemptsmax number Raw maximum gathering attempts; meaningful only on applicable entity types.
--- @field tp number Legacy/raw host field.
--- @field hitradius number Hitbox radius; may change with mount/state.
--- @field targetable boolean 
--- @field los boolean
--- @field los2 boolean Second host LoS flag.



--- Searches loaded entities with comma-separated filters; results are keyed by entity.id.
--- Pass an empty string for the host's enumerated set: EntityList("").
--- Use Get(Player.id) to retrieve the local player.
--- EntityList() / EntityList(nil) return zero values (nil in ordinary assignment).
--- No matches returns {}; use next(rows) or table.valid(rows) to check for results.
--- Get(missingId) returns zero values (nil in ordinary assignment). Re-fetch as entities despawn.
--- Returned player-character rows are Entity proxies.
---
--- Filter syntax:
--- * Combine distinct conditions with commas: "alive,attackable,targetable".
--- * Flags include alive, dead, attackable, aggressive, friendly, targetable,
---   incombat, notincombat, onmesh, los, targetingme, aggro, gatherable, myparty.
--- * type=N and chartype=N select one type. Use separate queries for multiple types.
--- * contentid=A;B includes either content ID; exclude_contentid=A;B excludes both.
--- * exclude=A;B compares low-32-bit entity IDs: id % 4294967296.
--- * name=Text matches the exact, case-sensitive name. Filter keys/flags were case-insensitive;
---   whitespace is significant: write `type=2,alive` without spaces.
--- * ownerid=N, targeting=N and fateid=N match the corresponding IDs.
--- * minlevel=N and maxlevel=N are inclusive and also require targetable entities.
--- * mindistance/maxdistance use entity.distance; the ...distance2d variants use
---   entity.distance2d. Positive decimal thresholds were truncated to integers in live probes.
---   distanceto=N changes the distance origin to a loaded entity.
--- * nearest picks the smallest entity.distance; lowesthealth picks the lowest hp.percent.
---   Both return at most one entry in a table. Choose one selector per query.
--- * targetingme matches targetid == Player.id. aggro matches the entity's aggro flag;
---   these sets can differ. incombat also includes entities fighting other targets.
--- Unknown filters are silently ignored. Inspect interactable and cangather properties in Lua.
--- `gatherable` is a recognized native filter.
--- Semicolon lists apply to contentid/exclude_contentid/exclude.
--- Repeated value-filters use the last value: "type=1,type=2" selects type 2.
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
---     return EntityList("targetable,exclude=" .. string.format("%.0f;%.0f", a % 4294967296, b % 4294967296))
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
--- -- Nearby entities around a known reference.
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

--- @alias ActionCast (fun(self: Action, target?: number): boolean)|(fun(self: Action, x: number, y: number, z: number): boolean)

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
--- @field CanCastResult fun(self: Action, target?: number): integer Cast-check status code; 0 is success. Also consult IsReady.
--- @field Cast ActionCast Target-ID or ground-coordinate overload; true indicates cast submission.
--- @field IsInRange fun(self: Action, target?: number): boolean Checks if the action is in range of cast + LoS checks

--- ActionList class that provides access to actions.
--- @class ActionList
ActionList = {}

--- @return boolean Current casting state.
function ActionList:IsCasting()
end

-- hides all minion gui windows.
function ToggleGUI()
end

--- Retrieves an action object based on its type and ID.
--- @param actiontype number The type of the action (e.g., 1 for abilities, 13 for mounts, etc.)
--- @param actionid number The unique identifier of the action.
--- @return Action|nil action The action object, or nil when absent.
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
--- the control is open first, issue one transition, then verify state on a later frame.
--- @param controlName string The name of the UI control to interact with (e.g., "ContentsFinderMenu").
--- @param actionName string The action to perform on the control (e.g., "Leave").
--- @param argValue any|nil optional argument to pass to the control
--- @param preDelay number|nil delay before starting the action execution
--- @param postDelay number|nil delay post action execution
--- @return boolean Only a truthy scalar Control:Action path returns true; false also covers queued/delayed/Close/Destroy actions. Verify UI separately.
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


--- A live FFXIV addon window handle.
--- `PushButton` and `DoAction` are low-level, control-specific operations whose
--- numbers must be discovered for the exact window/build. Prefer `Action` or
--- `UseControlAction` when a semantic action name is known.
--- Most things are doable via UIEvent better instead.
--- Return types can depend on the particular window.
--- @class Control
--- @field name string
--- @field PushButton fun(self: Control, pushButtonA: number, pushButtonB: number)
--- @field DoAction fun(self: Control, actionNumber: number)
--- @field Action fun(self: Control, actionName: string, ...: any): any Control-specific arguments/results; UseControlAction forwards up to three values.
--- @field GetStrings fun(self: Control): table<number, string> gets string values and their associated ids
--- @field Close fun(self: Control): boolean Closes the control; false can accompany a successful close. Verify with IsOpen later.
--- @field Open fun(self: Control): boolean Requests opening the control. Verify with IsOpen on a subsequent update.
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
--- available. Discover indexes with `Control:GetRawData()`.
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

---@class InventoryMateria
---@field itemid integer Materia item ID.
---@field name string Localized materia name.
---@field attribute integer Attribute ID.
---@field value number Attribute value.

--- @class BagItem
--- @field canmbsell boolean|nil Optional legacy market eligibility flag; absent means eligibility is unknown.
--- @field ptr number Raw pointer field; can be 0.
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
--- @field class integer Item.FilterGroup.
--- @field category integer Item.ClassJobCategory row ID.
--- @field uicategory number UI category
--- @field searchcategory number Search category
--- @field canequip boolean Native equipment eligibility.
--- @field equipslot integer Item.EquipSlotCategory.
--- @field price number Item.PriceLow (NPC sell metadata).
--- @field materiaslotcount integer Static guaranteed materia slots.
--- @field materias table<integer, InventoryMateria>
--- @field rarity number Item rarity
--- @field isunique boolean Whether item is unique
--- @field isuntradeable boolean Whether item cannot be traded
--- @field iscollectable boolean Collectable metadata flag.
--- @field desynthvalue number Raw Item.Desynth field.
--- @field repairclassjob integer Item.ClassJobRepair.
--- @field repairitem integer ItemRepairResource row/grade.
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
--- @field free integer Free slot count.
--- @field used integer Occupied slots; temporary rows may have count=0.
--- @field Get fun(self: Bag, baseId: integer): BagItem|nil First base-ID match in this bag, either quality. No HQ offset or extra args.
--- @field GetItem fun(self: Bag, slot: integer): BagItem|nil Zero-based physical slot; empty/out-of-range -> nil.
--- @field GetList fun(self: Bag): table<integer, BagItem>|nil Sparse slot+1 keyed map. Use pairs; callers must handle unavailable lists.
--- @field GetSortedItemList fun(self: Bag): table<integer, BagItem> Sparse display-sorted list. Use item's type/slot for actions.
--- @field RepairAll fun(self: Bag, useDarkMatter?: boolean): boolean True uses dark matter.

---@class InventoryItemLocation
---@field id integer Base ID.
---@field hqid integer Matched stack's quality-aware ID.
---@field bag integer Parent container ID.
---@field slot integer Zero-based physical slot.
---@field count integer Stack quantity.
---@field canequip boolean Native eligibility flag.

---@class InventoryItemDetails
---@field id integer Requested ID (HQ offset preserved if supplied).
---@field name string May initially be empty.
---@field ptr number Can be 0.
---@field max number Static maximum stack size.
---@field level integer Item.LevelItem.
---@field requiredlevel integer Item.LevelEquip.
---@field class integer Item.FilterGroup.
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
---@field itemid integer Currency item ID.
---@field name string May initially be empty.
---@field count integer Current quantity.

---@class InventoryAPI
Inventory = {}

---Return one bag or all available proxies.
---Retainer/FC/storage proxies require their corresponding content to be loaded.
---@overload fun(self: InventoryAPI): table<integer, Bag>
---@param bagId integer Container ID; advertised IDs can still return nil.
---@return Bag|nil
function Inventory:Get(bagId) end

---Native container catalog.
---@return integer[]
function Inventory:GetTypes() end

---Native total stack quantity, NQ+HQ; includes main/equipped/armoury/currency/crystals/key items.
---Special currencies excluded.
---Accepts exactly one numeric base-ID argument.
---@param baseId integer
---@return integer
function Inventory:GetItemCount(baseId) end

---Native HQ quantity by base ID. Missing -> 0.
---@param baseId integer
---@return integer
function Inventory:GetItemCountHQ(baseId) end

---Counts matching main-bag slots; explicit minimum=0 includes noncollectable slots.
---@param baseId integer
---@param minimum? number
---@param maximum? number
---@return integer
function Inventory:GetItemCountCollectable(baseId, minimum, maximum) end

---Native batch totals. Input format: {[baseId]=true}.
---Numeric keys and numeric values are treated as IDs.
---@param idSet table<integer, boolean>
---@return table<integer, integer> counts Includes requested missing IDs as 0.
function Inventory:GetItemCounts(idSet) end

---Native existence by base ID, either quality.
---@param baseId integer
---@return boolean
function Inventory:HasItem(baseId) end

---Native sparse set of found base IDs; absent IDs omitted.
---@param idSet table<integer, boolean> Numeric keys with boolean values.
---@return table<integer, true>
function Inventory:HasItems(idSet) end

---Native first-stack lookup. Result has no BagItem methods; re-fetch by bag/slot.
---@param baseId integer Numeric base ID, matches either quality; extra args break the lookup.
---@return InventoryItemLocation|nil
function Inventory:FindItem(baseId) end

---Native item metadata lookup. Nil can mean pending metadata; retry on a later frame.
---Calling GetStat on a metadata proxy can cause a native access violation.
---Use actual bag items for GetStat.
---@param itemId integer
---@return InventoryItemDetails|nil
function Inventory:GetItemDetails(itemId) end

---Native ordinary and special currency lookup; crafting crystals are excluded.
---@param itemId integer Currency item ID.
---@return integer
function Inventory:GetCurrencyCountByID(itemId) end

---@return table<integer, InventorySpecialCurrency> Keyed by item ID; names may load later.
function Inventory:GetSpecialCurrencies() end

---@return table<integer, number> Condition percentages keyed by ZERO-based equipped slot; empty slots omitted.
function Inventory:GetEquippedConditions() end

---Native game/chat item-search command with asynchronous chat results.
---True indicates submission; suitable for one-off requests.
---@param itemId integer
---@return boolean
function Inventory:SearchForItem(itemId) end

---Native unlock query; (2,mountId) checks a mount unlock.
---@param unlockType integer
---@param id integer
---@return boolean
function Inventory:IsUnlocked(unlockType, id) end

---Sorts inventory.
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

---@return ShopItem[] Shop rows; requires an open shop.
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

---Returns items available in the current exchange UI.
---@return ExchangeShopItem[]
function Inventory:GetItemExchangeList()
end

--- @param itemId integer
--- @param count number|nil how many items to buy, 1 default
function Inventory:BuyShopItem(itemId, count)
end

---Lua slot scan, exact hqid match (base ID = NQ only); custom containers honored.
---Default containers: main, equipped, currency, crystals, key items and armoury.
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

---Lua wrapper; slot is one-based. Defaults: slot 1, inventory 2000.
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
---HQ offset dispatch applies even when includehq=true.
---@param hqids integer[]
---@param inventoriesArg? integer[]|boolean
---@param includehqArg? boolean
---@return table<integer, InventoryCountRow>
function ItemCounts(hqids, inventoriesArg, includehqArg) end

---@class InventorySnapshotRow
---@field name string
---@field count integer NQ quantity.
---@field HQcount integer HQ quantity.

---Lua snapshot; default bags 0,1,2,3,1000,2004,2000.
---@param inventories? integer[]
---@return table<integer, InventorySnapshotRow> Keyed by base ID.
function GetInventorySnapshot(inventories) end

---Lua free-slot search; hqid must be nonzero.
---@param hqid integer
---@param inventories? integer[]
---@return integer|nil bagId
---@return integer|nil slot ONE-based; subtract 1 before native Move.
function GetFirstFreeSlot(hqid, inventories) end

---@return integer|nil bagId
---@return integer|nil slot ONE-based free slot in bags 0..3.
function GetFirstFreeInventorySlot() end

---@param bagId integer Armoury container ID.
---@return integer|nil bagId
---@return integer|nil slot ONE-based free slot.
function GetFirstFreeArmorySlot(bagId) end

---Legacy name: returns used>0 BOOLEAN for a resolved bag, numeric 0 fallback.
---@param equippedSlot integer Zero-based equipped slot.
---@return boolean|0
function ArmoryItemCount(equippedSlot) end

json = {}

--- Encodes a JSON-compatible value.
--- @param t any
--- @param params table|nil
--- @return string
function json.encode(t, params)
end

--- Decodes a JSON value. Returns value,nextPosition on success and
--- nil,errorPosition,errorMessage for invalid JSON. JSON null defaults to nil.
--- @param s string
--- @param position integer|nil Optional starting byte position (1-based).
--- @param nullValue any Value to substitute for JSON null; omitted means nil.
--- @param ... any Optional object/array metatables forwarded to the decoder.
--- @return any value
--- @return integer nextPosition
--- @return string|nil errorMessage
function json.decode(s, position, nullValue, ...)
end

function HttpRequest(params)
end

--- @return string Opaque runtime identifier.
function GetUUID()
end

--- Enriched FFXIVLib aetheryte row with optional coordinate metadata.
--- @class AetheryteInfo : Aetheryte
--- @field AetheryteId integer
--- @field TerritoryId integer
--- @field IsAetheryte boolean
--- @field AethernetGroup integer
--- @field RequiredQuest integer
--- @field Invisible boolean
--- @field aethid integer
--- @field pos Position|nil
--- @field WorldX number|nil
--- @field WorldY number|nil
--- @field WorldZ number|nil
--- @field x number|nil
--- @field y number|nil
--- @field z number|nil
--- @field AethernetName table<string, string>|nil
--- @field conversationstrings table<string, string>|nil

--- @param mapId integer
--- @param pos Position|nil position to choose better spot to tp to.
--- @return AetheryteInfo|nil aetheryte to tp to, if a suitable route exists
function GetAetheryteByMapID(mapId, pos)
end


--- @return number process id of ffxiv.
function GetCurrentPID()
end

--- Writes a file; omitted/false append truncates, true appends (creating if absent).
--- Requires existing parent directories. Returns false for a missing parent or directory destination.
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

--- Lists immediate entry names in a 1-based array.
--- Directories are excluded by default; includeDirectories=true includes them.
--- Empty/no matches returns {};
--- Missing or non-directory paths return false.
--- Filter is a case-sensitive, full-filename regular expression.
--- Omitted/nil/empty filter lists all files. Both slash styles work, with or
--- without a trailing separator. No ordering guarantee is assumed.
---@param path string
---@param filter string|nil e.g. [[(.*)lua$]]
---@param includeDirectories boolean|nil Include immediate directory names; defaults false.
---@return string[]|false
function FolderList(path, filter, includeDirectories)
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

--- Live character quest state using in-game quest IDs.
--- @class QuestClass
--- @field IsQuestCompleted fun(self: QuestClass, questId: number, something?: boolean): boolean Historical completion; second argument is optional and undocumented.
--- @field HasQuest fun(self: QuestClass, questId: number, leve: boolean|nil): boolean Checks whether the quest is active
--- @field GetQuestCurrentStep fun(self: QuestClass, questId: number, something: boolean|nil): integer Returns the live quest sequence; validate profile `complete.step` values against it
--- @field GetQuestList fun(self: QuestClass): table<integer, QuestJournalEntry> Sparse in-game quest-ID map; can include step=255 entries.
Quest = {}

--- @class QuestJournalEntry
--- @field id integer In-game quest ID.
--- @field name string
--- @field step integer Game quest sequence.
--- @field completed boolean Journal completion state.
--- @field I8A integer
--- @field I8B integer
--- @field I8C integer
--- @field I8D integer
--- @field I8E integer
--- @field I8F integer
--- @field I8AL integer
--- @field I8AH integer
--- @field I8BL integer
--- @field I8BH integer
--- @field I8CL integer
--- @field I8CH integer
--- @field I8DL integer
--- @field I8DH integer
--- @field I8EL integer
--- @field I8EH integer
--- @field I8FL integer
--- @field I8FH integer

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

--- @return ServerInfo[] Available servers; empty outside applicable lobby context.
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

--- Entity read surface.
--- Properties are lazy-cached on each returned proxy, including nested hp/pos/buff tables.
--- Reacquire for current values; keeping a proxy can retain already-read snapshots.
---@class TensorEntity : Entity

--- Per-Prepare filter-source cache; each call returns a fresh ID-keyed result table
--- and fresh lazy property proxies. Accepts myparty,alive,targetable and reordered
--- alive,myparty. Nearest uses the smallest host entity.distance after other party
--- predicates; tie ordering is unspecified.
---@param filter string
---@return table<number, TensorEntity>
function TensorCore.entityList(filter) end

--- Same argument key in one Prepare frame reuses the proxy. Missing returns nil, 0;
--- numeric and numeric-string IDs are accepted, but have distinct cache keys.
--- The complete argument tuple forms the cache key; extra values distinguish proxies.
---@param id number|string
---@return TensorEntity|nil entity
---@return 0|nil missingMarker
function TensorCore.mGetEntity(id) end

--- Cached local-player read surface.
---@class TensorPlayer : TensorEntity
---@field localmapid integer TerritoryType ID.
---@field mapid integer Map-sheet ID.
---@field levels table<integer, integer>
---@field gauge table<integer, number>
---@field flying FlyingInfo
---@field diving DivingInfo
---@field camera PlayerCamera
---@field settings PlayerMovementSettings
---@field stats PlayerCraftGatherStats
---@field race integer
---@field role number
---@field status integer
---@field pet Entity|nil
---@field grandcompany number
---@field grandcompanyrank number
---@field lastcomboid integer
---@field combotimeremain number
---@field ilvl number
---@field SetFacing fun(self: TensorPlayer, x: number, y: number, z: number)

--- Cached local-player proxy. Current native implementation exposes the scalar
--- SetFacing method; looking up
--- unsupported methods (including MoveTo/GetSyncLevel/SetTarget) can raise an error.
---@return TensorPlayer
function TensorCore.mGetPlayer() end

--- Original-provider-only native visitor, including Player.
--- Uses case-sensitive parsing and provider-specific distance/flag rules.
--- Calls callback(id, context) synchronously; true continues, false/nil stops.
--- This function is absent from the current NativeArgus compatibility surface.
---@alias TensorEntityVisitor fun(id: number, context: any): boolean|nil
---@class TensorCoreInternal
---@field GetEntityList (fun(filter: string, callback: TensorEntityVisitor, context?: any))|nil Original-provider-only synchronous visitor.
TensorCore.Internal = {}

--- Original legacy event queue; NativeArgus exposes an empty-table compatibility
--- result here while its actual native event dispatch uses separate services.
---@return table
function TensorCore.Internal.GetQueuedEvents() end

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

--- Rebuild selection from gQuestProfile and persist it to Settings.Questing.
--- Arguments are ignored; set gQuestProfile before calling.
function Questing.UpdateSelection()
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

--- Some task constructors use {} before receiving coordinates.
--- @class ml_pending_pos
--- @field x number|nil
--- @field y number|nil
--- @field z number|nil
--- @field h number|nil

--- @class ml_task
--- @field interactState string|nil Interaction handoff phase set by ffxiv_common_cne/ffxiv_navigation.
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
--- @field tryTP boolean|nil Optional legacy field.
--- @field useAethernetTickets boolean
--- @field disableTeleport boolean
--- @field setHomepoint boolean
--- @field delayTimer number|nil Optional delay timer.
--- @field delayTime number|nil Optional delay duration.
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

--- Factory for an unqueued mesh-navigation subtask.
--- Create resets NavigationManager's path and unstuck state.
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
--- Requires a current parent task. Movement runs asynchronously on subsequent task-hub updates.
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
--- @field initiatedPos ml_pending_pos Empty until a movement origin is recorded.

--- @class ml_task_GRIND_COMBAT : ml_task
--- @field name "GRIND_COMBAT"
--- @field targetid number
--- @field pos ml_pos?
--- @field betterTargetFunction function?
--- @field noTeleport boolean
--- @field nomount boolean Prevent mounting while this combat task owns execution.
--- @field noFateSync boolean
--- @field noFlee boolean
--- @field fleeHandled boolean
--- @field endOnDisengage boolean Complete when the selected enemy loses its target.
--- @field hadAggro boolean Set once endOnDisengage observes an enemy with a nonzero target ID.
--- @field attackThrottle boolean
--- @field attemptPull boolean
--- @field canEngage boolean?
--- @field safeDistance number?

--- Factory for an unqueued combat task. Create resets unstuck/exact movement.
--- Set targetid and submit the task to ml_task_hub.
--- @class ffxiv_task_grindCombat
ffxiv_task_grindCombat = {}

--- @return ml_task_GRIND_COMBAT
function ffxiv_task_grindCombat.Create() end

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
--- @field pos ml_pending_pos Constructor starts with {}.
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
--- @field pos ml_pending_pos Constructor starts with {}.
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
--- @class BlueMagicLevelingAPI
--- @field Enable boolean
--- @field TaskIndex integer
--- @field skilldata table
--- @field IgnoreSkills integer[]
--- @field skillnotlearn table<integer, {actionid: integer, learn: boolean}>
--- @type BlueMagicLevelingAPI|nil
BlueMagicLeveling = nil


--- Reads the cached ffxivminion.AetherCurrentData array.
--- Cold/empty cache returns false; refresh it from the AetherCurrent UI before relying on it.
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
---@param enforce boolean|nil Whether to replace an existing default.
function ml_mesh_mgr.SetDefaultMesh(mapId, name, enforce)
end

gStuckRemesh = true

--- Legacy Minion quest/profile globals; empty string while idle.
--- @type integer|string|nil
gCurrQuestID = nil
--- @type integer|string|nil
gCurrQuestObjective = nil
--- @type integer|string|nil
gCurrQuestStep = nil

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

---@return table<number, GameSetting> settings Game settings indexed by ID.
function GetGameSettings()
	return {}
end

--- @return integer Numeric game build/version value.
function GetGameVersion()
end

--- @deprecated
--- @type table|nil
AceLib = nil

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

--- @return string Opaque Minion launcher identifier.
function GetMinionAppUUID()
end


SkillMgr = {}

--- Cast using the active ACR when gACREnabled and a profile is selected; otherwise
--- fall back to Minion's skill profile.
--- @param entity Entity|Player|nil Target/precombat entity; some ACRs instead read Player:GetTarget().
--- @param preCombat boolean|nil Default false in the stock skill manager.
--- @param forceStop boolean|nil Default false in the stock skill manager.
--- @return boolean|nil Profile-dependent submission result.
function SkillMgr.Cast(entity, preCombat, forceStop)
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
--- `UseControlAction` or `Control:Action` when semantic actions are available.
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

--- Memoized entity-query function.
--- Missing matches normalize to nil; omitted criteria uses the empty filter.
--- @param criteria string|nil
--- @return table<number, Entity>|nil
function MEntityList(criteria) end

--- Represents a single aetheryte entry in the aetheryte list.
--- @class Aetheryte
--- @field id number Aetheryte ID.
--- @field name string Display/territory name; can be empty on unattuned native rows.
--- @field name2 string|nil Native localized destination name (e.g. Leynode Mnemo).
--- @field mapid number|nil Native territory/map ID.
--- @field internalid number|nil Native grouping ID.
--- @field levels table<integer, number>|nil Native level/metadata array.
--- @field ptr2 number|nil Additional native pointer field; can be 0.
--- @field territory number The territory ID where the aetheryte is located.
--- @field region number The region ID where the aetheryte is located.
--- @field price number The gil cost to teleport to this aetheryte.
--- @field isattuned boolean Whether the player is attuned to this aetheryte.
--- @field isfavpoint boolean Whether this aetheryte is marked as a favourite point.
--- @field ishomepoint boolean Whether this aetheryte is set as the player's home point.
--- @field islocalmap boolean Native local-map flag.
--- @field ptr number Internal pointer reference.
local Aetheryte = {}

--- Compatibility wrapper over FFXIVLib.API.Map.GetAetherytes.
--- force is retained but unused; true/false maps to attuned/unattuned filters.
--- @param force boolean|nil Legacy argument, currently unused.
--- @param attunementFlag 0|1|2|boolean|nil 0/all (default), 1/true attuned, 2/false unattuned.
--- @return table<number, AetheryteInfo> Keyed by aetheryte ID.
function GetAetheryteList(force, attunementFlag) end


--- @param id integer
--- @return Position|nil Nil when no location resolves.
function GetAetheryteLocation(id)
end

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
--- @field ptr number Raw pointer field; can be 0.
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
--- Returns an array with top-level x/y/z coordinates. Use f.id to retain FATE identity.
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

--- @param line string
--- @return string filtered string
function CleanConvoLine(line)
    -- sample impl, remove common special chars.
    local clean = string.gsub(line,"[()-/\x02\x16\x01\x03]","")
    return clean
end

--- Euclidean distance; both coordinate and Position-pair forms are supported.
--- @overload fun(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): number
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
