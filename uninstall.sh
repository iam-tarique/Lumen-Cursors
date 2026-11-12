#!/usr/bin/env bash
# Lumen Cursors - Linux & Omarchy Uninstaller

THEME_NAME="Lumen"

echo "Removing $THEME_NAME cursor theme..."

if [ "$EUID" -eq 0 ]; then
    rm -rf "/usr/share/icons/$THEME_NAME"
else
    rm -rf "$HOME/.local/share/icons/$THEME_NAME"
    rm -rf "$HOME/.icons/$THEME_NAME"
fi

echo "$THEME_NAME cursors successfully removed."
