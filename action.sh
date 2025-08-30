#!/system/bin/sh

FILE="/sdcard/stopQuiteKill"
SERVICE="/data/adb/modules/QuiteKill/service.sh"

if [ -f "$FILE" ]; then
  rm -f "$FILE"
  echo "🟢 Volume+ function ENABLED"

  # Start the listener in background
  sh "$SERVICE" &

else
  touch "$FILE"
  echo "🔴 Volume+ function DISABLED"
fi