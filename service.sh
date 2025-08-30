#!/system/bin/sh

# Main script path
SMASH_SCRIPT="/data/adb/modules/QuiteKill/QuiteKill.sh"
TOGGLE_FILE="/sdcard/stopQuiteKill"

# Toaster 
popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity > /dev/null
    sleep 0.5
}

# Triple press config
THRESHOLD=2           # Time window in seconds
REQUIRED_PRESSES=3    # Number of presses
COOLDOWN=5            # Seconds to wait after each trigger

COUNT=0
START=0

while true; do
  # Exit if stop file exists
  if [ -f "$TOGGLE_FILE" ]; then
    echo "🛑 /sdcard/stopQuiteKill found | exiting Smash listener."
    popup "Key Smasher has been disabled"
    exit 0
  fi

  # Listen for Volume Up key
  key=$(getevent -qlc 1 | awk '/KEY_VOLUMEUP/ {print $3; exit}')
  
  if [ "$key" = "KEY_VOLUMEUP" ]; then
    now=$(date +%s)

    if [ "$((now - START))" -gt "$THRESHOLD" ]; then
      COUNT=1
      START=$now
    else
      COUNT=$((COUNT + 1))
    fi

    # Trigger QuiteKill script on triple press
    if [ "$COUNT" -ge "$REQUIRED_PRESSES" ]; then
      echo "📛 Triple Volume-Up detected | killing background apps."
      sh "$SMASH_SCRIPT" &
      COUNT=0
      popup "🔪Murdered all running apps 👉👈"
      sleep "$COOLDOWN"
    fi
  fi

  sleep 0.1
done