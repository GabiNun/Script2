exec > /dev/null
chmod -R 777 /home/$(logname)

k=("org.gnome.Settings.desktop" "org.gnome.Terminal.desktop")
for f in /usr/share/applications/*.desktop; do
  [[ " ${k[*]} " =~ " $(basename "$f") " ]] && continue
  grep -q "NoDisplay=" "$f" && sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$f" || echo "NoDisplay=true" | tee -a "$f" >/dev/null
done

dpkg --add-architecture i386 && apt-get update -y
apt-get -y install steam gnome-shell-extension-manager flatpak && apt-get purge -y firefox papers papers-common
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.vinegarhq.Sober

snap remove firefox firmware-updater desktop-security-center
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Brave.sh | sh
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Minecraft.sh | sh
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Settings.sh | sh

username=$(whoami); echo "$username ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers.d/99-nopasswd && chmod 440 /etc/sudoers.d/99-nopasswd
