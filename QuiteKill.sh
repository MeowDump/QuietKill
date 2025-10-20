#!/system/bin/sh
MODPATH="/data/adb/modules/QuiteKill"
CONFIG="$MODPATH/config.txt"
IGNORE="$MODPATH/ignore.txt"
FORCE="$MODPATH/ForceKill.txt"
LOGDIR="$MODPATH/logs"
LOG="$LOGDIR/output.log"
TMPDIR="$MODPATH/tmp_QuiteKill"
STATUS_OK="$TMPDIR/status_ok"
STATUS_FAIL="$TMPDIR/status_fail"

# Default flag values
PARALLEL=1
MAX_JOBS=4
ONLY_RUNNING=1
SKIP_CRITICAL=1
VERBOSE=1
WILDCARD_IGNORE=0

# Ensure directories exist
mkdir -p "$LOGDIR" "$TMPDIR"

# Auto-create config.txt with defaults if missing
if [ ! -f "$CONFIG" ]; then
  cat <<EOL > "$CONFIG"
PARALLEL=$PARALLEL
MAX_JOBS=$MAX_JOBS
ONLY_RUNNING=$ONLY_RUNNING
SKIP_CRITICAL=$SKIP_CRITICAL
VERBOSE=$VERBOSE
WILDCARD_IGNORE=$WILDCARD_IGNORE
EOL
fi

# Load config
while IFS='=' read -r key value; do
  key=$(echo "$key" | tr -d ' ')
  value=$(echo "$value" | tr -d ' ')
  case "$key" in
    PARALLEL) PARALLEL="$value" ;;
    MAX_JOBS) MAX_JOBS="$value" ;;
    ONLY_RUNNING) ONLY_RUNNING="$value" ;;
    SKIP_CRITICAL) SKIP_CRITICAL="$value" ;;
    VERBOSE) VERBOSE="$value" ;;
    WILDCARD_IGNORE) WILDCARD_IGNORE="$value" ;;
  esac
done < "$CONFIG"

: > "$LOG"
: > "$STATUS_OK"
: > "$STATUS_FAIL"

log() {
  ts=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$ts $1" >> "$LOG"
  [ "$VERBOSE" -eq 1 ] && echo "$1"
}

load_list() {
  file="$1"
  [ -f "$file" ] && sed '/^$/d;/^#/d' "$file" | sort -u
}

IGNORE_LIST="$(load_list "$IGNORE")"
FORCE_LIST="$(load_list "$FORCE")"

is_ignored() {
  pkg="$1"
  if [ "$WILDCARD_IGNORE" -eq 1 ]; then
    for pattern in $IGNORE_LIST; do
      case "$pkg" in $pattern) return 0 ;; esac
    done
    return 1
  else
    echo "$IGNORE_LIST" | grep -Fxq "$pkg"
  fi
}

is_installed() {
  pm list packages | cut -d: -f2 | grep -Fxq "$1"
}

is_running() {
  pkg="$1"
  command -v pidof >/dev/null 2>&1 && pidof "$pkg" >/dev/null 2>&1 && return 0
  ps -A 2>/dev/null | grep -F "$pkg" >/dev/null 2>&1 && return 0 || return 1
}

is_critical() {
  [ "$SKIP_CRITICAL" -ne 1 ] && return 1
  case "$1" in
    android|com.android.systemui|com.android.settings|com.google.android.gms|com.android.phone|com.android.launcher*|com.sec.android.app.launcher)
      return 0 ;;
  esac
  return 1
}

kill_app_once() {
  pkg="$1"
  src="$2"
  log "Attempting to stop [$src] $pkg"
  if am force-stop "$pkg" >/dev/null 2>&1; then
    log "Stopped [$src] $pkg"
    echo "$pkg" >> "$STATUS_OK"
  else
    log "Failed to stop [$src] $pkg"
    echo "$pkg" >> "$STATUS_FAIL"
  fi
}

do_kill() {
  pkg="$1"; src="$2"
  [ -z "$pkg" ] && return
  is_ignored "$pkg" && { log "Skipped [$src] $pkg (ignore list)"; echo "$pkg" >> "$STATUS_FAIL"; return; }
  is_critical "$pkg" && { log "Skipped [$src] $pkg (protected)"; echo "$pkg" >> "$STATUS_FAIL"; return; }
  ! is_installed "$pkg" && { log "Not installed [$src] $pkg"; echo "$pkg" >> "$STATUS_FAIL"; return; }
  [ "$ONLY_RUNNING" -eq 1 ] && ! is_running "$pkg" && { log "Not running [$src] $pkg"; echo "$pkg" >> "$STATUS_FAIL"; return; }
  kill_app_once "$pkg" "$src"
}

run_with_pool() {
  job_count=0
  for item in "$@"; do
    do_kill "$item" "User" &
    job_count=$((job_count+1))
    [ "$job_count" -ge "$MAX_JOBS" ] && wait && job_count=0
  done
  wait
}

start_time=$(date +%s)
log "QuiteKill started"

USER_PKGS=$(pm list packages -3 | cut -d: -f2)
[ -n "$USER_PKGS" ] && {
  if [ "$PARALLEL" -eq 1 ]; then
    set -- $USER_PKGS
    run_with_pool "$@"
  else
    echo "$USER_PKGS" | while read -r pkg; do [ -n "$pkg" ] && do_kill "$pkg" "User"; done
  fi
}

[ -n "$FORCE_LIST" ] && echo "$FORCE_LIST" | while read -r pkg; do
  [ -z "$pkg" ] && continue
  is_ignored "$pkg" && { log "Skipped [Force] $pkg (ignore list)"; echo "$pkg" >> "$STATUS_FAIL"; continue; }
  is_critical "$pkg" && { log "Skipped [Force] $pkg (protected)"; echo "$pkg" >> "$STATUS_FAIL"; continue; }
  ! is_installed "$pkg" && { log "Not installed [Force] $pkg"; echo "$pkg" >> "$STATUS_FAIL"; continue; }
  kill_app_once "$pkg" "Force"
done

ok_count=$(wc -l < "$STATUS_OK" 2>/dev/null || echo 0)
fail_count=$(wc -l < "$STATUS_FAIL" 2>/dev/null || echo 0)
elapsed=$(( $(date +%s) - start_time ))

log "Done. Killed: $ok_count, skipped: $fail_count, time: ${elapsed}s"
echo "Killed: $ok_count, skipped: $fail_count, time: ${elapsed}s"

rm -rf "$TMPDIR"
exit 0
