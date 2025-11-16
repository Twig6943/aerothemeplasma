#!/bin/bash

CUR_DIR=$(pwd)

if [[ -z "$(command -v kpackagetool6)" ]]; then
    echo "kpackagetool6 not found. Stopping."
    exit 1
fi

echo "Stopping plasmashell..."
killall plasmashell

function uninstall_plasmoid {
    PLASMOID=$(basename "$1")
    if [[ "$PLASMOID" == "src" ]]; then
        echo "Skipping $PLASMOID"
        return
    fi
    echo "Uninstalling $PLASMOID..."
    kpackagetool6 -t "Plasma/Applet" -r "$PLASMOID"
    echo -e "\n"
}

echo "Uninstalling plasmoids..."
for filename in "$CUR_DIR/plasma/plasmoids/"*; do
    uninstall_plasmoid "$filename"
done

echo "Restarting plasmashell..."
setsid plasmashell --replace &

echo "✅ Uninstall complete."
