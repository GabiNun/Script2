#!/bin/sh

echo "Setting full permissions for /home/$(logname)..."
chmod -R 777 /home/$(logname)

add_nodisplay() {
  file="$1"
  echo "Hiding $file from application menu..."
  sed -i '/^NoDisplay=/d' "$file"
  echo 'NoDisplay=true' >> "$file"
}

add_nodisplay /usr/share/applications/gnome-language-selector.desktop
add_nodisplay /usr/share/applications/gnome-session-properties.desktop

echo "Hiding org.gnome.TextEditor.desktop from application menu..."
sed -i '/^NoDisplay=true/d; /^Type=Application/a NoDisplay=true' /usr/share/applications/org.gnome.TextEditor.desktop

echo "Adding i386 architecture and updating package lists..."
dpkg --add-architecture i386 && apt-get update -y

echo "Installing essential packages..."
apt-get -y install steam virt-manager gnome-shell-extension-manager default-jdk libgl1 plasma-discover flatpak

echo "Removing Firefox (APT version)..."
apt-get remove -y firefox

echo "Adding Flathub repository and installing Sober from Flatpak..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.vinegarhq.Sober

echo "Removing snap packages..."
snap remove firefox firmware-updater desktop-security-center

echo "Installing Brave browser..."
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Brave.sh | sh

echo "Installing Minecraft launcher..."
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Minecraft.sh | sh

echo "Adding user $(logname) to libvirt group..."
usermod -aG libvirt "$(logname)"

echo "Granting passwordless sudo to $username..."
username=$(whoami)
echo "$username ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/99-nopasswd
chmod 440 /etc/sudoers.d/99-nopasswd

echo "All done!"
