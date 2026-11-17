# Using NoobgamSidekick

Install the addon and dependencies using [INSTALL.md](INSTALL.md), then open
**NoobgamSidekick** from the Minion menu. Leave **Enabled** unchecked while
configuring the mode and duty routing.

## Bootstrap — the character being levelled

1. Log in on the character and job you want to level.
2. Select **Bootstrap** in the **Mode** dropdown.
3. Choose Duty Finder or a local helper below.
4. Check **Enabled** to start. Uncheck it before changing setup or updating files.

Bootstrap coordinates MSQ, current-job quests, gear and story duties. Free class
quests are included for the job levelled, with class/role quest data through
level 100. It follows your equipped job automatically and returns to MSQ when no
eligible class quest remains. Game quest prerequisites and levels still apply.

### Duty Finder — one client

Enable both **Do not use helpers** and **Use Duty Finder** in Bootstrap settings.
This queues detected story duties normally without a second character. Duty
Finder is opt-in; it is off by default.

With helpers allowed, **Use Duty Finder** instead provides routing for unsupported
helper duties. With both helpers and Duty Finder disabled, the addon will wait
at duties that require a clear.

### Local helper — two characters

Run a second character locally, with Minion and this addon loaded. Both clients
must use the same `SimpleFFXIVBotting/shared` directory; using the same Minion
installation is the simplest setup.

| Character | Mode |
| --- | --- |
| Character being levelled (farmer) | **Bootstrap** |
| Carry character (host) | **Helper** |

On the farmer, leave **Do not use helpers** unchecked. Enable both instances when
ready. The farmer requests a supported clear; the host creates a Party Finder
listing and clears the duty with the farmer as an Undersized Party. Host and
farmer are role names, not extra mode choices.

Separate installations do not communicate automatically. Duty coverage is
incomplete: some duties require Duty Finder or manual handling.

## Use the bundled class profile directly

The addon automatically registers **Noobgam Class Quests (Current Job)** in the
normal Questing dropdown, even while NoobgamSidekick automation is disabled.
Registration leaves the selected profile and bot state unchanged.

To run only class quests, keep NoobgamSidekick automation disabled, choose Minion
Quest mode, select that profile and start Minion. It follows the equipped job;
no priority-job selection or SebbsLib installation is required.

BLU coverage is limited to the first continuing quest present in the capture.
Beastmaster is not included. The bundle has passed registration and syntax
checks; every job/role chain has not yet been validated end-to-end.

## Settings

- **Skip credits:** on by default. While enabled and in-game, closes credit
  screens after 2.5 seconds. Disable it to watch credits.
- **Enable circuit breakers:** off by default. Enables bounded recovery for
  stopped Latty, stationary Bootstrap and navigation failures, including Return
  where available. Recovery yields during combat, loading, duties and active
  handoffs.

## Ravana

Select **Ravana** for the specialized Ravana Extreme farming flow, then check
**Enabled** when ready.

## Troubleshooting

If the class profile is missing, confirm `questing/class_quests.lua` exists inside
`LuaMods/SimpleFFXIVBotting`, FFXIVLib is loaded, and Lua has been reloaded after
updating. Registration retries while the questing API is starting.

For errors or stuck progression, create an encrypted report using
[BUGREPORT.md](BUGREPORT.md).
