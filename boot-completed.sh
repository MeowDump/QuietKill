#!/system/bin/sh

SMASH="/data/adb/modules/QuiteKill/Logs/QuiteKill.sh"

if [ -f "$SMASH" ]; then
  chmod +x "$SMASH"
  sh "$SMASH" >> /data/adb/modules/QuiteKill/boot.log 2>&1
fi

exit 0