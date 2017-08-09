if ! inhome .config/autostart/nitrogen.desktop; then
	copy "$(res nitrogen.desktop)" "$HOME/.config/autostart/"
	nitrogen &> /dev/null &
fi
