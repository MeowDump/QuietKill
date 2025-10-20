# QuietKill ( v4 )
> Release Date: 20/10/2025

### What's New?

1. Configurable Flags (via config.txt):
   - PARALLEL        : Enable parallel killing of apps.
   - MAX_JOBS        : Maximum concurrent jobs when running in parallel.
   - ONLY_RUNNING    : Kill only apps that are currently running.
   - SKIP_CRITICAL   : Skip critical/system apps automatically.
   - VERBOSE         : Print log messages to console during execution.
   - WILDCARD_IGNORE : Allow wildcard patterns in ignore list for flexible skipping.

2. Parallel Execution:
   - User apps can now be killed concurrently using multiple jobs for faster execution.
   - Controlled by PARALLEL and MAX_JOBS settings.

3. Wildcard Ignore Support:
   - Ignore list can now include wildcard patterns (if WILDCARD_IGNORE=1).
   - Improves flexibility for skipping multiple related apps.

4. Critical App Protection:
   - Automatically protects key system apps from being force-stopped.
   - Examples: android, com.android.systemui, com.android.settings, com.google.android.gms, launchers.

5. Pre-Kill Checks:
   - Verifies if the app is installed before attempting to kill.
   - Optionally skips apps not currently running (controlled by ONLY_RUNNING).
   - Skips apps listed in ignore list or considered critical.

6. Enhanced Logging:
   - Timestamped log messages for all operations.
   - Separate temporary files:
       - STATUS_OK    : Apps successfully killed.
       - STATUS_FAIL  : Apps skipped or failed to stop.
   - Verbose output to console if VERBOSE=1.

7. Temporary Directory:
   - TMPDIR used for intermediate tracking of killed/skipped apps.
   - Automatically cleaned after script finishes.

8. Elapsed Time & Summary:
   - Logs total runtime of the script.
   - Shows counts of killed apps vs skipped/failed apps.

9. Force List Enhancements:
   - Same checks applied to system apps listed in ForceKill.txt:
       - Ignore list
       - Critical apps protection
       - Installed/running verification

10. Auto-Creation of Config:
    - If config.txt is missing, it is automatically created with default flag values.

11. Improved Reliability:
    - Handles empty or missing ignore/force lists gracefully.
    - More modular code structure with functions like do_kill, kill_app_once, run_with_pool.
    - Prevents unnecessary attempts to kill non-installed or non-running apps.

12. Backward Compatibility:
    - Fully compatible with previous ignore.txt and ForceKill.txt formats.
    - Existing user and system app lists continue to work without modification.

