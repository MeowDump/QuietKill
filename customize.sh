#!/system/bin/sh

# Set module temp directory
TMPDIR="${TMPDIR:-/dev/tmp}"
MODPATH="/data/adb/modules_update/QuiteKill"

# Variables
MODNAME=$(grep_prop name "$TMPDIR/module.prop")
MODVER=$(grep_prop version "$TMPDIR/module.prop")
DV=$(grep_prop author "$TMPDIR/module.prop")

Device=$(getprop ro.product.device)
Model=$(getprop ro.product.model)
Brand=$(getprop ro.product.brand)
Manufacturer=$(getprop ro.product.system.manufacturer)
Architecture=$(getprop ro.product.cpu.abi)
SDK=$(getprop ro.system.build.version.sdk)
ABI=$(getprop ro.system.product.cpu.abilist)
Android=$(getprop ro.system.build.version.release)
Type=$(getprop ro.system.build.type)
Built=$(getprop ro.system.build.date)
Time=$(date "+%d, %b - %H:%M %Z")
FINGERPRINT=$(getprop ro.system.build.fingerprint)
ID=$(getprop ro.system.build.id)
BTAG=$(getprop ro.system.build.tags)
BVER=$(getprop ro.system.build.version.incremental)
SP=$(getprop ro.build.version.security_patch)
HOST=$(getprop ro.build.host)
FBE=$(getprop ro.crypto.state)
FLAVOUR=$(getprop ro.build.flavor)
LOCALE=$(getprop ro.product.locale)
BT=$(getprop bt.max.hfpclient.connections)
CHIPSET=$(getprop ro.device.chipset)
DISPLAY=$(getprop ro.device.display_resolution)
NETFLIX=$(getprop ro.netflix.bsp_rev)
NFC=$(getprop ro.nfc.port)
MAINTAINER=$(getprop ro.device.maintainer)
CID=$(getprop ro.com.google.clientidbase)
SE=$(getenforce)
ROOT=$(whoami)

# Display UI Messages
debug() {
  msg="$1"
  time="${2:-0.2}"
  type="$3"

  charcount=$(printf "%s" "$msg" | wc -c)
  line=$(expr "$charcount" + 3)
  [ "$line" -gt 55 ] && line=55

  if [ "$type" = "sar" ]; then
    echo ""
    printf '%*s\n' "$line" | tr ' ' '-'
    echo " $msg"
    printf '%*s\n' "$line" | tr ' ' '-'
    echo ""
  else
    echo "$msg"
  fi
  sleep "$time"
}

# Toaster 
popup() {
    am start -a android.intent.action.MAIN -e mona "$@" -n popup.toast/meow.helper.MainActivity > /dev/null
    sleep 0.5
}

# Verify ZIP
unzip -o "$ZIPFILE" 'verify.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/verify.sh" ]; then
  debug "- Module files are corrupted, please re-download" 0.2 "sar"
  exit 1
fi

# Check integrity
echo " "
debug "-------------------------------------"
debug "- Checking Module Integrity..."
debug "-------------------------------------"
sleep 1
sh "$TMPDIR/verify.sh" || exit 1

# Installation starts
echo " " 
debug "-------------------------------------"
debug "- Fetching module info..."
debug "-------------------------------------"
debug "- Author: $DV"
debug "- Module：$MODNAME"
debug "- Version：$MODVER"
echo -n "- Provider："

if [ "$BOOTMODE" ] && [ "$KSU" ]; then
  echo "🍥 KernelSU app"
  echo "- KernelSU：$KSU_KERNEL_VER_CODE (kernel) + $KSU_VER_CODE (ksud)"
  if [ "$(which magisk)" ]; then
    echo "-----------------------------------------------------------"
    echo "! Multiple root implementation is NOT supported!"
    abort "-----------------------------------------------------------"
  fi
elif [ "$BOOTMODE" ] && [ "$MAGISK_VER_CODE" ]; then
  echo "🗿 Magisk app"
else
  echo "--------------------------------------------------------"
  echo "Installation from recovery is not supported"
  echo "Please install from KernelSU / Magisk or Apatch app"
  abort "--------------------------------------------------------"
fi

# Device Info
echo " " 
debug "-------------------------------------"
debug "- Fetching Device info..."
debug "-------------------------------------"
sleep 1
debug "- Brand Name：$Brand"
debug "- Device Name：$Device"
debug "- Model Name：$Model"
debug "- Device Manufacturer: $Manufacturer"
debug "- RAM：$(free | grep Mem | awk '{print $2}')"

# ROM Info
echo " " 
debug "-------------------------------------"
debug "- Fetching ROM info..."
debug "-------------------------------------"
sleep 1
debug "- Security Patch：$SP"
debug "- Data Encryption：$FBE"
debug "- Build ID：$ID"
debug "- Build Tag：$BTAG"
debug "- Build Inc.：$BVER"
debug "- Build Host：$HOST"
debug "- Build Flavour：$FLAVOUR"
debug "- ROM Build Date：$Built"
debug "- ROM Build Type：$Type"

# System Info
echo " " 
debug "-------------------------------------"
debug "- Fetching System info..."
debug "-------------------------------------"
sleep 1
debug "- SE Linux Status：$SE"
debug "- Default Language：$LOCALE"
debug "- Netflix：$NETFLIX"
debug "- Client ID：$CID"
debug "- ABI SUPPORT：$ABI"
debug "- Android Version：$Android"
debug "- Kernel: $(uname -r)"
debug "- CPU Architecture：$Architecture"
debug "- SDK Version：$SDK"

echo " " 
debug "-------------------------------------"
debug "- Preparing $MODNAME!"
debug "-------------------------------------"
sleep 2
echo "- Optimizing Module Files"
sleep 1

# Finish
nohup am start -a android.intent.action.VIEW -d https://t.me/MeowDump >/dev/null 2>&1 &
popup "This module was released by 𝗠𝗘𝗢𝗪 𝗗𝗨𝗠𝗣"

# EOF