exist pyenv || diecmd pyenv
eval "$(pyenv init -)"

if ! islocal python; then
	ver="$(pyenv install --list | sort -nr | perl -ne 'next unless /^\s*\d+\.\d+(\.\d+)?\n$/; s/\s//g; print; exit;')"
	[ "$ver" ] || die "Can't fetch latest Python version"
	CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" pyenv install "$ver" || die "Can't install Python"
	pyenv global "$ver"
fi
