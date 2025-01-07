#!/usr/bin/env bash

theme="full_rounded"
dir="$HOME/.config/hypr/rofi/powermenu"

# random colors
color="mountain.rasi"

# uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
      poweroff
    ;;
  $reboot)
      reboot
    ;;
  $lock)
      lock
    ;;
  $suspend)
      suspend
    ;;
  $logout)

    ;;
esac
