die() {
	>&2 printf "\n$*!\n"
	exit 1
}

warn() {
	>&2 printf "\n$*!\n\n"
}

exist() {
	type -t "$1" > /dev/null
}

islocal() {
	bin="$(type -P "$1" 2> /dev/null)"
	exist "$1" && [[ ${bin#*$prefix} != $bin ]]
}

inhome() {
	[[ -e "$HOME/$1" ]]
}

rundel() {
	if [[ -d $1 ]]; then
		dir="$1"
		shift
		(
			cd "$dir"
			[[ -f $2 || -f $3 ]] && "$@" && cd .. && rm -rvf "$dir"
		) || die "Can't install $(basename "$dir")"
	else
		[[ -f $2 ]] && file="$2" || file="$3"
		([[ -f $file ]] && "$@" && rm -vf "$file") || die "Can't install $(basename "$file")"
	fi
}

clone() {
	[[ -e "${@:(-1)}" ]] || git clone "$@" || warn "Can't clone" "${@:(-2):1}"
}

download() {
	if [[ $# -eq 1 ]]; then
		curl -fsSL "$1" || warn "Can't download $1"
	else
		[[ -e $2 ]] || curl --create-dirs -fsSLo "$2" "$1" || warn "Can't download $1"
	fi
}

copy() {
	makedir "${@:(-1)}"
	[[ -e "${@:(-1)}/$(basename "$1")" ]] || cp -Rvf "$@" || exit 1
}

link() {
	ln -vs "$@" || exit 1
}

makedir() {
	[[ -d $1 ]] || mkdir -vp "$@" || exit 1
}

rerun() {
	exec -c bash "$cwd/$script" "$@"
}

help() {
}
