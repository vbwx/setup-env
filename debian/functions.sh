#!/bin/bash

die() {
	>&2 echo -e "\n$*!"
	exit 1
}

diecmd() {
	>&2 echo -e "\nCommand not found: $1"
	>&2 echo "Open a new shell and run this script again to continue with the setup."
	exit 127
}

warn() {
	>&2 echo -e "\n$*!\n"
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

inhome() {
	test -e "$HOME/$1"
}

inlists() {
	grep -qi "$1" /etc/apt/sources.list /etc/apt/sources.list.d/*
}

install() {
	apt-get -y install "$@"
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
	echo "$1"
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
