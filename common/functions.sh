die() {
	>&2 echo -e "\n$*!"
	exit 1
}

warn() {
	>&2 echo -e "\n$*!\n"
}

isroot() {
	test -w /etc
}

exist() {
	type -t "$1" > /dev/null
}

islocal() {
	bin="$(type -P "$1" 2> /dev/null)"
	exist "$1" && test "${bin#*$prefix}" != "$bin"
}

inshare() {
	test -e "/usr/share/$1" || test -e "$prefix/share/$1"
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

inhome() {
	test -e "$HOME/$1"
}

inlists() {
	grep -qi "$1" /etc/apt/sources.list /etc/apt/sources.list.d/*
}

install() {
	apt-get -y install "$@"
	brew install "$@"
}

installc() {
	brew cask install "$@"
}

rundel() {
	if [ -d "$1" ]; then
		dir="$1"
		shift
		(
			cd "$dir"
			[ -f "$2" -o -f "$3" ] && "$@" && \
				cd .. && rm -rvf "$dir"
		) || die "Can't install $(basename "$dir")"
	else
		[ -f "$2" ] && file="$2" || file="$3"
		([ -f "$file" ] && "$@" && rm -vf "$file") || \
			die "Can't install $(basename "$file")"
	fi
}

clone() {
	[ -e "${@:(-1)}" ] || git clone "$@" || warn "Can't clone" "${@:(-2):1}"
}

download() {
	if [ $# -eq 1 ]; then
		curl -fsSL "$1" || warn "Can't download $1"
	else
		[ -e "$2" ] || curl --create-dirs -fsSLo "$2" "$1" || warn "Can't download $1"
	fi
}

modify() {
	sed -i -re "$1" "$2" || warn "Can't modify $2"
}

copy() {
	makedir "${@:(-1)}"
	[ -e "${@:(-1)}/$(basename "$1")" ] || cp -Rvf "$@" || exit 1
}

link() {
	ln -vs "$@" || exit 1
}

makedir() {
	[ -d "$1" ] || mkdir -vp "$@" || exit 1
}
