#!/usr/bin/env bash
# Lumen Cursors - One-Step Linux & Omarchy Installer
# Works with Hyprland, Sway, GNOME, KDE Plasma, XFCE, Cinnamon, and all X11/Wayland desktops.

set -e

THEME_NAME="Lumen"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find the Lumen theme directory
if [ -d "$SCRIPT_DIR/Lumen-Linux/cursors" ]; then
    SOURCE_DIR="$SCRIPT_DIR/Lumen-Linux"
elif [ -d "$SCRIPT_DIR/cursors" ]; then
    SOURCE_DIR="$SCRIPT_DIR"
elif [ -d "$SCRIPT_DIR/Lumen/cursors" ]; then
    SOURCE_DIR="$SCRIPT_DIR/Lumen"
else
    echo "Error: Cannot find cursor files in $SCRIPT_DIR"
    exit 1
fi

echo "=================================================="
echo "          Lumen Cursors Installer                 "
echo "=================================================="
echo ""

# Choose destination
if [ "$EUID" -eq 0 ]; then
    TARGET_DIR="/usr/share/icons/$THEME_NAME"
    echo "Installing system-wide to: $TARGET_DIR"
else
    TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"
    LEGACY_DIR="$HOME/.icons/$THEME_NAME"
    echo "Installing for current user to: $TARGET_DIR"
fi

# Copy theme files
mkdir -p "$TARGET_DIR"
cp -f "$SOURCE_DIR/index.theme" "$TARGET_DIR/"
rm -rf "$TARGET_DIR/cursors"
cp -r "$SOURCE_DIR/cursors" "$TARGET_DIR/"

# Also link or copy to ~/.icons for older applications
if [ "$EUID" -ne 0 ]; then
    mkdir -p "$HOME/.icons"
    rm -rf "$LEGACY_DIR"
    ln -sf "$TARGET_DIR" "$LEGACY_DIR" 2>/dev/null || cp -r "$TARGET_DIR" "$LEGACY_DIR"
fi

# Update default cursor fallback
if [ "$EUID" -ne 0 ]; then
    DEFAULT_DIR="$HOME/.icons/default"
    mkdir -p "$DEFAULT_DIR"
    cat <<EOF > "$DEFAULT_DIR/index.theme"
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=$THEME_NAME
EOF
fi

echo "Cursor files copied successfully!"
echo ""

# Attempt to apply live
echo "Applying cursor theme to active desktop session..."

# Hyprland / Omarchy
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl setcursor "$THEME_NAME" 24 2>/dev/null && echo "  -> Applied to Hyprland session via hyprctl" || true
fi

# GNOME / Cinnamon / XFCE (GTK)
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface cursor-theme "$THEME_NAME" 2>/dev/null && echo "  -> Applied to GNOME/GTK settings" || true
fi

# X11 Xresources
if [ -f "$HOME/.Xresources" ]; then
    sed -i '/Xcursor.theme/d' "$HOME/.Xresources"
    echo "Xcursor.theme: $THEME_NAME" >> "$HOME/.Xresources"
    if command -v xrdb >/dev/null 2>&1; then
        xrdb -merge "$HOME/.Xresources" 2>/dev/null || true
    fi
    echo "  -> Updated ~/.Xresources"
fi

echo ""
echo "=================================================="
echo "          Installation Complete!                  "
echo "=================================================="
echo ""
echo "Desktop Configuration:"
echo ""
echo "  * Omarchy / Hyprland:"
echo "    Add to ~/.config/hypr/hyprland.conf:"
echo "      env = XCURSOR_THEME,$THEME_NAME"
echo "      env = XCURSOR_SIZE,24"
echo "      env = HYPRCURSOR_THEME,$THEME_NAME"
echo "      env = HYPRCURSOR_SIZE,24"
echo ""
echo "  * GNOME / Ubuntu / Fedora:"
echo "    Open 'GNOME Tweaks' -> Appearance -> Cursor -> select '$THEME_NAME'."
echo ""
echo "  * KDE Plasma:"
echo "    Open 'System Settings' -> Colors & Themes -> Cursors -> select '$THEME_NAME'."
echo ""
