# Get your pointing device ID from `xinput --list --short`

if ! inhome .config/autostart/mouse-speed.desktop; then
	[ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
	file="$setup/mouse-speed"
	modify "s/\$ids/$(myvar ids)/" "$file"
	copy "$file" "$HOME/.local/bin"
	file="$setup/mouse-speed.desktop"
	modify "s/~\\//$HOME\\//" "$file"
	copy "$file" "$HOME/.config/autostart"
fi
