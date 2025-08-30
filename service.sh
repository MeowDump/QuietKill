#!/system/bin/sh

KILLER="/data/adb/modules/QuiteKill/QuiteKill.sh"
STOPPER="/sdcard/stopQuiteKill"
LOGDIR="/data/adb/modules/QuiteKill/logs"
LOGFILE="$LOGDIR/kill.log"

DEBUG=0
CLICK_THRESHOLD=0.3
COOLDOWN=5

mkdir -p "$LOGDIR"

log() {
  if [ "$DEBUG" -eq 1 ]; then
    echo "[DEBUG] $(date '+%m-%d %H:%M:%S') - $*" | tee -a "$LOGFILE"
  else
    echo "$(date '+%m-%d %H:%M:%S') - $*" >> "$LOGFILE"
  fi
}

monitor_event0() {
  log "Starting event0 monitor (low CPU)..."
  last_down=0

  # Read lines blocking from event0
  getevent /dev/input/event0 | while read -r line; do
    [ -f "$STOPPER" ] && log "Key Smasher disabled" && exit 0

    case "$line" in
      *"0001 0074 00000001"*)  # POWER DOWN
        last_down=$(date +%s.%N)
        log "Power button DOWN"
        ;;
      *"0001 0074 00000000"*)  # POWER UP
        if [ "$last_down" != 0 ]; then
          up_time=$(date +%s.%N)

          # Calculate diff with shell arithmetic for speed (use bc if available, else awk)
          if command -v bc >/dev/null 2>&1; then
            diff=$(echo "$up_time - $last_down" | bc)
          else
            diff=$(awk "BEGIN {print $up_time - $last_down}")
          fi

          last_down=0

          # Compare diff without awk for speed if possible
          diff_check() {
            awk "BEGIN {exit !($1 < $2)}"
          }

          if diff_check "$diff" "$CLICK_THRESHOLD"; then
            log "Quick tap detected (${diff}s)"
            sh "$KILLER" &
            log "🤫🔪 Murdered all running apps"
            sleep "$COOLDOWN"
          else
            log "Long press ignored (${diff}s)"
          fi
        fi
        ;;
    esac
  done
}

# Fallback polling with minimal CPU usage
polling_loop() {
  log "Starting fallback polling loop (low CPU)..."
  while true; do
    [ -f "$STOPPER" ] && log "Key Smasher disabled" && exit 0

    EVENT=$(getevent -lqc1)
    case "$EVENT" in
      *KEY_POWER*DOWN*)
        down_time=$(date +%s.%N)

        # Wait for UP event max 4s, but poll every 0.2s to reduce CPU usage
        end=$((SECONDS + 4))
        while [ $SECONDS -lt $end ]; do
          sleep 0.2
          next_event=$(getevent -lqc1)
          if echo "$next_event" | grep -q "KEY_POWER.*UP"; then
            up_time=$(date +%s.%N)

            if command -v bc >/dev/null 2>&1; then
              diff=$(echo "$up_time - $down_time" | bc)
            else
              diff=$(awk "BEGIN {print $up_time - $down_time}")
            fi

            if awk "BEGIN {exit !($diff < $CLICK_THRESHOLD)}"; then
              log "Quick tap detected (${diff}s)"
              sh "$KILLER" &
              log "🤫🔪 Murdered all running apps"
              sleep "$COOLDOWN"
            else
              log "Long press ignored (${diff}s)"
            fi
            break
          fi
        done
        ;;
    esac
  done
}

if [ -r /dev/input/event0 ]; then
  monitor_event0
else
  polling_loop
fi
