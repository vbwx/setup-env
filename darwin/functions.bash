function isroot {
	true
}

function poured {
	test -d "$prefix/Cellar/$1"
}

function tapped {
	test -d "$prefix/Library/Taps/$1"
}

function inlibs {
	test -e "/Library/$1" -o -e "$HOME/Library/$1"
}

function inapps {
	test -e "/Applications/$1.app" -o -e "$HOME/Applications/$1.app"
}

function install {
	brew install "$@"
}

function installapp {
	brew cask install "$@"
}

function modify {
	sed -i .bak -E "$1" "$2" || warn "Can't modify $2"
}
