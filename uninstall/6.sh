#!/bin/bash

set -e
CUR_DIR=$(pwd)
TMP_DIR="/tmp/atp"

echo "🗑️  Uninstalling miscellaneous AeroThemePlasma components..."

# 1) Kvantum
KV_DIR="$HOME/.config/Kvantum"
if [[ -d "$KV_DIR" ]]; then
    echo "Removing Kvantum theme..."
    rm -rf "$KV_DIR"
fi

# 2) Sounds
SOUNDS_ARCH="$CUR_DIR/misc/sounds/sounds.tar.gz"
if [[ -f "$SOUNDS_ARCH" ]]; then
    echo "Removing sound themes..."
    for d in $(tar -tzf "$SOUNDS_ARCH" | awk -F/ '{print $1}' | sort -u); do
        rm -rf "$HOME/.local/share/sounds/$d"
    done
fi

# 3) Icons
ICONS_ARCH="$CUR_DIR/misc/icons/Windows 7 Aero.tar.gz"
if [[ -f "$ICONS_ARCH" ]]; then
    echo "Removing icon theme..."
    for d in $(tar -tzf "$ICONS_ARCH" | awk -F/ '{print $1}' | sort -u); do
        rm -rf "$HOME/.local/share/icons/$d"
    done
fi

# 4) Cursors
CURSORS_ARCH="$CUR_DIR/misc/cursors/aero-drop.tar.gz"
if [[ -f "$CURSORS_ARCH" ]]; then
    echo "Removing cursor theme (requires root)..."
    for d in $(tar -tzf "$CURSORS_ARCH" | awk -F/ '{print $1}' | sort -u); do
        pkexec rm -rf "/usr/share/icons/$d"
    done
fi

# 5) Mimetypes
MIMETYPE_SRC_DIR="$CUR_DIR/misc/mimetype"
if [[ -d "$MIMETYPE_SRC_DIR" ]]; then
    echo "Removing mimetype packages..."
    for src in "$MIMETYPE_SRC_DIR"/*; do
        base=$(basename "$src")
        rm -f "$HOME/.local/share/mime/packages/$base"
    done
    echo "Updating MIME database..."
    update-mime-database "$HOME/.local/share/mime"
fi

# 6) Custom fontconfig
FC_DIR="$HOME/.config/fontconfig"
if [[ -f "$FC_DIR/fonts.conf.old" ]]; then
    echo "Restoring original fonts.conf..."
    mv "$FC_DIR/fonts.conf.old" "$FC_DIR/fonts.conf"
elif [[ -f "$FC_DIR/fonts.conf" ]]; then
    echo "Removing custom fonts.conf..."
    rm -f "$FC_DIR/fonts.conf"
fi

# Remove QML_DISABLE_DISTANCEFIELD from /etc/environment
if grep -q 'QML_DISABLE_DISTANCEFIELD=1' /etc/environment; then
    echo "Removing QML_DISABLE_DISTANCEFIELD from /etc/environment..."
    pkexec sed -i '/QML_DISABLE_DISTANCEFIELD=1/d' /etc/environment
fi

# 7) Branding
BRAND_DIR="$HOME/.config/kdedefaults"
if [[ -d "$CUR_DIR/misc/branding" ]]; then
    echo "Removing Info Center branding..."
    for f in "$CUR_DIR/misc/branding"/*; do
        rm -f "$BRAND_DIR/$(basename "$f")"
    done
    rm -f "$BRAND_DIR/kcm-about-distrorc"
fi

# 8) Terminal Vector font
if [[ -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
fi
if fc-list | grep -q 'TerminalVector'; then
    echo "Removing Terminal Vector font..."
    FONTFILE=$(fc-list : file | grep -m1 'TerminalVector.ttf' | cut -d: -f1)
    rm -f "$FONTFILE"
    echo "Rebuilding font cache..."
    fc-cache -f
fi

echo "✅ Done. All miscellaneous components have been removed."
