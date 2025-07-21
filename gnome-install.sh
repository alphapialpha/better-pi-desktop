#!/bin/bash

# Force interactive mode if no terminal detected
[ -t 0 ] || exec bash -i "$0" "$@"

# GNOME for Wayland Auto-Installer for Raspberry Pi 4/5
# With optimized Chromium flags (hardware decoding enabled)

# ===== 1. Force Non-Interactive Mode =====
export DEBIAN_FRONTEND=noninteractive

# ===== 2. System Update =====
sudo apt update && sudo apt full-upgrade -y

# ===== 3. Install GNOME + GDM + Extensions =====
echo "gdm3 shared/default-display-manager select gdm3" | sudo debconf-set-selections
sudo apt install -y \
  gnome-core \
  gdm3 \
  gnome-shell \
  gnome-session \
  gnome-shell-extensions \
  gnome-tweaks \
  chromium-browser \
  chromium-codecs-ffmpeg-extra  # Added for better codec support

# ===== 4. Configure Wayland =====
# Nothing to do here at the moment

# ===== 5. GPU & Chromium Setup =====
# Mesa drivers (Pi 5)
sudo apt install -y \
  mesa-va-drivers \
  mesa-vulkan-drivers \
  libgl1-mesa-dri \
  libegl1-mesa \
  libgbm1

# ===== 6. Optimized Chromium flags & h264ify Plugin
sudo mkdir -p /etc/chromium.d/
echo 'CHROMIUM_FLAGS="--ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --disable-gpu-memory-buffer-video-frames --enable-features=VaapiVideoDecoder --disable-features=UseChromeOSDirectVideoDecoder --num-raster-threads=4 --enable-oop-rasterization --canvas-oop-rasterization --enable-native-gpu-memory-buffers"' | sudo tee /etc/chromium.d/custom-flags

# ===== 7. Final Steps =====
sudo systemctl set-default graphical.target
sudo apt autoremove -y

# ===== 8. Reboot =====
echo "Installation complete. Rebooting in 5 seconds..."
sleep 5
sudo reboot
