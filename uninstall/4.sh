#!/bin/bash

CUR_DIR=$(pwd)

if [[ -z "$(command -v kpackagetool6)" ]]; then
    echo "kpackagetool6 not found. Stopping."
    exit 1
fi

function uninstall_component {
    COMPONENT=$(basename "$1")
    echo "Uninstalling $COMPONENT from type $2..."
    kpackagetool6 -t "$2" -r "$COMPONENT"
    echo -e "\n"
}

echo "Uninstalling KWin effects (JS)..."
for filename in "$CUR_DIR/kwin/effects/"*; do
    uninstall_component "$filename" "KWin/Effect"
done
echo "Done."

echo "Uninstalling KWin scripts..."
for filename in "$CUR_DIR/kwin/scripts/"*; do
    uninstall_component "$filename" "KWin/Script"
done
echo "Done."

echo "Uninstalling KWin task switchers..."
for filename in "$CUR_DIR/kwin/tabbox/"*; do
    uninstall_component "$filename" "KWin/WindowSwitcher"
done
echo "Done."

# Remove manually copied outline dir
KWIN_DIR="$HOME/.local/share/kwin"
OUTLINE_DIR="$KWIN_DIR/outline"
if [[ -d "$OUTLINE_DIR" ]]; then
    echo "Removing outline directory..."
    rm -rf "$OUTLINE_DIR"
    echo "Done."
else
    echo "Outline directory not found, skipping."
fi
