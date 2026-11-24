#!/bin/bash
echo "🚀 Jani's Arch Linux Perfect Setup Starting..."

# 0. Cache sudo password (PREVENTS script from hanging at AUR build!)
sudo -v
# Keep sudo alive in background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 0.1 Ensure Sudo is enabled for wheel group (Safety First)
sudo sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# 1. Initial Update
sudo pacman -Syu --noconfirm

# 2. Sudo Access Fix
sudo usermod -aG wheel huzidua

# 3. Plasma 6 Core + ONLY Kate & Dolphin + WAYLAND PORTALS (FIXED!)
sudo pacman -S --needed --noconfirm plasma-desktop plasma-workspace kwin sddm kate dolphin partitionmanager xdg-desktop-portal xdg-desktop-portal-kde pipewire pipewire-pulse pipewire-alsa wireplumber networkmanager plasma-nm plasma-pa breeze alacritty blueman bluez bluez-utils git curl intel-ucode ufw base-devel

# Enable Core Services
sudo systemctl enable sddm
sudo systemctl enable --now NetworkManager bluetooth

# 3.5 Power-Profiles-Daemon KO BAND KARO - Auto-CPUFreq se pehle, warna larai hogi
sudo systemctl stop power-profiles-daemon
sudo systemctl mask power-profiles-daemon

# 4. Firewall Permanent ON
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
sudo systemctl enable --now ufw

# 5. Heating Fix (auto-cpufreq - The Proven Winner)
rm -rf yay-bin
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

yay -S --needed --noconfirm auto-cpufreq

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

# 6. Bluetooth Auto-Connect Fix
sudo sed -i 's/^#\?AutoEnable=.*/AutoEnable=true/' /etc/bluetooth/main.conf
sudo systemctl restart bluetooth

# 7. Alacritty Config (User's Favorite Terminal)
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

# 8. Intel Hardware Acceleration (For Shotcut/Video Encoding)
sudo pacman -S --needed --noconfirm intel-media-driver libva-utils

# 9. Essential Media Codecs
sudo pacman -S --needed --noconfirm ffmpeg gst-plugins-bad gst-plugins-ugly gst-libav mpv

# 10. Wi-Fi Power Save Fix (FIXED NAMING)
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[connection]\nwifi.powersave = 2" | sudo tee /etc/NetworkManager/conf.d/disable-wifi-powersave.conf
sudo systemctl restart NetworkManager

# 11. Final Cleanup + Reboot
sudo pacman -Sc --noconfirm
sudo systemctl enable --now fstrim.timer

echo "==========================================="
echo "✅ Jani, ARCH TRUE MINIMAL & PERFECT setup complete!"
echo "✅ Rebooting in 5 seconds..."
echo "==========================================="
sleep 5
sudo reboot
