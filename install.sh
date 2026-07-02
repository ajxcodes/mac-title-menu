echo "Installing mac-title-menu"
DEST=~/.local/share/plasma/plasmoids/com.ajxcodes.macappmenu
rm -rf "$DEST"
mkdir -p "$DEST"
cp -r contents metadata.json "$DEST"
systemctl --user restart plasma-plasmashell.service
echo "Installed mac-title-menu"
