#!/usr/bin/env bash

# File: ~/.local/bin/omarchy-gps.sh

check_gps() {
    if systemctl is-active --quiet gpsd || systemctl is-active --quiet gpsd.socket; then
        return 0
    else
        return 1
    fi
}

case "$1" in
    toggle)
        if check_gps; then
            # Stop it
            sudo systemctl stop gpsd.socket gpsd.service
        else
            # Start it
            sudo systemctl start gpsd.socket gpsd.service
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
