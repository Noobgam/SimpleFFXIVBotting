# NoobgamSidekick

**NoobgamSidekick** is a sophisticated automation suite designed to coordinate character progression, job transitions, and multi-box dungeon clears. It manages the interplay between Main Scenario Quests (MSQ) and Job Quests, ensuring characters stay geared and leveled without manual intervention.

---

## 🚀 Features

*   **Fully Automated MSQ:** Drives characters through the 1-100 storyline.
*   **Job & Role Quest Orchestration:** Detects level milestones to automatically pause MSQ and complete necessary Job/Role quests, including Soul Crystal acquisition.
*   **Multi-Box Carries:** Utilizes a shared file-system state to coordinate "Host" and "Farmer" roles for clearing unskippable dungeons. Notable exceptions for now are Cyrcus tower raids, WoL, Endsinger and Rubikante isn't tested well. Otherwise will complete all dungeons

---

## 🛠 Operation Modes

### Bootstrap Mode
The primary mode for character leveling.
*   **Common MSQ Cycle:** Continuously checks for gear upgrades, job quest availability, and dungeon roadblocks.
*   **Smart Transitions:** Automatically switches between MSQ and Job Quest profiles as levels are reached.

### Helper Mode
Designed for users running multiple game instances.
*   **Farmer:** When the character hits a story-required dungeon, it registers the requirement to the shared file and waits for an invite from the Host.
*   **Host:** Monitors a shared JSON file for "Clear Requests." When a request is found, it invites the lower-level character and enters the required dungeon as an Undersized Party.

### Ravana Mode
> [!CAUTION]
> **BAN RISK:** Using the **Ravana Farm** for prolonged or continuous periods (e.g., 24/7) is highly likely to result in account termination. Use at your own risk.

A specialized farming module for Ravana Extreme.
*   High-speed combat and movement logic specifically tuned for this encounter.
*   Automatic instance resetting and Gil tracking.

---

## 📦 Requirements

To function correctly, the following must be installed:
*   LattyLib with the native quest runtime.
*   Sebb's "Class Quests Pack" for all job transitions.

