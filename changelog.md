# QuietKill ( v3 )
> Release Date: 30/08/2025

### What's New?

### Power-key listener (quick tap)
- Added low-CPU event reader using `/dev/input/event0` with raw power key codes (DOWN/UP).
- Added fallback polling loop using `getevent -lqc1` with 0.2s interval and 4s timeout.
- Added timestamped logging to `/data/adb/modules/QuiteKill/logs/kill.log` and ensured log dir creation.
- Added float diff with `bc` when available, falls back to `awk`.
- Auto-selects event source: uses `event0` if readable, otherwise falls back to polling.
- Preserved thresholds: `CLICK_THRESHOLD=0.3`, `COOLDOWN=5`.
- Removed popup UI integration. Replaced on-screen toasts with log entries.
- Removed `popup()` and `am start ... meow.helper.MainActivity`.
- Reduced CPU usage by eliminating tight loops and `seq`-based polling.

### Kill engine (`QuiteKill.sh`)
- Log file path changed from `$MODDIR/webroot/output.log` to `$MODDIR/logs/output.log`.
- Ignore list and ForceKill list parsing unchanged.
- Behavior unchanged: kills all user apps, kills only listed system apps.

### Web UI (`index.html`)
- Switched to Material Icons and Material Symbols. Added custom `Mona` font.
- New snackbar notifications (success, error, info). Replaced `alert()`.
- Added ripple effects and proper loading states for action buttons.
- Terminal panel upgrades:
  - Auto-scroll toggle
  - Live killed and skipped counters
  - Log filter search
  - Copy log
  - Export log
  - Clear log
- Export now writes to `/sdcard/kill-control-log.txt`.
- Input sanitization for package names when adding to lists.
- Theme improvements: new palette, shadows, larger radii, prefers-color-scheme support, persistent choice.
- Updated log source path to `$MODDIR/logs/output.log` to match backend.
- UI layout and list items refined. Truncates long package names with ellipsis.
- Removed emoji-only section headers and the old minimal log-controls row.

### Removals and structure cleanup
- Removed dependency on the popup helper app.
- Removed `webroot` as a log target. All logs standardized under `$MODDIR/logs/`.
- Removed legacy alert-based messaging.

### Impact
- Lower CPU usage and more reliable power key detection.
- Unified logging across backend and UI.
- Better UX with actionable log tools and clear status feedback.



# QuietKill ( v2.1 HOTFIX )
> Release Date: 30/06/2025

### What's New?
- **Removed** support for long-press power key to kill apps
- **Fixed** issue where script hash files weren't deleted after installation
- **Added** Popup Toaster to the ignore list by default
- **Improved** power button event handling for better responsiveness



# QuietKill ( v2 )
> Release Date: 30/06/2025

### What's New?

- **Added** support for pressing the power key to kill all background apps  
- **Added** support for holding the power key to kill all background apps  
- **Improved** WebUI with enhanced usability and performance  
- **Added** option to force kill system apps (especially useful for GApps-based ROMs)  
- **Added** consent confirmation prompt in the WebUI for safer interactions  
- **Enhanced** Dark Theme for a more consistent and visually appealing experience  
- **Optimized** script execution speed in WebUI, now running **2x faster**  

### Removed

- Volume up trigger functionality  
- Live terminal log output feature  
- Force kill on successful boot  
- Early init script



# QuietKill ( v1 )
> Release Date: 27/06/2025

- Initial release 

