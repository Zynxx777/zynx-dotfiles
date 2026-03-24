#!/usr/bin/env bash

# File: ~/.local/bin/omarchy-gps.sh

STATE_FILE="/tmp/waybar_gps_state"

check_gps() {
    if [ -f "$STATE_FILE" ]; then
        return 0
    else
        return 1
    fi
}

case "$1" in
    toggle)
        if check_gps; then
            rm -f "$STATE_FILE"
            sudo systemctl stop gpsd.socket gpsd.service 2>/dev/null || true
        else
            touch "$STATE_FILE"
            sudo systemctl start gpsd.socket gpsd.service 2>/dev/null || true
        fi
        ;;
    status)
        if check_gps; then
            echo '{"text": "", "tooltip": "GPS Output Enabled", "class": "on"}'
        else
            echo '{"text": "󰍑", "tooltip": "GPS Output Disabled", "class": "off"}'
        fi
        ;;
    *)
        echo "Usage: $0 {toggle|status}"
        exit 1
        ;;
esac
