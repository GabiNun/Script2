curl -sL https://launcher.mojang.com/download/Minecraft.tar.gz | tar -xz -C /usr/bin/ --strip-components=1 minecraft-launcher/minecraft-launcher && chmod +x /usr/bin/minecraft-launcher
curl -sL "https://static.wikia.nocookie.net/minecraft_gamepedia/images/1/12/Minecraft_Launcher_MS_Icon.png/revision/latest?cb=20230618110121" -o /usr/bin/minecraft-launcher.png
cat > /usr/share/applications/minecraft-launcher.desktop <<EOF
[Desktop Entry]
Name=Minecraft Launcher
Comment=Custom Minecraft launcher
Exec=env GTK_IM_MODULE=none QT_IM_MODULE=none XMODIFIERS= __GLFW_IM_MODULE=none /usr/bin/minecraft-launcher
Icon=/usr/bin/minecraft-launcher.png
Terminal=false
Type=Application
Categories=Game;
EOF
