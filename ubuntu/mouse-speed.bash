if ! inhome .config/autostart/mouse-speed.desktop; then
	[ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
	xinput --list --short
	echo -n "IDs of your pointing devices (space-separated): "
	read ids
	file="$setup/mouse-speed"
	modify "s/\$ids/$ids/" "$file"
	copy "$file" "$HOME/.local/bin"
	file="$setup/mouse-speed.desktop"
	modify "s/~\\//$HOME\\//" "$file"
	copy "$file" "$HOME/.config/autostart"
fi

