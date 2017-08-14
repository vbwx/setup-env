# Variables:
#     mouse_speed_ids (string) IDs of pointing devices in use, space-separated

local ids file

if ! inhome .config/autostart/mouse-speed.desktop; then
	ids="$(myvar ids)"
	[[ $ids ]] || ids="$(xinput --list --short | perl -ne \
		'print "$1 " if /(?:mouse|track ?(?:pad)?|touch ?pad).+id=(\d+)/i;')"
	makedir "$HOME/.local/bin"
	file="$(res mouse-speed)"
	modify "s/{ids}/$ids/" "$file"
	copy "$file" "$HOME/.local/bin/"
	file="$(res mouse-speed.desktop)"
	modify "s/~\\//$HOME\\//" "$file"
	copy "$file" "$HOME/.config/autostart/"
fi
