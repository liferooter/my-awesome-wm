#!/usr/bin/env bash
~/.config/awesome/bin/do_screenshot.sh $(cat <<EOF | rofi -dmenu -p 'Capture' | tr '[:upper:]' '[:lower:]'
Screen
Area
Window
EOF
)
