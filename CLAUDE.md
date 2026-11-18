# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Lua addon for the **FFXIVMinion** bot framework (the "Module" system, see `module.def`). There is no build or package manager — files are dropped into the FFXIVMinion mods folder and loaded directly. Lua 5.2 runtime; type hints in `.vscode/globals.lua` are consumed by sumneko's lua-language-server only (`.luarc.json`). LattyLib is an external runtime dependency; this repository deliberately does not carry a copied `latty.lua` API declaration.

The addon (display name **NoobgamSidekick**) drives end-to-end character progression by orchestrating two upstream addons it does not own:
- **LattyLib native quest runtime** — drives MSQ plus Aether Current quests independently of Minion's Quest bot mode.
- **Questing** (FFXIVMinion/FFXIVLib) — executes the bundled current-job class/role quest profile.
- **KDF (Kitanoi Dungeon Framework)** — clears dungeons; profiles for it live in `kdfProfiles.lua`.

Most non-trivial behavior is composing those two with quest-state machines, not implementing combat or navigation from scratch.

## Module loading

`module.def` declares the file list and is the source of truth for load order:

```
auto_shims, main, gui, ravanafarm, navigationtask, bootstrap, private, log_rotation, utils, config, msqhelper, kdfProfiles, noobgamTaskManager, circuit_breaker
```

Every top-level Lua file uses the `if X == nil then X = {} end` idiom so reloads are idempotent. `main.lua` registers three event handlers: `Module.Initalize` → `preinit` (config + log shim), `Gameloop.Update` → `onUpdate` (per-tick driver), `Gameloop.Draw` → `GUI_Manager.Draw`.

`onUpdate` dispatches by `NoobgamConfigManager.Config.mode` (`Bootstrap` | `Ravana` | `Helper`) to one of three update functions. When the game is not `INGAME`, it resets all three subsystems.

## The three modes

- **Bootstrap** (`bootstrap.lua`) — drives 1–100 leveling. `CommonMsqCycle` handles gear coffers and required-dungeon handoffs, then uses the original thresholded job milestones (30/50/60/70 plus MSQ gates) to interleave class quests and MSQ. It does not use `NoobgamClassQuests.HasWork()` to schedule every available quest. The profile's pin chooses the milestone branch for an equipped base class. `main.lua` calls `MsqBootstrap.RegisterClassProfile()` during addon initialization and retries publication once per second before automation/state/task guards. The shared loader uses `loadfile` for `questing/class_quests.lua`, so the profile is not added to `module.def`. It appears in the normal Questing dropdown even while automation is disabled. Local generators, templates, the capture manifest (`scripts/class_quests.manifest.json`), and decryption tools live in the entirely gitignored `scripts/` directory.
- **Helper** (`msqhelper.lua`) — multi-boxing. The `Bootstrap` farmer registers a "clear request" by writing to a shared JSON file; a separate game instance running in `Helper` mode reads it, invites the farmer, and enters as undersized party. Two shared files: `msq_clear_requests.json` (farmer→host) and `msq_pf_ready.json` (host→farmer for PF-based handoff).
- **Ravana** (`ravanafarm.lua`) — single-encounter farm loop for Ravana Extreme. Independent state machine, not used by the others.

## Cross-cutting patterns

**Per-module wait state.** Each subsystem (`MsqBootstrap`, `MsqClearHelper`, `RavanaFarm`, `NoobgamTaskManager`) keeps its own `WaitUntil` / `WaitCondition` / `BreakOutDelayMillis` and defines a local `wait(millis, breakOutCondition, breakOutDelayMillis)`. The update tick is **non-blocking** — long operations are encoded as "set wait window, return early, resume on next tick". Don't use `os.execute` sleeps or busy loops; emit waits.

**Quest-id-driven state machines.** Logic in `bootstrap.lua` and `msqhelper.lua` is gated on hard-coded XIV quest IDs from xivapi datamining (`QuestCompleted(id)`, `HasQuest(id)`, `Quest:GetQuestCurrentStep(id)`). When fixing progression bugs, the right answer is usually adding/correcting a quest ID, not rewriting control flow. The bundled class profile retains current-class soul-crystal equip tasks. Its single file groups authored data in `jobSpecificQuests` and `roleQuests`; one final pass builds `P.Quests` and injects job/pin/level guards. Redundant job predicates implied by each quest's allowed jobs are removed from prerequisites and top-level step conditions; narrower, compound and completion predicates are retained.

**`NoobgamTaskManager` is the queue, `NavigationTask` is the primitive.** Higher-level flows push tasks via `Schedule` / `PushSchedule` / `PushMultiple`; the Update loop dequeues one at a time and runs it through a fixed dispatch (`genericGoTo`, `createPF`, `joinPF`, `leaveParty`, `disbandParty`). `NavigationTask` wraps `ml_task_hub` / `ffxiv_task_movetomap` / `ffxiv_task_movetopos` and is what `genericGoTo` ultimately calls.

**Profile control surface.** `bootstrap.lua` starts/stops MSQ through `LattyLib.StartQuesting` / `StopQuesting` and pins Latty to MSQ + Aether Current quests. Class/role quests use `Noobgam Class Quests (Current Job)`, registered via `FFXIVLib.Questing.AddProfile`. The bundled data has no SebbsLib dependency or addon expansion gates; game prerequisites and current-job/level checks remain. Profile options → Classes → Pin job is saved in `Settings.Questing.NoobgamClassQuestPinnedJob`. It selects the quest branch and soul crystal for the equipped job/base class (especially Arcanist → Scholar/Summoner), without switching from an unrelated job. KDF is controlled through `NoobgamPrivateAPI.SetKDFTo*`.

**Private KDF helpers.** `private.lua` exports `NoobgamPrivateAPI` with `SetKDFToMsqIntegration` and `SetKDFToNone`. It is regular source code and can be edited directly.

## Persistence

- Per-account config: `<minion-lua-mods>/SimpleFFXIVBotting/configs/<MinionAppUUID>.json` — `NoobgamConfigManager.ReadConfig()` / `SaveConfig()`.
- Shared multi-box state: `<minion-lua-mods>/SimpleFFXIVBotting/shared/{msq_clear_requests,msq_pf_ready}.json`.
- Logs: `<minion-lua-mods>/SimpleFFXIVBotting/logs/<MinionAppUUIDHex>.YYYY-MM-DD.log` — `utils.lua` shims `_G.d` and appends to the local calendar day's file. `log_rotation.lua` retains the newest three daily files per UUID (not a rolling age window), pruning all UUIDs on startup, after a new day's first write, and every five minutes while loaded, even with automation disabled. Undated/hourly logs are untouched; no migration. Bug reports copy the entire logs directory. Use `d("[ModuleName] message")` for new logs.

## Unskippable content (deliberately excluded)

`msqhelper.lua` whitelists dungeon IDs `92`, `102`, `111` and short-circuits before farmer registration: alliance-raid `PushButton` flow is not implemented. Don't try to "fix" this without a working alliance-creation path.

## Distribution requirements (from README)

End users need **LattyLib** for MSQ and **FFXIVLib/Minion Quest mode** to execute the bundled class/role profile. **SebbsLib and Sebb's Class Quests Pack are not required.** No fallback to a separately installed class pack is used. See `USAGE.md` for coverage and validation limits. Local regeneration metadata lives in the ignored `scripts/` directory.
