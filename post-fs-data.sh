#!/system/bin/sh

MODDIR=${0%/*}

# Grant executable permissions
chmod +x "$MODDIR/service.sh"
chmod +x "$MODDIR/QuiteKill.sh"
chmod +x "$MODDIR/action.sh"

exit 0