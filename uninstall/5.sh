#!/bin/bash

CUR_DIR=$(pwd)

if [[ -z "$(command -v kpackagetool6)" ]]; then
    echo "kpackagetool6 not found. Stopping."
    exit 1
fi
if [[ -z "$(command -v sddmthemeinstaller)" ]]; then
    echo "sddmthemeinstaller not found. Stopping."
    exit 1
fi

# Uninstall KPackage component
function uninstall_component {
    COMPONENT=$(basename "$1")
    echo "Uninstalling $COMPONENT from type $2..."
    kpackagetool6 -t "$2" -r "$COMPONENT"
    echo -e "\n"
}

# LNF
uninstall_component "$PWD/plasma/look-and-feel/authui7" "Plasma/LookAndFeel"
# Layout template
uninstall_component "$PWD/plasma/layout-templates/io.gitgud.wackyideas.taskbar" "Plasma/LayoutTemplate"
# Plasma Style
uninstall_component "$PWD/plasma/desktoptheme/Seven-Black" "Plasma/Theme"
# Shell
uninstall_component "$PWD/plasma/shells/org.kde.plasma.desktop" "Plasma/Shell"

# Color scheme
COLOR_FILE="$HOME/.local/share/color-schemes/AeroColorScheme1.colors"
if [[ -f "$COLOR_FILE" ]]; then
    echo "Removing color scheme..."
    rm -f "$COLOR_FILE"
else
    echo "Color scheme not found. Skipping..."
fi

# SMOD
SMOD_DIR="/usr/share/smod"
if [[ -d "$SMOD_DIR" ]]; then
    echo "Removing SMOD resources..."
    pkexec rm -rf "$SMOD_DIR"
else
    echo "SMOD directory not found. Skipping..."
fi

# SDDM Theme
echo "Uninstalling SDDM theme..."
sddmthemeinstaller -r "sddm-theme-mod"

echo "✅ Uninstall complete."
