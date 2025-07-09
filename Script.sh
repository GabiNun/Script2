exec > /dev/null
chmod -R 777 /home/$(logname)

k=("org.gnome.Settings.desktop" "org.gnome.Terminal.desktop")
for f in /usr/share/applications/*.desktop; do
  [[ " ${k[*]} " =~ " $(basename "$f") " ]] && continue
  grep -q "NoDisplay=" "$f" && sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$f" || echo "NoDisplay=true" | tee -a "$f" >/dev/null
done

dpkg --add-architecture i386 && apt-get update -y
apt-get -y install steam gnome-shell-extension-manager flatpak && apt-get purge -y firefox papers papers-common ubuntu-report popularity-contest apport whoopsie apport-symptoms
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.vinegarhq.Sober

snap remove firefox firmware-updater desktop-security-center
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Brave.sh | sh
curl -fsSL https://raw.githubusercontent.com/GabiNun/Script/main/Minecraft.sh | sh

echo "gabi ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/gabi
sudo chmod 440 /etc/sudoers.d/gabi

echo 'polkit.addRule(function(action, subject) {
    if (subject.isInGroup("sudo") && subject.user == "gabi") {
        return polkit.Result.YES;
    }
});' | sudo tee /etc/polkit-1/rules.d/49-nopasswd.rules
