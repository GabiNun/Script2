curl -sLo /usr/bin/minecraft-launcher https://github.com/GabiNun/Script/raw/main/minecraft-launcher && curl -sLo /usr/bin/minecraft-launcher.png https://github.com/GabiNun/Script/raw/main/minecraft-launcher.png



chmod +x /usr/bin/minecraft-launcher
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
