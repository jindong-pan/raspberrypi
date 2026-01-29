#!/bin/bash

# Configuration
CON_NAME="SeattleSharks"
STATIC_IP="192.168.1.120/24"
GATEWAY="192.168.1.1"
DNS="8.8.8.8,1.1.1.1"

echo "Choose Wifi Mode for [$CON_NAME]:"
echo "1) HOME (Static IP: $STATIC_IP)"
echo "2) PUBLIC (Dynamic/DHCP)"
read -p "Selection [1 or 2]: " choice

if [ "$choice" == "1" ]; then
    sudo nmcli con mod "$CON_NAME" ipv4.addresses "$STATIC_IP"
    sudo nmcli con mod "$CON_NAME" ipv4.gateway "$GATEWAY"
    sudo nmcli con mod "$CON_NAME" ipv4.dns "$DNS"
    sudo nmcli con mod "$CON_NAME" ipv4.method manual
    echo "Switched to STATIC mode."
elif [ "$choice" == "2" ]; then
    sudo nmcli con mod "$CON_NAME" ipv4.addresses ""
    sudo nmcli con mod "$CON_NAME" ipv4.gateway ""
    sudo nmcli con mod "$CON_NAME" ipv4.dns ""
    sudo nmcli con mod "$CON_NAME" ipv4.method auto
    echo "Switched to DYNAMIC (DHCP) mode."
else
    echo "Invalid choice."
    exit 1
fi

# Apply the changes
sudo nmcli con up "$CON_NAME"
