function _install_base16 {
	for p in profiles/*.terminal; do
		xattr -d com.apple.quarantine "$p"
		open "$p"
	done
}

if ! plutil -p "$HOME/Library/Preferences/com.apple.Terminal.plist" | grep -qi harmonic16; then
	clone https://github.com/vbwx/base16-terminal-app.git "$TMPDIR/base16-terminal"
	rundel "$TMPDIR/base16-terminal" _install_base16
fi

