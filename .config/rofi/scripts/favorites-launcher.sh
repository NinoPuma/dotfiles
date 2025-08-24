#!/usr/bin/env bash
set -euo pipefail

pick_cmd() {
  for c in "$@"; do
    if command -v "$c" >/dev/null 2>&1; then
      echo "$c"; return 0
    fi
  done
  return 1
}

SETTINGS_CMD=$(pick_cmd gnome-control-center systemsettings6 systemsettings5 systemsettings xfce4-settings-manager cinnamon-settings mate-control-center lxqt-config)
FILES_CMD=$(pick_cmd nautilus nemo dolphin thunar pcmanfm caja)

choices=()
choices+=("Firefox")
[ -n "${SETTINGS_CMD:-}" ] && choices+=("Settings")
[ -n "${FILES_CMD:-}" ] && choices+=("Files")
choices+=("All Apps…")

choice="$(printf '%s\n' "${choices[@]}" | rofi -dmenu -p 'Favorites' -theme ~/.config/rofi/themes/dark-rounded.rasi)"

case "${choice:-}" in
  "Firefox") nohup firefox >/dev/null 2>&1 & ;;
  "Settings") [ -n "${SETTINGS_CMD:-}" ] && nohup "$SETTINGS_CMD" >/dev/null 2>&1 & ;;
  "Files") [ -n "${FILES_CMD:-}" ] && nohup "$FILES_CMD" >/dev/null 2>&1 & ;;
  "All Apps…") rofi -show drun -theme ~/.config/rofi/themes/dark-rounded.rasi ;;
  *) exit 0 ;;
esac
