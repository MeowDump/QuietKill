#!/system/bin/sh

MODPATH=/data/adb/modules/QuiteKill
IGNORED="$MODPATH/ignore.txt"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG="/data/adb/modules/QuiteKill/Logs/QuiteKilled-$DATE.log"
OUT="/data/adb/modules/QuiteKill/webroot/output.log"

mkdir -p /data/adb/modules/QuiteKill/Logs
> "$OUT"

echo "Killing started at $DATE" | tee -a "$LOG" "$OUT"

# Get only user apps reliably
USER_APPS=$(cmd package list packages -3 | cut -f2 -d:)

# Append important system apps manually
USER_APPS="$USER_APPS
com.android.vending
com.google.android.gms
com.google.android.apps.photos
com.android.cellbroadcastreceiver.module
com.android.healthconnect.controller
com.caf.fmradio
org.omnirom.omnijaws
org.omnirom.logcat
io.chaldeaprjkt.gamespace
org.lineageos.audiofx
com.stevesoltys.seedvault
org.lineageos.setupwizard
com.google.android.syncadapters.calendar
com.android.dreams.phototable
com.android.gallery3d
com.android.calculator2
org.lineageos.recorder
org.lineageos.glimpse
org.lineageos.etar
org.lineageos.jelly
org.lineageos.twelve
com.android.angle
com.android.bookmarkprovider
com.android.printspooler
com.android.wallpaper.livepicker
com.android.providers.calendar
com.android.bips
com.android.apps.tag
com.google.android.contactkeys
com.google.ar.core
com.google.android.safetycore
com.google.android.ims
com.google.android.markup
com.simplemobiletools.calendar.pro
com.duckduckgo.mobile.android
com.android.emergency
org.eu.droid_ng.jellyfish
com.voltage.flash
com.google.android.pixel.setupwizard
com.google.android.apps.restore
com.google.android.setupwizard
com.google.android.partnersetup
com.google.android.feedback
com.google.android.videos
com.google.android.apps.turbo
com.google.pixel.livewallpaper
com.google.assistant.hubui
com.google.android.apps.work.clouddpc
com.google.android.aicore
com.google.android.calendar
com.google.android.apps.weather
com.google.android.apps.safetyhub
com.google.android.apps.aiwallpapers
com.google.android.projection.gearhead
com.google.android.as
com.google.android.wallpaper.effects
com.google.android.turboadapter
com.google.android.apps.wellbeing
com.google.android.apps.emojiwallpaper
com.google.android.googlequicksearchbox
com.google.audio.hearing.visualization.accessibility.scribe
com.google.android.apps.maps
com.android.hotwordenrollment.okgoogle
com.google.android.as.oss
com.google.android.apps.setupwizard.searchselector
com.google.android.settings.intelligence
com.google.android.storagemanager
com.google.android.accessibility.soundamplifier
com.google.android.tts
com.google.android.accessibility.switchaccess
com.google.android.tag
com.google.android.apps.weather
com.android.hotwordenrollment.xgoogle"

# Remove ignored apps
for IG in $(cat "$IGNORED" 2>/dev/null); do
  USER_APPS=$(echo "$USER_APPS" | grep -v "^$IG$")
done

# Kill each app
for PKG in $USER_APPS; do
  echo "⛔ Killing: $PKG" | tee -a "$LOG" "$OUT"
  am force-stop "$PKG" >/dev/null 2>&1
done

echo "✅ Done." | tee -a "$LOG" "$OUT"