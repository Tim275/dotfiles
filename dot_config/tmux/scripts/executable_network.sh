#!/usr/bin/env bash
# Cyberdream tmux - Network/VPN Widget (macOS)
# Shows: WiFi name or VPN status

get_network_info() {
    # macOS only
    if [[ "$(uname)" != "Darwin" ]]; then
        return
    fi

    # Check for active VPN first (common VPN interfaces)
    local vpn_active=""

    # Check utun interfaces (WireGuard, etc.)
    if ifconfig 2>/dev/null | grep -q "utun.*: flags=.*UP"; then
        # Check if Tailscale is running
        if command -v tailscale &>/dev/null && tailscale status &>/dev/null; then
            vpn_active="󰖂 Tailscale"
        # Check for other VPNs
        elif scutil --nc list 2>/dev/null | grep -q "Connected"; then
            local vpn_name
            vpn_name=$(scutil --nc list 2>/dev/null | grep "Connected" | head -1 | sed 's/.*"\(.*\)".*/\1/' | cut -c1-10)
            vpn_active="󰖂 $vpn_name"
        fi
    fi

    if [ -n "$vpn_active" ]; then
        echo "$vpn_active"
        return
    fi

    # Get WiFi info
    local wifi_name
    wifi_name=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null | awk -F': ' '/ SSID/{print $2}')

    if [ -n "$wifi_name" ]; then
        # Truncate if too long
        [ ${#wifi_name} -gt 12 ] && wifi_name="${wifi_name:0:10}.."
        echo "󰖩 $wifi_name"
        return
    fi

    # Check for Ethernet
    if ifconfig en0 2>/dev/null | grep -q "status: active"; then
        echo "󰈀 Ethernet"
        return
    fi

    echo "󰖪 Offline"
}

get_network_info
