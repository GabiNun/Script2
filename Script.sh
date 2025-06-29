exec > /dev/null
chmod -R 777 /home/$(logname)

add_nodisplay() {
  file="$1"
  sed -i '/^NoDisplay=/d' "$file"
  echo 'NoDisplay=true' >> "$file"
}

add_nodisplay /usr/share/applications/gnome-language-selector.desktop
add_nodisplay /usr/share/applications/gnome-session-properties.desktop

sed -i '/^NoDisplay=true/d; /^Type=Application/a NoDisplay=true' /usr/share/applications/org.gnome.TextEditor.desktop

dpkg --add-architecture i386 && apt-get update -y
apt-get -y install steam virt-manager gnome-shell-extension-manager default-jdk libgl1 plasma-discover flatpak && apt-get remove -y firefox
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.vinegarhq.Sober

snap remove firefox firmware-updater desktop-security-center
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Brave.sh | sh
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Minecraft.sh | sudo sh

usermod -aG libvirt "$(logname)"
username=$(whoami); echo "$username ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/99-nopasswd && chmod 440 /etc/sudoers.d/99-nopasswd
