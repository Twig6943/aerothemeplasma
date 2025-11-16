#!/bin/bash

CUR_DIR=$(pwd)
USE_SCRIPT="install_ninja.sh"

# Check for CMake
if [[ -z "$(command -v cmake)" ]]; then
    echo "CMake not found. Stopping."
    exit
fi

# Check for Ninja or fallback to Make
if [[ -z "$(command -v ninja)" ]]; then
    USE_SCRIPT="install.sh"
    if [[ -z "$(command -v make)" ]]; then
        echo "Neither Ninja nor GNU Make were found. Stopping."
        exit
    fi
fi

# Compile defaulttooltip
cd "$CUR_DIR/misc/defaulttooltip"
sh "$USE_SCRIPT"
cd "$CUR_DIR"

# Optional: Compile plasmoids
# echo "Compiling plasmoids..."
# for filename in "$CUR_DIR/plasma/plasmoids/src/"*; do
#     cd "$filename"
#     echo "Compiling $(pwd)"
#     sh "$USE_SCRIPT"
#     echo "Done."
#     cd "$CUR_DIR"
# done

# Compile SMOD decorations
echo "Compiling SMOD decorations..."
cd "$CUR_DIR/kwin/decoration"
sh "$USE_SCRIPT"
cd "$CUR_DIR"
echo "Done."

# Compile KWin effects
echo "Compiling KWin effects..."
for filename in "$CUR_DIR/kwin/effects_cpp/"*; do
    cd "$filename"
    echo "Compiling $(pwd)"
    sh "$USE_SCRIPT"
    echo "Done."
    cd "$CUR_DIR"
done
