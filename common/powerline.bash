if ! inhome "$font_path/Hack-Regular.ttf"; then
	clone https://github.com/powerline/fonts.git "$TMPDIR/powerline-fonts"
	rundel "$TMPDIR/powerline-fonts" bash install.sh
fi
