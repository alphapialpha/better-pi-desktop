#!/bin/bash

# GNOME for Wayland Auto-Installer for Raspberry Pi 4/5
# With optimized Chromium flags (hardware decoding enabled)

# ===== 1. Force Non-Interactive Mode =====
export DEBIAN_FRONTEND=noninteractive

# ===== 2. System Update =====
sudo apt update && sudo apt full-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew"

# ===== 3. Install GNOME + GDM + Extensions =====
echo "gdm3 shared/default-display-manager select gdm3" | sudo debconf-set-selections
sudo apt install -y \
  gnome-core \
  gdm3 \
  gnome-shell \
  gnome-session \
  gnome-shell-extensions \
  gnome-tweaks \
  chromium

# ===== 4. Configure Wayland =====
# Nothing to do here at the moment

# ===== 5. GPU & Chromium Setup =====
# Mesa drivers (Pi 5)
sudo apt install -y \
  mesa-va-drivers \
  mesa-vulkan-drivers \
  libgl1-mesa-dri \
  libgbm1

# ===== 6. Optimized Chromium flags & h264ify Plugin =====
#not necessary anymore

# ===== 7. Final Steps =====
sudo systemctl set-default graphical.target
sudo apt autoremove -y

# ===== 8. Reboot =====
echo "Installation complete. Check for errors and do a 'sudo reboot'"
