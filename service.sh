#!/system/bin/sh

KILLER="/data/adb/modules/QuiteKill/QuiteKill.sh"
STOPPER="/sdcard/stopQuiteKill"

# Log & debug
DEBUG=0
log() { [ "$DEBUG" -eq 1 ] && echo "$@"; }

# Popup + vibration
popup() {
  am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity >/dev/null 2>&1
  sleep 0.5
}

# Config
PRESS_WINDOW=1
REQUIRED_PRESSES=1
LONG_PRESS_MIN=0.5
COOLDOWN=5

COUNT=0
START=0
DOWN_TIME=0
UP_TIME=0

while true; do
  [ -f "$STOPPER" ] && popup "Key Smasher disabled" && exit 0

  EVENT=$(getevent -lqc1)

  case "$EVENT" in
    *KEY_POWER*DOWN*)
      now=$(date +%s)

      # Double press logic
      if [ $((now - START)) -le $PRESS_WINDOW ]; then
        COUNT=$((COUNT + 1))
      else
        COUNT=1
      fi
      START=$now

      if [ "$COUNT" -ge "$REQUIRED_PRESSES" ]; then
        log "POWER button detected"
        sh "$KILLER" &
        popup "🤫🔪 Murdered all running apps (Lock)"
        COUNT=0
        sleep "$COOLDOWN"
      fi

      # Press start
      DOWN_TIME=$now
      ;;
    
    *KEY_POWER*UP*)
      UP_TIME=$(date +%s)
      if [ "$DOWN_TIME" -gt 0 ]; then
        HELD=$((UP_TIME - DOWN_TIME))
        if [ "$HELD" -ge "$LONG_PRESS_MIN" ]; then
          log "Long press detected ($HELD sec)"
          sh "$KILLER" &
          popup "🤫🔪 Murdered all running apps (Long)"
          COUNT=0
          sleep "$COOLDOWN"
        fi
        DOWN_TIME=0
      fi
      ;;
  esac
done