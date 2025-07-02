curl -sL https://launcher.mojang.com/download/Minecraft.tar.gz | tar -xz -C /usr/bin/ --strip-components=1 minecraft-launcher/minecraft-launcher && chmod +x /usr/bin/minecraft-launcher
curl -so /usr/bin/minecraft-launcher.svg https://raw.githubusercontent.com/GabiNun/Script/main/minecraft-launcher.svg
cat > /usr/share/applications/minecraft-launcher.desktop <<EOF
[Desktop Entry]
Name=Minecraft Launcher
Comment=Minecraft launcher
Exec=env GTK_IM_MODULE=none QT_IM_MODULE=none XMODIFIERS= __GLFW_IM_MODULE=none /usr/bin/minecraft-launcher
Icon=/usr/bin/minecraft-launcher.svg
Terminal=false
Type=Application
Categories=Game;
StartupWMClass=Minecraft Launcher
EOF

cat > /usr/share/applications/minecraft-game.desktop <<EOF
[Desktop Entry]
Name=Minecraft 1.21.7
Exec=/usr/bin/minecraft-launcher
Icon=/usr/bin/minecraft-launcher.svg
Type=Application
StartupWMClass=Minecraft 1.21.7
Categories=Game;
NoDisplay=true
EOF
