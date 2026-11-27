#!/bin/bash
echo "==========================================="
echo " Jani's Arch Linux Minimal & Perfect Setup"
echo "==========================================="

# 0. Cache sudo password (prevents hanging during AUR builds)
sudo -v
# Keep sudo alive in the background until the script exits
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 0.1 Ensure the wheel group has sudo rights (safe drop-in, syntax-validated)
echo '%wheel ALL=(ALL:ALL) ALL' | sudo tee /etc/sudoers.d/10-wheel >/dev/null
sudo chmod 440 /etc/sudoers.d/10-wheel
sudo visudo -c

# 1. Full system update
sudo pacman -Syu --noconfirm

# 2. Add user to the wheel group
sudo usermod -aG wheel huzidua

# 3. Plasma 6 core + apps + Wayland portals + fuse2 + nano
sudo pacman -S --needed --noconfirm plasma-desktop plasma-workspace kwin sddm kate dolphin kitty partitionmanager xdg-desktop-portal xdg-desktop-portal-kde pipewire pipewire-pulse pipewire-alsa wireplumber networkmanager plasma-nm plasma-pa breeze alacritty blueman bluez bluez-utils git curl intel-ucode ufw base-devel fuse2 nano

# Enable core services
sudo systemctl enable sddm
sudo systemctl enable --now NetworkManager bluetooth

# 3.5 Disable power-profiles-daemon BEFORE auto-cpufreq (they conflict)
sudo systemctl stop power-profiles-daemon 2>/dev/null || true
sudo systemctl mask power-profiles-daemon 2>/dev/null || true

# 4. Firewall: permanent ON
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
sudo systemctl enable --now ufw
sudo pacman -S --needed --noconfirm gufw

# 5. AUR helper (yay) + auto-cpufreq + Google Chrome
rm -rf yay-bin
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

# CPU temperature / power management
yay -S --needed --noconfirm auto-cpufreq
# Google Chrome (official stable, from AUR)
yay -S --needed --noconfirm google-chrome

# 5.5 Auto-configure Chrome desktop entry (Gemini + minimize/maximize buttons)
# Copy the system entry to the user dir, then inject flags into EVERY Exec line.
mkdir -p /home/huzidua/.local/share/applications
cp /usr/share/applications/google-chrome.desktop /home/huzidua/.local/share/applications/
sed -i 's|^Exec=/usr/bin/google-chrome-stable |Exec=/usr/bin/google-chrome-stable --enable-features=Glic,GlicSidePanel,GeminiInChrome --ozone-platform-hint=auto |' /home/huzidua/.local/share/applications/google-chrome.desktop

sudo tee /etc/auto-cpufreq.conf << 'EOF'
[battery]
governor = powersave
energy_performance_preference = power
turbo = never
[charger]
governor = powersave
energy_performance_preference = balance_performance
turbo = never
EOF
sudo systemctl enable --now auto-cpufreq

# 6. Bluetooth auto-connect fix
sudo sed -i 's/^#\?AutoEnable=.*/AutoEnable=true/' /etc/bluetooth/main.conf
sudo systemctl restart bluetooth

# 7. Alacritty config (preferred terminal for TTS / OpenCode)
mkdir -p /home/huzidua/.config/alacritty
cat << 'EOF' > /home/huzidua/.config/alacritty/alacritty.toml
[[keyboard.bindings]]
key = "C"
mods = "Shift"
action = "Copy"
[[keyboard.bindings]]
key = "V"
mods = "Shift"
action = "Paste"
[font]
size = 12.0
[window]
dimensions = { columns = 160, lines = 45 }
EOF
sudo chown -R huzidua:huzidua /home/huzidua/.config/alacritty

# 7.5 Kitty config (same size, font and Shift+C/V shortcuts as Alacritty)
mkdir -p /home/huzidua/.config/kitty
cat << 'EOF' > /home/huzidua/.config/kitty/kitty.conf
font_size 12.0
initial_window_width 160c
initial_window_height 45c
map shift+c copy_to_clipboard
map shift+v paste_from_clipboard
EOF
sudo chown -R huzidua:huzidua /home/huzidua/.config/kitty

# 8. Intel graphics drivers + hardware acceleration (archinstall-style)
sudo pacman -S --needed --noconfirm mesa vulkan-intel intel-media-driver libva-intel-driver libva-utils

