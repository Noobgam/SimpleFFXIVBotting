# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Lua addon for the **FFXIVMinion** bot framework (the "Module" system, see `module.def`). There is no build, no tests, no package manager — files are dropped into the FFXIVMinion mods folder and loaded directly. Lua 5.2 runtime; type hints in `.vscode/globals.lua` are consumed by sumneko's lua-language-server only (`.luarc.json`).

The addon (display name **NoobgamSidekick**) drives end-to-end character progression by orchestrating two upstream addons it does not own:
- **Questing** (FFXIVMinion built-in) — selects MSQ vs job/role quest profiles and toggles bot Run state.
- **KDF (Kitanoi Dungeon Framework)** — clears dungeons; profiles for it live in `kdfProfiles.lua`.

Most non-trivial behavior is composing those two with quest-state machines, not implementing combat or navigation from scratch.

## Module loading

`module.def` declares the file list and is the source of truth for load order:

```
main, gui, ravanafarm, navigationtask, bootstrap, private, utils, config, msqhelper, kdfProfiles, noobgamTaskManager
```

Every top-level Lua file uses the `if X == nil then X = {} end` idiom so reloads are idempotent. `main.lua` registers three event handlers: `Module.Initalize` → `preinit` (config + log shim), `Gameloop.Update` → `onUpdate` (per-tick driver), `Gameloop.Draw` → `GUI_Manager.Draw`.

`onUpdate` dispatches by `NoobgamConfigManager.Config.mode` (`Bootstrap` | `Ravana` | `Helper`) to one of three update functions. When the game is not `INGAME`, it resets all three subsystems.

## The three modes

- **Bootstrap** (`bootstrap.lua`) — drives 1–100 leveling. `CommonMsqCycle` runs every tick: open job-quest gear coffers from inventory → decide MSQ vs job/role profile from `Player.levels` and `QuestCompleted(...)` → if a story-required dungeon is detected, hand off to `MsqClearHelper` as farmer.
- **Helper** (`msqhelper.lua`) — multi-boxing. The `Bootstrap` farmer registers a "clear request" by writing to a shared JSON file; a separate game instance running in `Helper` mode reads it, invites the farmer, and enters as undersized party. Two shared files: `msq_clear_requests.json` (farmer→host) and `msq_pf_ready.json` (host→farmer for PF-based handoff).
- **Ravana** (`ravanafarm.lua`) — single-encounter farm loop for Ravana Extreme. Independent state machine, not used by the others.

## Cross-cutting patterns

**Per-module wait state.** Each subsystem (`MsqBootstrap`, `MsqClearHelper`, `RavanaFarm`, `NoobgamTaskManager`) keeps its own `WaitUntil` / `WaitCondition` / `BreakOutDelayMillis` and defines a local `wait(millis, breakOutCondition, breakOutDelayMillis)`. The update tick is **non-blocking** — long operations are encoded as "set wait window, return early, resume on next tick". Don't use `os.execute` sleeps or busy loops; emit waits.

**Quest-id-driven state machines.** Logic in `bootstrap.lua` and `msqhelper.lua` is gated on hard-coded XIV quest IDs from xivapi datamining (`QuestCompleted(id)`, `HasQuest(id)`, `Quest:GetQuestCurrentStep(id)`). When fixing progression bugs, the right answer is usually adding/correcting a quest ID, not rewriting control flow. Soul-crystal detection uses `Inventory:Get(1000):GetList()[14]`.

**`NoobgamTaskManager` is the queue, `NavigationTask` is the primitive.** Higher-level flows push tasks via `Schedule` / `PushSchedule` / `PushMultiple`; the Update loop dequeues one at a time and runs it through a fixed dispatch (`genericGoTo`, `createPF`, `joinPF`, `leaveParty`, `disbandParty`). `NavigationTask` wraps `ml_task_hub` / `ffxiv_task_movetomap` / `ffxiv_task_movetopos` and is what `genericGoTo` ultimately calls.

**Profile control surface.** `bootstrap.lua` toggles other addons by mutating their globals (`gQuestProfile`, `QuestOpts_*`, `gBotMode`, `FFXIV_Common_BotRunning`, `KitanoiFuncs.EnableAddon`, `NoobgamPrivateAPI.SetKDFTo*`) — these are not owned by this codebase. `utils.lua`'s `SwitchMode` / `SetQuestingProfile` are the right entry points; don't write to those globals directly elsewhere.

**Private KDF helpers.** `private.lua` exports `NoobgamPrivateAPI` with `SetKDFToMsqIntegration` and `SetKDFToNone`. It is regular source code and can be edited directly.

## Persistence

- Per-account config: `<minion-lua-mods>/SimpleFFXIVBotting/configs/<MinionAppUUID>.json` — `NoobgamConfigManager.ReadConfig()` / `SaveConfig()`.
- Shared multi-box state: `<minion-lua-mods>/SimpleFFXIVBotting/shared/{msq_clear_requests,msq_pf_ready}.json`.
- Logs: `<minion-lua-mods>/SimpleFFXIVBotting/logs/<MinionAppUUIDHex>.log` — `utils.lua` shims `_G.d` so every `d(...)` call also appends here. Use `d("[ModuleName] message")` for new logs.

## Unskippable content (deliberately excluded)

`msqhelper.lua` whitelists dungeon IDs `92`, `102`, `111` and short-circuits before farmer registration: alliance-raid `PushButton` flow is not implemented. Don't try to "fix" this without a working alliance-creation path.

## Distribution requirements (from README)

End users must have the **(Latty) 1-100 [Unlocked]** MSQ profile and **Sebb's Class Quests Pack** installed in FFXIVMinion's Questing addon — those names are referenced as string literals (`bootstrap.lua` `CONFIG.msqProfile` / `jobProfile`) and a fallback search for `" Class Quests"` is in place if the exact name is missing.
