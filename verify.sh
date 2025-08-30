#!/system/bin/sh

MODPATH=${MODPATH:-/data/adb/modules_update/QuiteKill}
VERIFY_TEMP_DIR="/data/adb/QuiteKill_verify"

# Clean temp dir
rm -rf "$VERIFY_TEMP_DIR"
mkdir -p "$VERIFY_TEMP_DIR"

log() {
  echo "- $1"
}

abort_verify() {
  ui_print "----------------------------------------------"
  echo " "
  echo "Error: File integrity compromised.⚠️"
  echo "Please download the module again"
  echo "from its release source to restore it."
  sleep 2
  am start -a android.intent.action.VIEW -d https://t.me/MeowRedirect >/dev/null 2>&1
  echo "Installation aborted due to failed verification."
  echo " "
  exit 1
}

verify_file() {
  local relpath="$1"
  local file="$MODPATH/$relpath"
  local hashfile="$file.sha256"

  [ ! -f "$file" ] && log "Missing: $relpath" && abort_verify
  [ ! -f "$hashfile" ] && log "Missing hash: $relpath.sha256" && abort_verify

  local expected actual
  expected=$(cut -d' ' -f1 < "$hashfile")
  actual=$(sha256sum "$file" | cut -d' ' -f1)

  [ "$expected" != "$actual" ] && log "Corrupt: $relpath" && abort_verify

  log "Verified: $relpath"
  mkdir -p "$VERIFY_TEMP_DIR/$(dirname "$relpath")"
  cp -af "$file" "$VERIFY_TEMP_DIR/$relpath"
}

# Find all files (excluding *.sha256)
ALL_FILES=$(cd "$MODPATH" && find . -type f ! -name "*.sha256" | cut -c3-)

for relpath in $ALL_FILES; do
  verify_file "$relpath"
done

# Cleanup hash files
find "$MODPATH" -type f -name "*.sha256" -delete
log "Removed all .sha256 hash files"

log "Verification completed successfully."