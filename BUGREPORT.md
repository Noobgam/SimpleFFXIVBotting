# Reporting bugs

Report problems through [GitHub Issues](https://github.com/Noobgam/SimpleFFXIVBotting/issues).

## Create and upload a report

1. While logged in, open NoobgamSidekick's Bootstrap **Overview** tab and click **Bug Report**, or use **Create Bug Report** on its **Diagnostics** tab.
2. The addon creates `bugreport_YYYYMMDD_HHMMSS_encrypted.zip` inside `LuaMods\SimpleFFXIVBotting`, copies its path to the clipboard, and opens a prefilled GitHub issue.
3. Sign in to GitHub and attach the **entire encrypted ZIP**. The browser URL cannot attach the file automatically. If the browser does not open, [create an issue manually](https://github.com/Noobgam/SimpleFFXIVBotting/issues/new).
4. Replace the placeholder title and describe:
   - What you expected and what happened.
   - The selected mode, quest/duty and approximate time of the problem.
   - Steps to reproduce, exact error text and relevant screenshots.
5. Submit the issue. The addon does not submit it for you.

## Privacy and encryption

The report contains logs and shared coordination state, which may include character names. It is encrypted with the maintainer's public key. The ZIP contains `report.cms`; only the matching private key can decrypt it.

Upload the encrypted ZIP, not raw logs or older unencrypted reports. Issue text and screenshots are public: keep passwords and private information out of them.

No password, Python installation or extra archiver is required to generate a report. Keep the packaged `report-public.cer` in the addon folder. If encryption fails, the addon does not create a plaintext report or open the issue page; include the displayed error in a manual issue.

## Logs

Logs are stored in `SimpleFFXIVBotting/logs/<UUID>.YYYY-MM-DD.log`, using local calendar dates. The newest three daily files per UUID are retained. Cleanup runs at startup, after a new day's first write, and every five minutes while loaded, including when automation is disabled.

Old undated/hourly logs are left untouched. Encrypted reports include the logs automatically, so create a report soon after the problem occurs.

Installation and update instructions are in [INSTALL.md](INSTALL.md).
