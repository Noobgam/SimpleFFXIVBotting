---@meta
---@diagnostic disable: missing-return, lowercase-global
--- Editor-only declarations for Kitanoi addons; never load in the game.
--- Placeholder values are not runtime defaults. Export availability depends on
--- the installed addon/build; see docs/GLOBALS_TYPEHINT_AUDIT.md for audit limits.

--- Native-backed userdata; table syntax here is editor-only.
KitanoiFuncs = {}

--- @param addon "kdf"
--- @param status boolean
function KitanoiFuncs.EnableAddon(addon, status)
end

--- @param dungeonTable table
function KitanoiFuncs.LoadDungeonTbl(dungeonTable)
end

--- Whether to only check for map reachability
--- @type boolean
KitanoiFuncs.BypassVisibleNPCCheck = true

--- @type boolean Pass
KitanoiFuncs.PassItem = false

--- @type boolean Roll (Need/Greed)
KitanoiFuncs.NeedItem = true

KitanoiSettings = {
    SuppressAceLibNavErrors = false,
    SuppressAceLibNavErrorsForce = false,

    --- you can save arbitrary things in kitanoi funcs.
    --- @type any
    CustomVar1 = 0,
}

--- @type 1|2 standard|queue
KitanoiSettings.SingleOrQueue = 1

--- @type 1|2|3 none|msq|job
KitanoiSettings.KDFIntegration = 1

--- @type boolean Solo MSQ Dungeons
KitanoiSettings.AutoStoryDungeons = true

--- @class SavedMapEffect
--- @field a1 number
--- @field a2 number
--- @field a3 number
--- @field timeadded number

--- @type table<string, SavedMapEffect>
KitanoiSettings.SavedMapEffects = {}

--- @type boolean do trusts
KitanoiSettings.AutoTrusts = true

--- @type boolean do trusts
KitanoiSettings.AdditionalQuests = true

--- @type boolean in combat legacy movement
KitanoiSettings.ICLM = true

--- @type boolean force melee range
KitanoiSettings.DFForceMeleeRange = true

--- @type boolean Trust Selection Duty Support
KitanoiSettings.AutoLevelTrustsScenario = true

--- @class KnownMarker
--- @field target integer
--- @field markertype integer
--- @field deletetime integer
--- @field entityID2 integer

--- @type table<string, KnownMarker>
KitanoiSettings.knownmarkers = KitanoiSettings.knownmarkers

--- KDF funcs thing, stores/loads data in C:\MINIONAPP\Bots\FFXIVMinion64\LuaMods\KitanoiFuncs\Settings\Data
kIO = {}

--- Save current character settings; optional argument is a diagnostic label, not a path.
--- @param reason any
function kIO.save(reason)
end

--- Load current-character settings, or a named file stem under KitanoiFuncs/Settings/Data.
--- @param name string|nil Filename without .lua; defaults to sanitized Player.name.
function kIO.load(name)
end

KitanoiNavigation = {}
KitanoiNavigation.NavAPI = {}

--- Kitanoi navigation dispatcher; optional arguments are also forwarded to BETAMoveTo.
--- Arguments 5/6 remain undocumented rather than assigned guessed meanings.
--- @param x number
--- @param y number
--- @param z number
--- @param mapId integer|nil Defaults to current territory.
--- @param option5 any
--- @param option6 any
--- @param range number|nil Default 0.5.
--- @param cubeFilters number|boolean|nil true becomes 1; default 0.
--- @param rangeOverride number|nil Overrides range when supplied.
function KitanoiNavigation.NavAPI.MoveTo(x, y, z, mapId, option5, option6, range, cubeFilters, rangeOverride)
end

function KitanoiNavigation.NavAPI.Stop()
end

--- @class KBuy
--- @field mysettings table kitanoi-formatted table to buy
--- @field enable boolean

--- @type KBuy|nil
kBuy = nil

KDF = {
}

--- @return string name of current dungeon profile or "None"
function KDF.Name()
    return "Seat of Sacrifice"
end