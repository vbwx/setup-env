function isroot {
	true
}

function installed {
	test -d "$prefix/Cellar/$1"
}

function available {
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