# 8.5 MPV: enable hardware decoding (use GPU, not CPU)
mkdir -p /home/huzidua/.config/mpv
cat << 'EOF' > /home/huzidua/.config/mpv/mpv.conf
hwdec=auto
vo=gpu
EOF
sudo chown -R huzidua:huzidua /home/huzidua/.config/mpv

# 8.6 Make sure CPU microcode actually loads (GRUB systems only)
if [ -d /boot/grub ]; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# 9. Media codecs + latest Python (for TTS) + Telegram
sudo pacman -S --needed --noconfirm python python-pip ffmpeg gst-plugins-bad gst-plugins-ugly gst-libav mpv telegram-desktop

# 9.5 KDE utilities: screenshot, system monitor, archive, image viewer, video thumbnails, display settings
# (--noconfirm auto-selects the default provider, so no manual prompt input is needed)
sudo pacman -S --needed --noconfirm spectacle plasma-systemmonitor ark gthumb ffmpegthumbs kscreen

# 9.6 Audio: auto 100% volume + Auto-Mute OFF + permanent save (no manual alsamixer)
sudo pacman -S --needed --noconfirm alsa-utils sof-firmware alsa-firmware
# Loop every sound card so the correct analog device is always configured
for card in /proc/asound/card[0-9]*; do
    idx=${card##*card}
    for ctrl in Master Headphone Speaker PCM Front; do
        amixer -c "$idx" sset "$ctrl" 100% unmute 2>/dev/null || true
    done
    amixer -c "$idx" sset 'Auto-Mute Mode' 'Disabled' 2>/dev/null || true
done
sudo alsactl store
sudo systemctl enable alsa-restore.service 2>/dev/null || true

# 9.7 GTK window buttons + Breeze theme
sudo pacman -S --needed --noconfirm kde-gtk-config breeze-gtk

# 9.8 Chrome system titlebar
pkill -TERM -f '^/opt/google/chrome/chrome --' 2>/dev/null || true
sleep 2
python3 - <<'PY'
import json, os, glob, shutil, tempfile
base = os.path.expanduser("~/.config/google-chrome")
for p in [os.path.join(base,"Default","Preferences")] + sorted(glob.glob(os.path.join(base,"Profile *","Preferences"))):
    if not os.path.exists(p): continue
    try: d = json.load(open(p))
    except Exception: continue
    d.setdefault("browser",{})["custom_chrome_frame"] = False
    if not os.path.exists(p+".bak"): shutil.copy2(p, p+".bak")
    fd,t = tempfile.mkstemp(dir=os.path.dirname(p))
    with os.fdopen(fd,"w") as f: json.dump(d,f,separators=(",",":"))
    os.chmod(t,0o600); os.replace(t,p)
PY

# 9.9 OpenCode CLI
curl -fsSL https://opencode.ai/v2/install | bash

# 10. Wi-Fi power-save OFF + automatic DNS (Cloudflare + Google, IPv4 & IPv6)
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[connection]\nwifi.powersave = 2" | sudo tee /etc/NetworkManager/conf.d/disable-wifi-powersave.conf
# Apply DNS only to real Wi-Fi / Ethernet connections (handles names with spaces)
nmcli -t -f NAME,TYPE connection show | grep -E ':(802-11-wireless|802-3-ethernet)$' | cut -d: -f1 | while IFS= read -r conn; do
    sudo nmcli connection modify "$conn" \
        ipv4.dns "1.1.1.1 8.8.8.8" ipv4.ignore-auto-dns yes \
        ipv6.dns "2606:4700:4700::1111 2001:4860:4860::8888" ipv6.ignore-auto-dns yes
done
sudo systemctl restart NetworkManager

# 11. Cleanup + SSD trim timer
sudo pacman -Sc --noconfirm
sudo systemctl enable --now fstrim.timer

# 12. Create 16GB swap file (idempotent + filesystem-aware: ext4 / btrfs)
if [ ! -f /swapfile ]; then
    ROOT_FS=$(findmnt -no FSTYPE /)
    if [ "$ROOT_FS" = "btrfs" ]; then
        sudo btrfs filesystem mkswapfile --size 16g /swapfile
    else
        sudo fallocate -l 16G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
    fi
fi
sudo swapon /swapfile 2>/dev/null || true
grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "==========================================="
echo " Setup complete. Rebooting in 5 seconds..."
echo "==========================================="
sleep 5
sudo reboot
