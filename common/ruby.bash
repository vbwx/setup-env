exist rbenv || diecmd rbenv
eval "$(rbenv init -)"

if ! islocal ruby; then
	ver="$(rbenv install --list | sort -nr | perl -ne 'next unless /^\s*\d+\.\d+(\.\d+)?\n$/; s/\s//g; print; exit;')"
	[ "$ver" ] || die "Can't fetch latest Ruby version"
	rbenv install "$ver" || die "Can't install Ruby"
	rbenv global "$ver"
fi

exist gem   || diecmd gem
islocal gem || die "rbenv doesn't seem to be active"
