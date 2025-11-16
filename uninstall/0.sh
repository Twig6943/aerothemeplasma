if [[ -z "$(command -v kpackagetool6)" ]]; then
    echo "kpackagetool6 not found. Stopping."
    exit
fi
if [[ -z "$(command -v tar)" ]]; then
    echo "tar not found. Stopping."
    exit
fi
if [[ -z "$(command -v sddmthemeinstaller)" ]]; then
    echo "sddmthemeinstaller not found. Stopping."
    exit
fi

function remove_plasmoid {
    PLASMOID=$(basename "$1")
    if [[ $PLASMOID == 'src' ]]; then
        echo "Skipping $PLASMOID"
        return
    fi

    echo "Removing $PLASMOID..."
    kpackagetool6 -t "Plasma/Applet" -r "$1"

    echo -e "\n"
    cd "$CUR_DIR"
}

function remove_component {
    COMPONENT=$(basename "$1")

    echo "Removing $COMPONENT..."
    kpackagetool6 -t "$2" -r "$1"

    echo -e "\n"
    cd "$CUR_DIR"
}

while true; do
    read -p "This is an uninstall script for AeroThemePlasma.
Do you wish to proceed? (yes/no)
" PROMPT
    case "${PROMPT}" in
        "yes") echo - "\nUser accepted the warning, proceeding...\n"
            break
            ;;
        "no") echo -e "\nUser didn't accept, exiting...\n"
            exit
            ;;
        *) echo -e "\nEither do 'yes' or 'no' to proceed or exit.\n"
            ;;
    esac
done

killall plasmashell

for filename in "$PWD/plasma/plasmoids/"*; do
    remove_plasmoid "$filename"
done

echo "Removing KWin effects (JS)..."
for filename in "$PWD/kwin/effects/"*; do
    remove_component "$filename" "KWin/Effect"
done
echo "Done."

echo "Removing KWin scripts..."
for filename in "$PWD/kwin/scripts/"*; do
    remove_component "$filename" "KWin/Script"
done
echo "Done."

echo "Removing KWin task switchers..."
for filename in "$PWD/kwin/tabbox/"*; do
    remove_component "$filename" "KWin/WindowSwitcher"
done
echo "Done."

LOCAL_DIR="${HOME}/.local/share"

# LNF
remove_component "${LOCAL_DIR}/plasma/look-and-feel/authui7" "Plasma/LookAndFeel"
# Layout template
remove_component "${LOCAL_DIR}/plasma/layout-templates/io.gitgud.wackyideas.taskbar" "Plasma/LayoutTemplate"
# Plasma Style
remove_component "${LOCAL_DIR}/plasma/desktoptheme/Seven-Black" "Plasma/Theme"
# Shell
remove_component "${LOCAL_DIR}/plasma/shells/org.kde.plasma.desktop" "Plasma/Shell"

# Resets Desktop Effects and Window Behaviors to its defaults
rm -f "${HOME}/.config/kwinrc"

# Set the Task Switcher to something sensible that is included in Plasma by default
kwriteconfig6 --file kwinrc --group TabBox --key LayoutName "thumbnail_grid"

# Remove the custom Kvantum theme
rm -rf "${HOME}/.config/Kvantum/Windows7Kvantum_Aero"
kwriteconfig6 --file "${HOME}/.config/Kvantum/kvantum.kvconfig" --group General --key Theme --delete

# Remove the custom Mimetypes
MIMETYPE_DIR="$HOME/.local/share/mime/packages"
for filename in "$PWD/misc/mimetype/"*; do
    basefile=$(basename "$filename")
    rm -f "$MIMETYPE_DIR/$basefile"
done
update-mime-database "$HOME/.local/share/mime"

# Remove the custom icon theme
rm -rf "${LOCAL_DIR}/icons/Windows 7 Aero"

# Resets the layout and applies the 'Breeze' global theme, then launches Plasma Desktop
plasma-apply-lookandfeel -a org.kde.breeze.desktop --resetLayout
