# Installation

You can ask an LLM to install NoobgamSidekick using this file.

## Requirements

- TensorCore.
- LattyLib and respective questpacks, with its native quest runtime for MSQ.
- FFXIVLib and Minion Quest mode for the bundled class/role quests.
- KitanoiFuncs and Kitanoi Dungeon Framework for dungeon automation.

SebbsLib and Sebb's Class Quests Pack are not required.

## Install without Git

1. [Download the no-sebbs branch ZIP](https://github.com/Noobgam/SimpleFFXIVBotting/archive/refs/heads/no-sebbs.zip). This branch contains the bundled class-profile changes. No Git installation or GitHub account is needed.
2. Extract it using **Extract All** in Windows File Explorer.
3. Find the folder containing `module.def`, `main.lua`, and `gui.lua`. Rename it to **SimpleFFXIVBotting**.
4. Copy the whole folder into your Minion installation's `Bots\FFXIVMinion64\LuaMods` directory. Keep all packaged subfolders and `report-public.cer`.

   Default layout:

   ```text
   C:\MINIONAPP\Bots\FFXIVMinion64\LuaMods\SimpleFFXIVBotting\
       module.def
       main.lua
       gui.lua
       report-public.cer
       questing\
           class_quests.lua
   ```

   `module.def` must be directly inside `LuaMods\SimpleFFXIVBotting`, without an extra nested archive folder. Use your actual Minion installation path if different. The local development `scripts/` folder is not distributed or required.
5. Reload Lua in Minion, or restart the game with Minion attached. The menu entry is **NoobgamSidekick**.
6. Follow [USAGE.md](USAGE.md) to choose a mode and duty routing. Leave **Enabled** unchecked until configuration is complete.

### Check installation

With the addon loaded, **Noobgam Class Quests (Current Job)** should appear in the normal Questing profile dropdown, even while addon automation is disabled. Registration does not select the profile or start the bot.

## Update

1. Stop addon automation on every instance using the installation.
2. Download and extract the latest ZIP from the same branch.
3. Copy its contents into the existing `LuaMods\SimpleFFXIVBotting` folder and replace packaged files. Preserve `configs`, `shared` and `logs`; do not delete the addon folder first.
4. Reload Lua on every instance.

For troubleshooting and encrypted diagnostic uploads, see [BUGREPORT.md](BUGREPORT.md).
