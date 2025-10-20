#!/system/bin/sh

# Paths
MODDIR=${0%/*}
LOG="/sdcard/installation.log"
UPDATE="/data/adb/modules_update/QuiteKill"
mkdir -p "$MODPATH/logs"
OLD_MOD_PATH="/data/adb/modules/QuiteKill"
UPDATE_MOD_PATH="/data/adb/modules_update/QuiteKill"

# Files to preserve
FILES="ForceKill.txt ignore.txt"

# Load module details
MODNAME=$(grep_prop name $TMPDIR/module.prop)
MODVER=$(grep_prop version $TMPDIR/module.prop)
AUTHOR=$(grep_prop author $TMPDIR/module.prop)
TIME=$(date "+%d, %b - %H:%M %Z")

# Gather system info
BRAND=$(getprop ro.product.brand)
MODEL=$(getprop ro.product.model)
DEVICE=$(getprop ro.product.device)
ANDROID=$(getprop ro.system.build.version.release)
SDK=$(getprop ro.system.build.version.sdk)
ARCH=$(getprop ro.product.cpu.abi)
CHIPSET=$(getprop ro.device.chipset)
DISPLAY=$(getprop ro.device.display_resolution)
BUILD_DATE=$(getprop ro.system.build.date)
MAINTAINER=$(getprop ro.device.maintainer)
ROM_TYPE=$(getprop ro.system.build.type)
FINGERPRINT=$(getprop ro.system.build.fingerprint)
SE=$(getenforce)
KERNEL=$(uname -r)

# Logger
debug() {
    echo "$1" | tee -a "$LOG"
}

# Meow Redirect
release_source() {
    [ -f "/data/adb/Box-Brain/noredirect" ] && return 0
    nohup am start -a android.intent.action.VIEW -d https://t.me/MeowDump >/dev/null 2>&1 &
}

# Header
debug " "
debug "┌──── Module Info ────────────────────┐"
debug "│ $MODNAME "
debug "│ By $AUTHOR"
debug "│ Version: $MODVER"
debug "│ Started at: $TIME"
debug "└────────────────────────────────────┘"
debug " "

# Root check
debug "┌── Root Info ────────────────────────┐"
if [ "$BOOTMODE" ] && [ "$KSU" ]; then
  debug "│ Provider       : KernelSU"
  debug "│ Kernel Version : $KSU_KERNEL_VER_CODE"
  debug "│ KSU Version    : $KSU_VER_CODE"
  [ "$(which magisk)" ] && {
    debug "│ ⚠ Multiple root systems detected!"
    debug "└───────────────────────────────────┘"
    abort   "Please use only KernelSU or Magisk."
  }
elif [ "$BOOTMODE" ] && [ "$MAGISK_VER_CODE" ]; then
  debug "│ Provider        : Magisk"
  debug "│ Magisk Version  : $MAGISK_VER_CODE"
else
  debug "│ Root      : Unknown / Unsupported"
  debug "└───────────────────────────────────┘"
  abort "Please install via Magisk or KernelSU (no recovery support)"
fi
debug "└───────────────────────────────────┘"
debug " "

# Device block
debug "┌── Device Info ─────────────────────┐"
debug "│ Brand      : $BRAND"
debug "│ Model      : $MODEL"
debug "│ Device     : $DEVICE"
debug "│ Arch       : $ARCH"
debug "│ Android    : $ANDROID (SDK $SDK)"
debug "│ Kernel     : $KERNEL"
debug "└───────────────────────────────────┘"
debug " "

# ROM block
debug "┌── ROM Info ────────────────────────┐"
debug "│ ROM Type   : $ROM_TYPE"
debug "│ Build Date : $BUILD_DATE"
debug "│ SELinux    : $SE"
debug "└───────────────────────────────────┘"
debug " "

# Verify ZIP
  if [ -n "$ZIPFILE" ] && [ -f "$ZIPFILE" ]; then
    debug " "
    debug " ✦ Checking Module Integrity..."

    if [ -f "$UPDATE/verify.sh" ]; then
      if sh "$UPDATE/verify.sh"; then
        debug " ✦ Verification completed successfully"
      else
        debug " ✘ Verification failed"
        exit 1
      fi
    else
      debug " ✦ verify.sh not found ❌"
      exit 1
    fi
  fi

# Preserve config files from old version 
debug " ✦ Checking for existing config files..."
for FILE in $FILES; do
  if [ -f "$OLD_MOD_PATH/$FILE" ]; then
    debug " ✦ Preserving $FILE"
    cp -f "$OLD_MOD_PATH/$FILE" "$UPDATE_MOD_PATH/$FILE"
    chmod 644 "$UPDATE_MOD_PATH/$FILE"
  fi
done

echo " "
echo " "
echo " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣄⣠⣄⠀"
echo " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⠏⠀"
echo " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀"
echo " ⠀⠀⠀⠀⣀⡤⣤⠶⠛⠉⠉⠀⠀⠉⠉⠛⠲⣤⣤⣄⠀⠀⠀⠀⠀"
echo " ⠀⠀⠀⡼⠃⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠈⢧⠀⠀⠀⠀"
echo " ⠀⠀⡼⢁⡆⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⢰⡈⢧⠀⠀⠀"
echo " ⢀⡞⠁⣸⠁⠀⢠⠬⠓⠀⣀⠀⠀⢀⠀⠛⠥⣄⠀⠀⡇⠈⢳⡀⠀"
echo " ⡞⠀⠀⠹⣆⢰⣒⠆⠀⠀⠓⠊⠙⠚⠁⠀⠸⠭⠇⣰⠇⠀⠀⢻⠀"
echo " ⣇⠀⠀⠀⠈⣹⠶⠦⠤⠤⣤⣤⣤⡤⠤⠤⠴⠶⣏⠁⠀⠀⠀⣸⠁"
echo " ⠈⠓⠲⠖⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠲⠶⠚⠁⠀"
echo " "
echo " "
release_source
exit 0
