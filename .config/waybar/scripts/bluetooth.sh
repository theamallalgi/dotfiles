#!/bin/bash

# check bluetooth power state
bt_power=$(bluetoothctl show | grep "Powered: yes")

if [ -n "$bt_power" ]; then
    toggle="TURN BLUETOOTH OFF"
else
    toggle="TURN BLUETOOTH ON"
fi

# get paired devices with connection status
paired=$(bluetoothctl devices | while read -r _ mac name; do
    connected=$(bluetoothctl info "$mac" | grep -c "Connected: yes")
    if [ "$connected" -gt 0 ]; then
        echo "● $name"
    else
        echo "○ $name"
    fi
done)

# build menu
menu=$(printf "%s\n%s" "$toggle" "$paired")

chosen=$(echo "$menu" | rofi -dmenu -i -p "Bluetooth" -theme ~/.config/rofi/colors/minimal.rasi)

[ -z "$chosen" ] && exit

case "$chosen" in
    "TURN BLUETOOTH OFF")
        bluetoothctl power off
        ;;
    "TURN BLUETOOTH ON")
        bluetoothctl power on
        ;;
    ●*|○*)
        # strip the status indicator to get device name
        name="${chosen:2}"
        mac=$(bluetoothctl devices | grep "$name" | awk '{print $2}')
        connected=$(bluetoothctl info "$mac" | grep -c "Connected: yes")
        if [ "$connected" -gt 0 ]; then
            bluetoothctl disconnect "$mac"
        else
            bluetoothctl connect "$mac"
        fi
        ;;
esac
