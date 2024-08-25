#!/usr/bin/env bash

PACKAGE_INFO_FILE="$HOME/.config/starship/package_updates.txt"
echo "PACKAGE_INFO_FILE: $PACKAGE_INFO_FILE"
if [ -f "$PACKAGE_INFO_FILE" ]; then
  echo "File exists"
else
  echo "File does not exist"
fi

# Initialize package update variables
APT_UPDATE=""
BREW_UPDATE=""
PIP_UPDATE=""
FLATPAK_UPDATE=""

# Check for apt updates (Linux)
function check_apt_updates() {
  if command -v apt &> /dev/null; then
    sudo apt update &> /dev/null
    updates=$(apt list --upgradable 2>/dev/null | wc -l)
    updates=$((updates - 1))  # Subtract 1 for the header line
    if [ "$updates" -gt 0 ]; then
      APT_UPDATE="📦 $updates"
    else
      APT_UPDATE=""
    fi
  fi
}

# Check for brew updates (macOS)
function check_brew_updates() {
  if command -v brew &> /dev/null; then
    updates=$(brew outdated | wc -l)
    if [ "$updates" -gt 0 ]; then
      BREW_UPDATE="🍺 $updates"
    else
      BREW_UPDATE=""
    fi
  fi
}

# Check for pip updates
function check_pip_updates() {
  if command -v pip &> /dev/null; then
    updates=$(pip list --outdated --format=columns | wc -l)
    updates=$((updates - 2))  # Subtract 2 for the header lines
    if [ "$updates" -gt 0 ]; then
      PIP_UPDATE="🐍 $updates"
    else
      PIP_UPDATE=""
    fi
  fi
}

# Check for flatpak updates
function check_flatpak_updates() {
  if command -v flatpak &> /dev/null; then
    updates=$(flatpak update --appstream --noninteractive | grep -E '^[[:alnum:]]' | wc -l)
    if [ "$updates" -gt 0 ]; then
      FLATPAK_UPDATE="🎨 $updates"
    else
      FLATPAK_UPDATE=""
    fi
  fi
}

# Check for updates (run this on shell startup)
check_apt_updates
check_brew_updates
check_pip_updates
check_flatpak_updates

# Write package update information to the package info file
{
  echo "APT_UPDATE=$APT_UPDATE"
  echo "BREW_UPDATE=$BREW_UPDATE"
  echo "PIP_UPDATE=$PIP_UPDATE"
  echo "FLATPAK_UPDATE=$FLATPAK_UPDATE"
} > "$PACKAGE_INFO_FILE"

# Combine all update variables into a single variable
SOFTWARE_UPDATE_AVAILABLE=""
for update in "$APT_UPDATE" "$BREW_UPDATE" "$PIP_UPDATE" "$FLATPAK_UPDATE"; do
  if [ -n "$update" ]; then
    SOFTWARE_UPDATE_AVAILABLE+="$update "
  fi
done

# Export the combined variable
export SOFTWARE_UPDATE_AVAILABLE
