function die {
	>&2 printf "\n$*!\n"
	exit 1
}

function warn {
	>&2 printf "\n$*!\n\n"
}

function exist {
	type -t "$1" > /dev/null
}

function islocal {
	bin="$(type -P "$1" 2> /dev/null)"
	exist "$1" && [[ ${bin#*$prefix} != $bin ]]
}

function inhome {
	[[ -e "$HOME/$1" ]]
}

function rundel {
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

function clone {
	[[ -e "${@:(-1)}" ]] || git clone "$@" || warn "Can't clone" "${@:(-2):1}"
}

function download {
	if [[ $# -eq 1 ]]; then
		curl -fsSL "$1" || warn "Can't download $1"
	else
		[[ -e $2 ]] || curl --create-dirs -fsSLo "$2" "$1" || warn "Can't download $1"
	fi
}

function copy {
	makedir "${@:(-1)}"
	[[ -e "${@:(-1)}/$(basename "$1")" ]] || cp -Rvf "$@" || exit 1
}

function link {
	ln -vs "$@" || exit 1
}

function makedir {
	[[ -d $1 ]] || mkdir -vp "$@" || exit 1
}

function rerun {
	exec -c bash "$cwd/$script" "$@"
}

function help {
}
