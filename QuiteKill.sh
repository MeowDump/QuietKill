#!/system/bin/sh

# Paths
MODPATH="/data/adb/modules/QuiteKill"
IGNORE="$MODPATH/ignore.txt"
FORCE="$MODPATH/ForceKill.txt"
LOG="$MODPATH/webroot/output.log"

# Reset log
> "$LOG"

# Load ignore list
IGNORE_LIST=""
if [ -f "$IGNORE" ]; then
  IGNORE_LIST=$(sed '/^$/d;/^#/d' "$IGNORE" | sort -u)
fi

# Load force-kill list
FORCE_LIST=""
if [ -f "$FORCE" ]; then
  FORCE_LIST=$(sed '/^$/d;/^#/d' "$FORCE" | sort -u)
fi

# Check if app is ignored
is_ignored() {
  echo "$IGNORE_LIST" | grep -q -x "$1"
}

# Kill with log
kill_app() {
  pkg="$1"
  label="$2"
  echo "⏳ [$label] Killing $pkg..." >> "$LOG"
  if am force-stop "$pkg"; then
    echo "✅ [$label] $pkg stopped" >> "$LOG"
  else
    echo "⛔ [$label] Failed to stop $pkg" >> "$LOG"
  fi
}

# Kill all user apps
echo "📱 Killing user-installed apps..." >> "$LOG"
pm list packages -3 | sed 's/package://' | while read -r pkg; do
  [ -z "$pkg" ] && continue
  is_ignored "$pkg" && echo "⚠️ [User] Skipped $pkg (in ignore list)" >> "$LOG" && continue
  kill_app "$pkg" "User"
done

# Kill only listed system apps from ForceKill.txt
if [ -n "$FORCE_LIST" ]; then
  echo "⚙️ Killing system apps from ForceKill.txt..." >> "$LOG"
  echo "$FORCE_LIST" | while read -r pkg; do
    [ -z "$pkg" ] && continue
    is_ignored "$pkg" && echo "⚠️ [Force] Skipped $pkg (in ignore list)" >> "$LOG" && continue
    kill_app "$pkg" "Force"
  done
else
  echo "⚠️ No system apps listed in ForceKill.txt." >> "$LOG"
fi

echo "🎯 Done." >> "$LOG"