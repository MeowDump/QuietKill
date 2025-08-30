#!/system/bin/sh

KILLER="/data/adb/modules/QuiteKill/QuiteKill.sh"
STOPPER="/sdcard/stopQuiteKill"

DEBUG=0
log() { [ "$DEBUG" -eq 1 ] && echo "$@"; }

popup() {
  am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity >/dev/null 2>&1
  sleep 0.5
}

CLICK_THRESHOLD=0.3  # Max seconds to count as quick click
COOLDOWN=5

while true; do
  [ -f "$STOPPER" ] && popup "Key Smasher disabled" && exit 0

  EVENT=$(getevent -lqc1)

  case "$EVENT" in
    *KEY_POWER*DOWN*)
      DOWN_TIME=$(date +%s.%N)

      # Wait up to 4s for a UP event
      for i in $(seq 1 40); do
        sleep 0.1
        NEXT=$(getevent -lqc1)
        case "$NEXT" in
          *KEY_POWER*UP*)
            UP_TIME=$(date +%s.%N)
            DIFF=$(awk "BEGIN {print $UP_TIME - $DOWN_TIME}")

            if awk "BEGIN {exit !($DIFF < $CLICK_THRESHOLD)}"; then
              log "Quick tap detected ($DIFF sec)"
              sh "$KILLER" &
              popup "🤫🔪 Murdered all running apps (Quick Tap)"
              sleep "$COOLDOWN"
            else
              log "Long press ignored ($DIFF sec)"
            fi
            break
            ;;
        esac
      done
      ;;
  esac
done