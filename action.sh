#!/system/bin/sh

FILE="/sdcard/stopQuiteKill"
SERVICE="/data/adb/modules/QuiteKill/service.sh"

# Toast popup
popup() {
  am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity >/dev/null 2>&1
  sleep 0.5
}

if [ -f "$FILE" ]; then
  rm -f "$FILE"
  echo "🟢 Power Key function ENABLED"
  popup " Press to kill enabled"

  # Start the listener in background
  sh "$SERVICE" &

else
  touch "$FILE"
  echo "🔴 Power Key function DISABLED"
  popup " Press to kill disabled"
fi