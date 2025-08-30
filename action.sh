#!/system/bin/sh

FILE="/sdcard/stopQuiteKill"
SERVICE="/data/adb/modules/QuiteKill/service.sh"
LOG="/data/adb/modules/QuiteKill/logs/toggle.log"
PROP="/data/adb/modules/QuiteKill/module.prop"

# Logger
log() {
    echo "$(date '+%m-%d %H:%M:%S') - $1" | tee -a "$LOG"
}

# Function to update description in module.prop
update_description() {
    local status="$1"
    # Remove any existing status suffix in description
    sed -i '/^description=/c\description=Kills apps running in background to improve battery & device performance '"$status" "$PROP"
}

if [ -f "$FILE" ]; then
  rm -f "$FILE"
  echo "🟢 Power Key function ENABLED"
  log "Press to kill enabled"

  # Start the listener in background
  sh "$SERVICE" &

  update_description "(🟢 Enabled)"

else
  touch "$FILE"
  echo "🔴 Power Key function DISABLED"
  log "Press to kill disabled"

  update_description "(🔴 Disabled)"
fi
