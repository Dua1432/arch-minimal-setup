# 🚀 Arch Linux Minimal & Perfect Setup (KDE Plasma 6)

A fully automated, zero-bloat, and highly optimized setup script for a fresh **Arch Linux minimal installation**. This script transforms a barebones Arch install into a lightning-fast, ultra-cool, and production-ready KDE Plasma 6 (Wayland) desktop.

> **⚠️ USERNAME NOTE:** This script is configured for the username `huzidua`. If your username is different, edit the script and replace every `huzidua` with your actual username before running it.

> **⚠️ RUN AS NORMAL USER:** Do **NOT** run this script with `sudo bash`. The AUR helper (`yay`/`makepkg`) refuses to run as root. Run it as your regular user (`bash setup.sh`); the script calls `sudo` internally only where needed.

> **📶 CONNECT FIRST:** Connect to the internet (Wi-Fi/Ethernet) **before** running the script, so the automatic DNS step can apply to your saved connection.

---

## ✨ Key Features

- **🖥️ Pure KDE Plasma 6 (Wayland):** Installs only core desktop components (`plasma-desktop`, `kwin`, `sddm`) with proper Wayland portal support (`xdg-desktop-portal-kde`). Zero bloat.
- **⚡ Ultimate Thermal Control:** Configures `auto-cpufreq` and masks `power-profiles-daemon` to avoid conflicts (tested ~38–40°C idle, 0 RPM fan on Intel i7). Turbo boost disabled to prevent thermal throttling.
- **🎵 Complete Audio Stack + Auto-Fix:** Full PipeWire setup (`pipewire`, `pipewire-pulse`, `pipewire-alsa`, `wireplumber`). Additionally installs `alsa-utils`, `sof-firmware`, `alsa-firmware`, then **automatically sets every playback channel to 100%, disables Auto-Mute, and saves the state permanently** (`alsactl store` + `alsa-restore.service`). No manual `alsamixer` needed — fixes the classic "low headphone volume" issue out of the box.
- **🎬 Full Intel Hardware Acceleration:** Installs the complete archinstall-style Intel stack (`mesa`, `vulkan-intel`, `intel-media-driver`, `libva-intel-driver`, `libva-utils`). **MPV is pre-configured for GPU decoding** (`hwdec=auto`, `vo=gpu`) for smooth, cool playback.
- **🌐 Smart Networking:** Wi-Fi powersave disabled (prevents dropouts) **plus automatic DNS** (Cloudflare `1.1.1.1` + Google `8.8.8.8`, with IPv6 equivalents) applied to all real Wi-Fi/Ethernet connections.
- **⌨️ Dual Terminal Setup:**
  - **Alacritty:** Ultra-minimal, GPU-accelerated terminal for focused tasks (TTS, CLI tools).
  - **Kitty:** Feature-rich terminal with tabs/splits for multitasking.
  *(Both pre-configured with matching 12.0 font, 160x45 size, and `Shift+C`/`Shift+V` copy/paste.)*
- **🛡️ Security & Stability:**
  - UFW firewall enabled (deny incoming, allow outgoing).
  - Bluetooth auto-connect enabled.
  - Sudo rights granted via a **validated drop-in** (`/etc/sudoers.d/` + `visudo -c`) instead of risky direct edits.
- **🧠 Safe & Idempotent:** Swap creation is re-run safe and **filesystem-aware (ext4 + Btrfs)**; CPU microcode is regenerated on GRUB systems; DNS only touches real network connections.
- **🧹 Auto-Cleanup:** Clears pacman cache and enables `fstrim.timer` for SSD health before rebooting.

---

## 📦 Included Applications

Only the essentials, nothing more:

- **Core:** `kate`, `dolphin`, `partitionmanager`
- **Terminals:** `alacritty`, `kitty`
- **Browser & Chat:** `google-chrome` (AUR), `telegram-desktop`
- **Media:** `ffmpeg`, `mpv` (GPU-configured), `gst-plugins-bad`, `gst-plugins-ugly`, `gst-libav`
- **Audio:** `alsa-utils`, `sof-firmware`, `alsa-firmware`
- **Graphics:** `mesa`, `vulkan-intel`, `intel-media-driver`, `libva-intel-driver`, `libva-utils`
- **Utilities:** `git`, `curl`, `ufw`, `base-devel`, `intel-ucode`, `fuse2`
- **AUR:** `yay-bin`, `auto-cpufreq`, `google-chrome`

---

## 🚀 How to Use (Post-Installation)

1. Install Arch Linux using `archinstall` (choose the **Minimal** profile).
2. Boot into the TTY and log in with your username.
3. Connect to the internet (use `nmtui` for Wi-Fi). **Required for the DNS step.**
4. Download and run the script **as your normal user** (see command below).
5. Enter your sudo password when prompted. The script takes ~10–20 minutes and reboots automatically.
6. On reboot, select **"Plasma (Wayland)"** at the SDDM login screen.

---

## ⚡ Quick Run Command

Copy and paste this single line in your Arch TTY (as your **regular user**, not root):

```bash
curl -fsSL https://raw.githubusercontent.com/Dua1432/arch-minimal-setup/refs/heads/main/arch-minimal-setup.sh -o setup.sh && bash setup.sh
```

---

## ⚠️ Disclaimer

This script is designed for a **fresh, minimal Arch Linux installation**. Running it on an existing, heavily customized system may cause conflicts. Always review the script before executing. Use at your own risk.

Crafted with ❤️ for the Arch Linux community.
