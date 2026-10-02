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
*   **Duty Routing:** Choose multi-box helpers, Duty Finder for unsupported duties, or enable **Do not use helpers** together with **Use Duty Finder** to queue all detected story duties normally.

### Helper Mode
Use this mode on a carry character to clear story duties for another character being leveled.

| Character | Select in the **Mode** dropdown | Role |
| --- | --- | --- |
| Character being leveled | **Bootstrap** | **Farmer** — requests help when it reaches a supported story duty and joins the host's Party Finder listing. |
| Carry character | **Helper** | **Host** — waits for requests, creates a Party Finder listing, and runs the duty with the farmer as an Undersized Party. |

Check **Enabled** on both instances. **Do not select Helper on the character being leveled.** Host and Farmer are names for these roles, not additional settings you need to select.

Both instances must use the same `SimpleFFXIVBotting/shared` folder. The normal setup is two clients using the same Minion installation on one computer; separate installations do not communicate automatically. A second character is not needed when using Bootstrap with **Do not use helpers** and **Use Duty Finder** enabled.

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

---

## 🐛 Reporting Bugs

Report bugs through [GitHub Issues](https://github.com/Noobgam/SimpleFFXIVBotting/issues).

1. While logged in, click **Bug Report** on Bootstrap's **Overview** tab, or **Create Bug Report** on its **Diagnostics** tab. This generates an **encrypted ZIP** and opens a **prefilled GitHub issue** in your default browser.
2. Find the generated `bugreport_YYYYMMDD_HHMMSS_encrypted.zip` in your `LuaMods/SimpleFFXIVBotting` folder. The button also copies a message containing the ZIP's full path to your clipboard.
3. Sign in to GitHub if needed and **upload the ZIP as an attachment**. Attachments cannot be added through the prefilled URL. If the browser does not open, [open a new issue manually](https://github.com/Noobgam/SimpleFFXIVBotting/issues/new).
4. Replace the placeholder title and fill in the template: describe what you were doing, what you expected, and what happened instead. Include steps to reproduce and the exact error text or a screenshot, if available. Click **Submit new issue** when ready; the addon does not submit it for you.

The report includes logs and shared coordination state, which may contain character names. These diagnostics are encrypted using the maintainer's public key; only the matching private key can decrypt them. The outer ZIP contains only `report.cms` (encrypted data), not readable logs. Upload the **entire encrypted ZIP**, not raw logs or older unencrypted reports. Issue descriptions and screenshots remain public, so do not include private information in them.

No password, Python installation, or extra archiver is needed to generate reports. If encryption fails, the addon does not create a plaintext attachment or open the issue page.

