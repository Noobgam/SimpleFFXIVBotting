# KDF (Kitanoi Dungeon Framework) Profile API Reference

This document describes how to write profiles for the Kitanoi Dungeon Framework (KDF).

## Table of Contents

- [Basic Structure](#basic-structure)
- [Core Fields](#core-fields)
- [Combat & Targeting](#combat--targeting)
- [Navigation & Movement](#navigation--movement)
- [Interactions](#interactions)
- [Avoidance](#avoidance)
- [Mechanics Handling](#mechanics-handling)
- [Overhead Markers](#overhead-markers)
- [Tethers](#tethers)
- [Limit Break](#limit-break)
- [Custom Logic](#custom-logic)
- [Utility Tables](#utility-tables)

---

## Basic Structure

Every profile is a Lua table assigned to a local variable `tbl`, returned at the end of the file.

```lua
local tbl = {
    name = "Dungeon Name",
    dutyid = 1234,
    -- ... fields
}
return tbl
```

---

## Core Fields

### `name`
**[string][required]** Display name of the profile.
```lua
name = "The Vault",
```

### `dutyid`
**[int][required]** The `localmapid` of the duty. Obtain it by entering the duty and running `d(Player.localmapid)` in the console.
```lua
dutyid = 1066,
```

### `mesh`
**[string][optional]** Name of the navmesh to load when entering the duty. Leave as `""` if no specific mesh is needed.
```lua
mesh = "[HM] - The Vault v2",
```

### `level`
**[int][optional]** Level of the duty.
```lua
level = 57,
```

### `expansion`
**[int][optional]** Expansion number (2 = ARR, 3 = HW, 4 = SB, 5 = ShB, 6 = EW).
```lua
expansion = 3,
```

### `creator`
**[string][optional]** Author of the profile. Use `\n` for multiple lines.
```lua
creator = "Kitanoi\nModified by Dialgo",
```

### `notes`
**[string][optional]** Notes displayed to the user. Use `\n` for line breaks.
```lua
notes = "Requires 8 characters.\n2 tanks, 2 healers, 4 dps.",
```

### `queuetype`
**[int][required]** How the duty is queued.

| Value | Type |
|-------|------|
| `1` | Synced (Duty Finder) |
| `2` | Unsynced |
| `3` | Trust |
| `4` | Squadron |
| `10` | Variant |
| `13` | Criterion |

```lua
queuetype = 2,
```

### `FFA`
**[bool][optional]** Free For All mode. When `true`, all characters navigate independently rather than following the tank.
```lua
FFA = false,
```

### `hacks`
**[bool][optional]** Reserved field. Set to `false`.
```lua
hacks = false,
```

### `requeuetimer`
**[int][optional]** Seconds to wait after leaving a duty before requeuing. Defaults to `15`.
```lua
requeuetimer = 10,
```

### `type`
**[string][optional]** Required for trust/story duties.
- `"story"` — MSQ story duty
- `"trust"` — Trust duty
- `"duty"` — Regular duty (default if omitted)
- `"vc"` — Variant/Criterion

```lua
type = "trust",
```

### `trustdata`
**[table][required if `type = "trust"`]**
```lua
trustdata = {
    mapid = 837,
    scenario = false,
},
```

### `levelsync`
**[bool][optional]** Used with `queuetype = 2` for Blue Mage solo level-synced entry.
```lua
levelsync = true,
```

### `minilvl`
**[bool][optional]** Queue with minimum item level.
```lua
minilvl = true,
```

---

## Combat & Targeting

### `bossids`
**[table][optional]** Content IDs of boss enemies. KDF will force melee range on these targets above 90% HP.
```lua
bossids = {
    3634, -- Ser Adelphel Brightblade
    3639, -- Ser Grinnaux The Bull
    3642, -- Ser Charibert
},
```

### `forcemeleerange`
**[table][optional]** Content IDs of enemies that should always be engaged at melee range.
```lua
forcemeleerange = {3642},
```

### `enemytargetdistance`
**[int][optional]** Radius around the tank to search for enemies to target. Increase if characters run past bosses. Defaults to `30`.
```lua
enemytargetdistance = 50,
```

### `prioritytarget`
**[table][required]** Enemies to target with priority. Higher priority number = targeted last when multiple are alive.
```lua
prioritytarget = {
    [1] = {contentid = 4401, priority = 1, type = "Archer"},
    [2] = {contentid = 3843, priority = 2, type = "Caster"},
},
```

### `prioritytargetdistance`
**[int][optional]** Search radius for priority targets. Defaults to `30`.
```lua
prioritytargetdistance = 40,
```

### `ignoretarget`
**[table][optional]** Content IDs to never target.
```lua
ignoretarget = {2667, 1234},
```

### `enemylos`
**[bool][optional]** When `true`, only target enemies with line of sight. When `false`, allows targeting through walls.
```lua
enemylos = true,
```

### `dontclearfriendlytargets`
**[table][optional]** Content IDs of friendly entities that should not have their target cleared (e.g. cannons you need to interact with while targeting).
```lua
dontclearfriendlytargets = {2005242, 2005243},
```

---

## Navigation & Movement

### `objectivedestinations`
**[table][required]** Navigation destination for each duty objective. Must have an entry for every objective in the duty.
```lua
objectivedestinations = {
    [1] = {objective = 1, pos = {x = 0.03, y = 0.09, z = 112.31}},
    [2] = {objective = 2, pos = {x = 49.50, y = 4.00, z = -79.79}},
    [3] = {objective = 3, pos = {x = 0.00, y = 0.01, z = -265.70}},
},
```

### `tankat`
**[table][optional]** Instructs the tank (or character with top aggro) to hold a specific position during a fight. Only applies to tanks or characters at the top of the aggro list.
```lua
tankat = {
    [1] = {
        contentid = 3642,
        frompercent = 100,
        topercent = 0,
        pos = {x = 0.18, y = 300, z = -7.57},
        desc = "Tank Charibert at north",
    },
},
```

| Field | Type | Description |
|-------|------|-------------|
| `contentid` | int | Enemy content ID |
| `frompercent` | int | Start HP% (higher value) |
| `topercent` | int | End HP% (lower value) |
| `pos` | table | `{x, y, z}` position |
| `desc` | string | Optional description |
| `reqs` | string | Optional Lua condition starting with `return` |

### `tankspecific`
**[table][optional]** Used when two tanks need to hold separate enemies at specific positions.
```lua
tankspecific = {
    [1] = {who = "tank1", type = "tankat",    pos = {x=1,y=2,z=3}, contentid = 12345},
    [2] = {who = "tank2", type = "tankat",    pos = {x=3,y=2,z=1}, contentid = 54321},
    [3] = {who = "tank1", type = "forcetarget", contentid = 12345},
    [4] = {who = "tank2", type = "forcetarget", contentid = 54321},
},
```

### `faceenemyaway`
**[table][optional]** Content IDs of enemies the tank should face away from the party when at 100% aggro.
```lua
faceenemyaway = {1680, 1677},
```

### `staybehindentity`
**[table][optional]** Content IDs of enemies that non-tanks without top aggro should stay behind. Only moves when there are no active AOEs and the character has no tether.
```lua
staybehindentity = {3639},
```

### `MaxFollowDist`
**[int][optional]** Maximum distance the tank can be ahead before stopping to wait for the party.
```lua
MaxFollowDist = 30,
```

### `FFA`
See [Core Fields](#core-fields). When `true`, all characters navigate independently.

### `meshchange`
**[table][optional]** Dynamically change the navmesh based on conditions.
```lua
meshchange = {
    [1] = {type = "percent", percent = 50, newmesh = "The Navel - Smallest", desc = "shrinking platform"},
    [2] = {type = "castid",  castid = 1234, newmesh = "Other Mesh", reverttimer = 20},
},
```

### `togglewalk`
**[table][optional]** Enable walking inside a polygon on a specific mesh (e.g. tightrope sections).
```lua
togglewalk = {
    [1] = {
        polygon  = {{x=12, z=21}, {x=21, z=12}, {x=38, z=38}},
        meshname = "Tightrope Mesh",
    },
},
```

### `excludeshortcut`
**[table][optional]** Prevents KDF from using shortcuts when the current objective step matches the key.
```lua
excludeshortcut = {
    [5] = true,
    [6] = true,
},
```

### `pausemovement`
**[table][optional]** Lua strings that return `true` to pause movement (e.g. waiting for a door to open).
```lua
pausemovement = {
    [[return math.distance3d(Player.pos, {x=0,y=-300,z=0}) <= 20
        and KitanoiFuncs.CheckRayCast({x=12,y=-299,z=0},{x=17,y=-299,z=0})]],
},
```

### `forcemove`
**[table][optional]** Force movement to a position when the player is inside a defined polygon.
```lua
forcemove = {
    [1] = {
        movetopos = {x=6.5, y=19.3, z=-454.3},
        polygon = {
            [1] = {x=2.61, y=19.3, z=-407.8},
            [2] = {x=12.2, y=19.3, z=-408.36},
            [3] = {x=12.2, y=19.3, z=-451.85},
            [4] = {x=2.61, y=19.3, z=-451.85},
        },
        desc = "bridge section",
    },
},
```

### `largerpulls`
**[table][optional]** Increases the pull radius. Designed for proper parties or solo tanks only.
```lua
largerpulls = {
    distance = 45,
},
```

---

## Interactions

### `interacts`
**[table][required]** Defines all interactable objects (loot, keys, doors, etc.). Field is required even if empty.
```lua
interacts = {
    [1]  = {contentid = 452,     priority = 1, type = "Boss 1 Loot"},
    [2]  = {contentid = 2005263, priority = 2, type = "Violet Switch"},
    -- Conditional interact: only when objective 1 is not complete
    [3]  = {contentid = 1004346, priority = 3, req = {objective = 1, complete = false}, type = "Key"},
    -- Conditional interact: only when no enemies are present
    [4]  = {contentid = 2000180, priority = 4, req = {type = "noenemy"}, type = "Device"},
    -- Conditional interact: only when objective counter equals a value
    [5]  = {contentid = 2001537, priority = 5, req = {objective = 1, value = 2}, type = "Chamber"},
    -- Conditional interact: only when objective has a specific name
    [6]  = {contentid = 1013331, priority = 6, req = {objective = 1, name = "???"}, type = "Collect"},
    -- Conditional interact: Lua condition
    [7]  = {contentid = 2007400, priority = 7, req = {type = "lua", lua = "return KitanoiFuncs.HasKI(2002006)"}, type = "Relic"},
},
```

#### `req` Options

| Option | Description |
|--------|-------------|
| `{objective = N, complete = bool}` | Only interact if objective N is/isn't complete |
| `{type = "noenemy"}` | Only interact when no enemies are present |
| `{objective = N, value = X}` | Only interact when objective N counter equals X |
| `{objective = N, name = "???"}` | Only interact when objective N has that name |
| `{type = "lua", lua = "return ..."}` | Custom Lua condition |

### `interactdistance`
**[int][optional]** Search radius for out-of-combat interacts. Defaults to `30`.
```lua
interactdistance = 50,
```

### `incombatinteract`
**[table][optional]** Interactions that happen during combat (e.g. pressing buttons, QTEs).
```lua
incombatinteract = {
    [1] = {
        interactid  = 2005541,
        type        = "interact",
        req         = {castingid = 4010, desc = "Cetacean Rage"},
        who         = "closest",
        desc        = "Interact with Magitek Field Generator",
    },
    -- Multiple IDs (semicolon-separated string)
    [2] = {
        interactid  = "2005544;2005545",
        type        = "interact",
        who         = "closest",
        desc        = "Dragon Killers",
    },
    -- Move and use action
    [3] = {
        interactid  = 54345,
        type        = "move",
        who         = "closest",
        buffid      = 90,
        pos         = {x=1, y=2, z=3},
        dist        = 15,
        action      = {type = 1, actionid = 24},
        desc        = "Move and place item",
    },
},
```

| Field | Description |
|-------|-------------|
| `interactid` | Content ID (int or semicolon-separated string) |
| `type` | `"interact"` or `"move"` |
| `who` | `"closest"` or `"all"` |
| `req` | Optional `{castingid, desc}` condition |
| `buffid` | Required for `"move"` type to trigger movement |
| `pos` | Destination position for `"move"` type |
| `dist` | Radius around `pos` to place item |
| `action` | `{type, actionid}` action to use after moving |

### `useaction`
**[table][optional]** Duty actions to use on targets or positions.
```lua
useaction = {
    [1] = {actiontree = 1, actionid = 9823, target = "target",   contentid = 6909, desc = "Shatterstone"},
    [2] = {actiontree = 1, actionid = 9824, target = "me",        contentid = 6909, desc = "Self buff"},
    -- Multiple content IDs: nearest entity is used for position
    [3] = {actiontree = 1, actionid = 12257, target = "enemypos", contentid = "297;298", desc = "Cannon"},
},
```

To find action IDs, use `KitanoiFuncs.FindAction("action name")` in the console.

---

## Avoidance

### `advancedavoid`
**[table][optional]** Defines avoidance behaviors for specific casts/channels. Also used for constantly-running custom logic.

```lua
advancedavoid = {
    -- Line-of-sight avoidance
    [1] = {castingid = 1028, type = "los",
           args = {entityone = 1678, entitytwo = 1677, dist = 10}},

    -- Move to a single fixed position (all characters stack)
    [2] = {castingid = 998, type = "singlefixed",
           pos = {[1] = {x=1, y=2, z=3}}},

    -- Move to assigned spread positions (one per character, 4 for 4-man, 8 for 8-man)
    [3] = {castingid = 8058, type = "multifixed",
           pos = {
               [1] = {x=-9.98, y=27.4, z=-198.46},
               [2] = {x=-10.02, y=27.4, z=-218.20},
               [3] = {x= 9.93, y=27.4, z=-218.25},
               [4] = {x= 10.04, y=27.4, z=-198.20},
           }},

    -- Face away from caster
    [4] = {castingid = 12587, type = "faceaway"},

    -- Move in front of the targeted enemy
    [5] = {castingid = 5557, type = "moveinfront"},

    -- Move behind the targeted enemy
    [6] = {castingid = 5558, type = "movebehind"},

    -- Move behind, at a specific distance
    [7] = {castingid = 12851, type = "movebehind", dist = 7},

    -- Move to left of enemy
    [8] = {castingid = 1234, type = "moveleftofenemy"},

    -- Move to right of enemy
    [9] = {castingid = 1234, type = "moverightofenemy"},

    -- Move to front-left of enemy
    [10] = {castingid = 5559, type = "movefrontleftofenemy"},

    -- Move to front-right of enemy
    [11] = {castingid = 5560, type = "movefrontrightofenemy"},

    -- Set distance from targeted enemy (clears target)
    [12] = {castingid = 16777, type = "setdistance", dist = 2, desc = "Stay close"},

    -- Set distance from a fixed world position
    [13] = {castingid = 16777, type = "setdistancefrom",
            pos = {x=0, y=1, z=3}, dist = 2},

    -- Move to nearest matching entity
    [14] = {castingid = 20999, type = "movetoentity",
            entitylist = "contentid=9511,maxdistance=30",
            targetable = false,
            desc = "Move to blue pool"},

    -- Trust NPC follow (follow a trust during a channel)
    [15] = {castingid = 74584, type = "trust"},

    -- Trust NPC with specific position
    [16] = {type = "trust",
            trusttype = {entity = 1234, pos = {x=1, y=2, z=3}, variance = 5}},

    -- Move behind the enemy relative to its facing
    [17] = {castingid = 15754, type = "movebehindofenemy", desc = "Corner attack"},

    -- Duty action trigger
    [18] = {castingid = 3809, type = "duty"},

    -- Custom inline function (runs every pulse)
    [19] = {
        type           = "custom",
        customdetails  = "function",
        functionname   = "customfunction",
        functioncode   = [[
            function customfunction()
                -- your logic here
            end
        ]],
    },

    -- Call a function from an external library/addon
    [20] = {
        type          = "custom",
        customdetails = "libraryfunction",
        functioncode  = "KitanoiFuncs.MyCustomFunction()",
    },
},
```

> **Note:** Custom entries run every pulse regardless of any cast condition. Always call `KitanoiSettings.avoidingtime = Now()` when issuing movement commands so KDF doesn't override your movement.

### `excludeavoid`
**[table][optional]** AOE/cast IDs that should **not** be avoided (e.g. stack markers you intentionally stand in).
```lua
excludeavoid = {4011, 4035, 4932},
```

### `dontexcludeaoe`
**[table][optional]** Forces avoidance of AOEs that would normally be excluded due to size thresholds.
```lua
dontexcludeaoe = {26579},
```

### `avoidentity`
**[table][optional]** Creates an avoidance zone around moving entities.
```lua
avoidentity = {
    [1] = {contentid = 1678, radius = 6},                    -- circle
    [2] = {contentid = 1678, radius = 6, type = "circle"},   -- explicit circle
    [3] = {contentid = 6073, type = "rectangle"},            -- rectangle in front of entity
},
```

### `meleeavoid`
**[bool][optional]** Enable or disable melee avoidance. Useful to disable for very large bosses.
```lua
meleeavoid = false,
```

### `disableavoid`
**[bool][optional]** Completely disable all avoidance for this profile.
```lua
disableavoid = true,
```

### `disablemeleeavoid`
**[table][optional]** Disable melee avoidance for specific content IDs only.
```lua
disablemeleeavoid = {8299},
```

### `avoidancetype`
**[int][optional]** Which avoidance engine to use. Use `1` (new). `2` is deprecated.
```lua
avoidancetype = 1,
```

### `overrideaoedetails`
**[table][optional]** Override how specific AOEs are interpreted by the avoidance engine.
```lua
overrideaoedetails = {
    length   = {[1234] = 5},          -- override length of a rectangle AOE
    fan      = {[4213] = "fan090"},   -- override cone angle (fan + 3-digit degrees)
    type     = {
        [4584]  = 10, -- donut
        [123]   = 2,  -- circle
        [1223]  = 3,  -- cone (also add to fan)
        [123222]= 11, -- cross
    },
    innerrad = {[1244] = 5},          -- inner radius for donut AOEs
},
```

### `puddledata`
**[table][optional]** Defines puddles left on the ground so the avoidance engine does not path into them.
```lua
puddledata = {
    [1] = {castid = 1023, radius = 5,  duration = 60, type = "player", desc = "Ice puddle on player"},
    [2] = {castid = 1024, radius = 6,  duration = 60, type = "ground", desc = "Ground puddle"},
},
```

### `pullenemyoutofpuddle`
**[bool][optional]** Attempts to pull the targeted enemy out of puddles defined in `puddledata`.
```lua
pullenemyoutofpuddle = true,
```

---

## Mechanics Handling

### `hasbuff`
**[table][optional]** Triggers an action when the player has a specific buff.

**Move mode** — move to a position when buff is active:
```lua
hasbuff = {
    [1] = {
        type           = "move",
        buffid         = 1538,
        stacksrequired = 3,        -- optional: only trigger at N stacks
        pos = {
            [1] = {x=112.07, y=0.20, z=100.17},
            -- ... one entry per party member (4 or 8)
        },
    },
},
```

**Interact mode** — interact with an object to remove a debuff:
```lua
hasbuff = {
    [2] = {
        type           = "interact",
        buffid         = 302,
        interactid     = "2002648;2002647",
        stacksrequired = 2,
    },
},
```

### `tankbuster`
**[table][optional]** Cast IDs of tank busters. Non-tanks or characters without top aggro will avoid.
```lua
tankbuster = {1718, 902},
```

### `tankswap`
**[table][optional]** Cast/channel IDs that trigger a tank swap.
```lua
tankswap = {9999, 4444},
```

### `autotankstance`
**[bool][optional]** Automatically manage tank stances. Requires auto-stances to be disabled in your ACR/skill profile.
```lua
autotankstance = true,
```

### `tankstancetargets`
**[table][optional]** Assign which tank holds which enemy.
```lua
tankstancetargets = {
    ["MT"] = {[1644] = true,  [2091] = false},
    ["OT"] = {[1644] = false, [2091] = true},
},
```

### `maintank`
**[string][optional]** Name of the character to designate as main tank. KDF uses the lower `Player.id` by default.
```lua
maintank = "Character Name",
```

### `tankmaintainaggro`
**[bool][optional]** Tank will attempt to maintain aggro on all enemies.

### `tankautoprovoke`
**[bool][optional]** Tank will automatically provoke when aggro is lost.

---

## Overhead Markers

### `overheadmarkers`
**[table][optional]** Handles overhead marker mechanics (stack, spread, etc.).

```lua
overheadmarkers = {
    -- Stack: all characters move to the same position
    [1] = {
        id          = 62,
        contentid   = "6221",           -- string; use ";" to separate multiple IDs
        desc        = "stack",
        type        = "move",
        detectwho   = "any",            -- "any" = react regardless of who has marker
        pos = {
            [1] = {x=0.29, y=0.40, z=0.35},
            [2] = {x=0.29, y=0.40, z=0.35},
            [3] = {x=0.29, y=0.40, z=0.35},
            [4] = {x=0.29, y=0.40, z=0.35},
        },
        timetoreturn = 5,               -- seconds before returning to returnpos
    },

    -- Spread: each character moves to their own position
    [2] = {
        id          = 23,
        contentid   = "6221",
        desc        = "spread",
        type        = "move",
        detectwho   = "me",             -- "me" = only react when I have the marker
        pos = {
            [1] = {x=-13.83, y=-0.12, z=-0.01},
            [2] = {x=-10.56, y=-0.12, z=-6.11},
            [3] = {x=  6.60, y=-0.12, z=-12.36},
            [4] = {x= 13.75, y=-0.12, z=-0.10},
        },
        returnpos = {
            [1] = {x=0.29, y=0.40, z=0.35},
            [2] = {x=0.29, y=0.40, z=0.35},
            [3] = {x=0.29, y=0.40, z=0.35},
            [4] = {x=0.29, y=0.40, z=0.35},
        },
        timetoreturn = 5,
    },

    -- Move to entity with the marker (e.g. stack on the marked boss)
    [3] = {
        id           = 62,
        contentid    = "9264",
        desc         = "stack on boss",
        type         = "move",
        detectwho    = "any",
        movetoentity = true,
        timetoreturn = 5,
    },

    -- Record only (for use in custom logic via KitanoiSettings)
    [4] = {
        id          = 225,
        contentid   = "9462",
        desc        = "ice marker",
        type        = "justrecord",
        detectwho   = "any",
        timetoreturn = 5,
    },
},
```

| Field | Type | Description |
|-------|------|-------------|
| `id` | int | Overhead marker ID |
| `contentid` | string | Boss content ID(s), semicolon-separated |
| `type` | string | `"move"` or `"justrecord"` |
| `detectwho` | string | `"me"` or `"any"` |
| `pos` | table | Positions per character (4 for 4-man, 8 for 8-man) |
| `returnpos` | table | Positions to return to after mechanic resolves |
| `timetoreturn` | int | Seconds to wait before returning |
| `movetoentity` | bool | Move to within 5y of the marked entity instead of fixed pos |
| `precise` | bool | If `false`, only moves if distance > 5y (for simultaneous avoidance) |
| `waitforaoe` | table | Wait for these AOE IDs to resolve before handling the marker |

---

## Tethers

### `tethers`
**[table][optional]** Handles tether mechanics.

```lua
tethers = {
    -- Avoid: create an avoidance circle around the tethered entity
    [1] = {
        id       = 12,
        type     = "avoid",
        radius   = 16,
        who      = "entityone",   -- "entityone" = tether source, "entitytwo" = tether target
        duration = 6,
        desc     = "Boss jump",
    },

    -- Move: go to one of the listed positions
    [2] = {
        id       = 17,
        type     = "move",
        priority = 1,
        pos = {
            -- One sub-table per character; each sub-table is a list of candidate positions
            [1] = {
                [1] = {x=-458.90, y=1.19, z=-531.26},
                [2] = {x=-441.77, y=0.00, z=-532.75},
            },
            [2] = {
                [1] = {x=-458.90, y=1.19, z=-531.26},
                [2] = {x=-441.77, y=0.00, z=-532.75},
            },
            -- ...
        },
        desc = "Tether spread positions",
    },
},
```

---

## Limit Break

### `limitbreak`
**[table][optional]** Automatically uses Limit Break when conditions are met.
```lua
limitbreak = {
    [1] = {contentid = 9505, percent = 15, level = 1, type = "melee"},
    [2] = {contentid = 9511, percent = 15, level = 2, type = "melee"},
    [3] = {contentid = 1234, percent = 95, level = 1, type = "squadron"},
},
```

| Field | Description |
|-------|-------------|
| `contentid` | Enemy to use LB on (must be targeted) |
| `percent` | Use LB when enemy HP is at or below this % |
| `level` | LB level (1, 2, or 3) |
| `type` | `"melee"`, `"ranged"`, `"magic"`, `"tank"`, `"healer"`, `"dps"`, `"squadron"` |

### `dontcastwhenlb`
**[bool][optional]** Pauses ACR/skill profile when LB conditions are met to allow faster LB execution. Does not work with MCR.
```lua
dontcastwhenlb = true,
```

---

## Custom Logic

### `reactions`
**[table][optional]** Event-driven responses. `cause` is evaluated every pulse; when it returns `true`, `effect` is executed once.
```lua
reactions = {
    [1] = {
        name   = "Knockback Immunity",
        cause  = [[
            return KitanoiFuncs.ScanForCaster2(16659)
                and ((ActionList:Get(1,7548).usable and not ActionList:Get(1,7548).isoncd)
                  or (ActionList:Get(1,7559).usable and not ActionList:Get(1,7559).isoncd))
        ]],
        effect = [[
            if (ActionList:Get(1,7548).usable and not ActionList:Get(1,7548).isoncd) then
                ActionList:Get(1,7548):Cast(Player.id)
            elseif (ActionList:Get(1,7559).usable and not ActionList:Get(1,7559).isoncd) then
                ActionList:Get(1,7559):Cast(Player.id)
            end
        ]],
    },
},
```

### `mapeffects`
**[table][optional]** Triggers Lua code when a specific map effect fires.
```lua
mapeffects = {
    [1] = {
        contentid = "123;654",
        a1 = 43,
        a2 = 128,
        a3 = 2,
        luacode = "d('Map effect triggered')",
    },
},
```

Map effect data is also stored to `KitanoiSettings.SavedMapEffects[stringKey]` and can be checked in custom logic:
```lua
local key = "43128002"  -- tostring(a1) .. tostring(a2) .. tostring(a3)
if KitanoiSettings.SavedMapEffects[key] ~= nil
   and TimeSince(KitanoiSettings.SavedMapEffects[key].timeadded) < 3000 then
    -- handle mechanic
end
```

### `timeline`
**[table][optional]** Runs Lua code between two timestamps relative to `KitanoiSettings.InCombatTimer`.
```lua
timeline = {
    [1] = {
        contentids = "1234;4321",
        starttime  = 1000,   -- ms after combat start
        endtime    = 3000,
        luacode    = "Player:MoveTo(x,y,z) KitanoiSettings.avoidingtime = Now()",
    },
},
```

### `syncon`
**[table][optional]** Syncs `KitanoiSettings.InCombatTimer` to a specific time when a condition is met.
```lua
syncon = {
    [1] = {
        details = "sync to 190s on annihilation cast",
        cause   = "return KitanoiFuncs.ScanForCast2(33024, 1)",
        time    = 190000,
    },
},
```

### `onentitydeath`
**[table][optional]** Runs Lua code when a named entity dies.
```lua
onentitydeath = {
    ["Satin Plume"] = "KitanoiNavigation.NavAPI.MoveTo(100,0,100) KitanoiSettings.avoidingtime = Now()+2000",
},
```

### `customgui`
**[string][optional]** ImGui code rendered inside the KDF GUI panel.
```lua
customgui = [[
    GUI:Text('My Profile Options')
    if myVar == nil then myVar = 1 end
    myVar, changed = GUI:InputInt('##myVar', myVar)
]],
```

---

## Utility Tables

### `dontcastwhenmoving`
**[bool][optional]** Prevents ACR/skill profiles from casting while moving. Does not work with MCR.
```lua
dontcastwhenmoving = true,
```

### `vcactions`
**[table][optional]** Variant dungeon actions to queue with. Defaults to Cure (0) and Rampart (4).
```lua
vcactions = {0, 4},
-- 0 = Variant Cure
-- 1 = Variant Ultimatum
-- 2 = Variant Raise
-- 3 = Variant Spirit Dart
-- 4 = Variant Rampart
```

### `snapshotdata`
**[table][optional]** Records entity positions at the moment a cast fires.
```lua
snapshots = {
    [1] = {castid = 3411, duration = 5, maxpoints = 5, radius = 9, note = "gunship"},
},
```

---

## Useful API Functions

```lua
-- Scan for a currently channeling entity
KitanoiFuncs.ScanForCaster2(id)                        -- returns bool
KitanoiFuncs.ScanForCaster2(id, nil, nil, true)        -- returns table

-- Scan for a recently cast ability
KitanoiFuncs.ScanForCast2(id, maxSeconds)              -- returns bool
KitanoiFuncs.ScanForCast2(id, maxSeconds, nil, true)   -- returns table

-- Find an action by name
KitanoiFuncs.FindAction("action name")

-- Load a dungeon profile from Lua
KitanoiFuncs.LoadDungeonTbl(tbl)

-- Get the current incomplete objective index
KitanoiFuncs.GetFirstNotCompleted()

-- Count active AOEs
KitanoiFuncs.HowManyAOES()

-- Add a circle to the avoidance table
KitanoiFuncs.puddledata[key] = {
    entity   = entityid,
    pos      = entity.pos,
    radius   = 10,
    duration = Now() + 10000,
}

-- Add a rectangle to the avoidance table
KitanoiFuncs.AvoidRectangle2(entityid, length, width, durationMs)
KitanoiFuncs.AvoidRectangleSpecific(pos, heading, width, key)  -- lasts 1 second

-- Exclude/include an AOE from avoidance dynamically
KitanoiSettings.DFIndexedExcludeAvoid[aoeId] = true   -- exclude
KitanoiSettings.DFIndexedExcludeAvoid[aoeId] = nil    -- re-include

-- Scratch variables for custom logic
KitanoiSettings.DFTimer   -- int
KitanoiSettings.DFTimer2  -- int
KitanoiSettings.StoreVar  -- table
KitanoiSettings.StoreVar2 -- table
-- ... DFTimer3-5, StoreVar3-5 also available
```

---

## Movement in Custom Code

When issuing movement commands from `advancedavoid` custom functions or `reactions`, always set the avoidance timer to prevent KDF from overriding your movement:

```lua
Player:MoveTo(x, y, z)
KitanoiSettings.avoidingtime = Now()

-- Or with a duration:
KitanoiNavigation.NavAPI.MoveTo(x, y, z)
KitanoiSettings.avoidingtime = Now() + 2000  -- hold for 2 seconds
```