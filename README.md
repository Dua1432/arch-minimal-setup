# 🚀 Arch Linux Minimal & Perfect Setup (KDE Plasma 6)

A fully automated, zero-bloat, and highly optimized setup script for a fresh **Arch Linux minimal installation**. This script transforms a barebones Arch install into a lightning-fast, ultra-cool, and production-ready KDE Plasma 6 (Wayland) desktop.

> **⚠️ IMPORTANT NOTE:** This script is currently configured for the username `huzidua`. If your username is different, please edit the script and replace `huzidua` with your actual username before running it.

---

## ✨ Key Features

- **🖥️ Pure KDE Plasma 6 (Wayland):** Installs only the core desktop components (`plasma-desktop`, `kwin`, `sddm`) with proper Wayland portal support (`xdg-desktop-portal-kde`). Zero bloat.
- **⚡ Ultimate Thermal Control:** Configures `auto-cpufreq` to aggressively mask `power-profiles-daemon`, ensuring maximum cooling (tested at ~38°C idle, 0 RPM fan on Intel i7). Turbo boost is disabled to prevent thermal throttling.
- **🎵 Complete Audio Stack:** Full PipeWire setup (`pipewire`, `pipewire-pulse`, `pipewire-alsa`, `wireplumber`) for flawless audio routing and low latency.
- **🎬 Hardware Acceleration Ready:** Pre-installs `intel-media-driver` and `libva-utils` for seamless video encoding/decoding (perfect for Shotcut, FFmpeg, etc.).
- **⌨️ Dual Terminal Setup:** 
  - **Alacritty:** Ultra-minimal, GPU-accelerated terminal for focused tasks (TTS, CLI tools).
  - **Kitty:** Feature-rich, GPU-accelerated terminal with built-in tabs/splits for multitasking. *(Both pre-configured with matching 12.0 font size, 160x45 dimensions, and `Shift+C`/`Shift+V` copy/paste shortcuts).*
- **🛡️ Security & Stability:** 
  - UFW Firewall enabled by default (deny incoming, allow outgoing).
  - Wi-Fi powersave disabled to prevent random network dropouts.
  - Bluetooth auto-connect enabled.
- **🧹 Auto-Cleanup:** Clears pacman cache and enables `fstrim.timer` for SSD health before rebooting.

---

## 📦 Included Applications
Only the essentials, nothing more:
- **Core:** `kate` (advanced text editor), `dolphin` (file manager), `partitionmanager`.
- **Terminals:** `alacritty`, `kitty`.
- **Media:** `ffmpeg`, `mpv`, `gst-plugins-bad`, `gst-plugins-ugly`, `gst-libav`.
- **Utilities:** `git`, `curl`, `ufw`, `base-devel`, `intel-ucode`.

---

## 🚀 How to Use (Post-Installation)

1. Install Arch Linux using the `archinstall` script (choose **Minimal** profile).
2. Boot into the black TTY screen and log in with your username.
3. Ensure you have an active internet connection (use `nmtui` if Wi-Fi is not connected).
4. Download and execute the setup script with this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/Dua1432/arch-minimal-setup/refs/heads/main/arch-minimal-setup.sh -o setup.sh && sudo bash setup.sh


5. Enter your sudo password when prompted. The script will take approximately 10-15 minutes to complete and will automatically reboot your system.
6. Upon reboot, select "Plasma (Wayland)" from the SDDM login screen.

⚠️ Disclaimer
This script is designed for a fresh, minimal Arch Linux installation. Running it on an existing, heavily customized system may cause conflicts. Always review the script's contents before executing it. Use at your own risk.
Crafted with ❤️ for the Arch Linux community.
