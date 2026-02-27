#!/bin/bash

chosen=$(printf "SHUTDOWN\nRESTART\nSLEEP\nLOG OUT\nLOCK\nHIBERNATE\nREBOOT TO BIOS\nREBOOT TO WINDOWS 11" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/colors/minimal.rasi)

case "$chosen" in
    "SHUTDOWN")          systemctl poweroff ;;
    "RESTART")           systemctl reboot ;;
    "SLEEP")             systemctl suspend ;;
    "LOG OUT")           loginctl terminate-user $USER ;;
    "LOCK")              loginctl lock-session ;;
    "HIBERNATE")         systemctl hibernate ;;
    "REBOOT TO BIOS")    systemctl reboot --firmware-setup ;;
    "REBOOT TO WINDOWS 11") grub-reboot "Windows 11" && systemctl reboot ;;
esac
