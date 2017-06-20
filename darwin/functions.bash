isroot() {
	true
}

poured() {
	test -d "$prefix/Cellar/$1"
}

tapped() {
	test -d "$prefix/Library/Taps/$1"
}

inlibs() {
	test -e "/Library/$1" -o -e "$HOME/Library/$1"
}

inapps() {
	test -e "/Applications/$1.app" -o -e "$HOME/Applications/$1.app"
}

install() {
	brew install "$@"
}

installc() {
	brew cask install "$@"
}

modify() {
	sed -i .bak -E "$1" "$2" || warn "Can't modify $2"
}
