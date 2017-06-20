function _base16_linux {
	for s in color-scripts/*-256.sh; do
		echo "${s/color-scripts\//}"
		sed -i -e "s/\"base 16 /\"/i" -e "s/ 256\"/\"/" "$s"
		bash "$s"
	done
}

if ! dconf dump /org/gnome/terminal/legacy/profiles:/ | grep -qi harmonic16; then
	clone https://github.com/aaron-williamson/base16-gnome-terminal.git "$TMPDIR/base16-terminal"
	rundel "$TMPDIR/base16-terminal" _base16_linux
fi
