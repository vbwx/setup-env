if ! dconf dump /org/gnome/terminal/legacy/profiles:/ | grep -qi harmonic16; then
	clone https://github.com/aaron-williamson/base16-gnome-terminal.git "$TMPDIR/base16-terminal"
	rundel "$TMPDIR/base16-terminal" _install_base16
fi

