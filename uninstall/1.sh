#!/bin/bash

echo "🔄 Resetting KDE Plasma settings..."

# Create backup folder
backup_dir="$HOME/.kde-reset-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$backup_dir"

# List of config dirs/files to reset
targets=(
  "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
  "$HOME/.config/kdeglobals"
  "$HOME/.config/kglobalshortcutsrc"
  "$HOME/.config/kwinrc"
  "$HOME/.config/kcminputrc"
  "$HOME/.config/ksmserverrc"
  "$HOME/.config"
  "$HOME/.local"
  "$HOME/.cache"
  "$HOME/.kde"
)

for item in "${targets[@]}"; do
  if [ -e "$item" ]; then
    echo "📦 Backing up $item"
    mv "$item" "$backup_dir/"
  fi
done

echo "✅ Done! Plasma will reset on next login."
echo "🗂 Backup saved in: $backup_dir"
echo "📤 Log out and log back in for changes to take effect."
