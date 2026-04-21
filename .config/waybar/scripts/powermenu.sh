#!/bin/bash

samba_status=$(systemctl is-active smb.service)
if [ "$samba_status" = "active" ]; then
    samba_label="TURN OFF SAMBA"
else
    samba_label="TURN ON SAMBA"
fi

current_profile=$(powerprofilesctl get)
profile_label="POWER PROFILE: ${current_profile^^}"

chosen=$(printf "SHUTDOWN\nRESTART\nSLEEP\nLOG OUT\nLOCK\nHIBERNATE\nREBOOT TO BIOS\nREBOOT TO WINDOWS 11\n$samba_label\n$profile_label" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/colors/minimal-grey.rasi)

case "$chosen" in
    "SHUTDOWN")              systemctl poweroff ;;
    "RESTART")               systemctl reboot ;;
    "SLEEP")                 systemctl suspend ;;
    "LOG OUT")               loginctl terminate-user $USER ;;
    "LOCK")                  loginctl lock-session ;;
    "HIBERNATE")             systemctl hibernate ;;
    "REBOOT TO BIOS")        systemctl reboot --firmware-setup ;;
    "REBOOT TO WINDOWS 11")  grub-reboot "Windows 11" && systemctl reboot ;;
    "TURN ON SAMBA")         sudo systemctl start nmb.service smb.service ;;
    "TURN OFF SAMBA")        sudo systemctl stop nmb.service smb.service ;;
    "$profile_label")
        next=$(printf "balanced\nperformance\npower-saver" | rofi -dmenu -i -p "Profile" -theme ~/.config/rofi/colors/minimal-grey.rasi)
        [ -n "$next" ] && powerprofilesctl set "$next"
        ;;
esac
