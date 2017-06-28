if ! inhome .config/autostart/nitrogen.desktop; then
	copy "$setup/nitrogen.desktop" "$HOME/.config/autostart"
	nitrogen &> /dev/null & || diecmd nitrogen
fi

