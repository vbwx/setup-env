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
	local bin="$(type -P "$1" 2> /dev/null)"
	exist "$1" && [[ ${bin#*$prefix} != $bin ]]
}

function inhome {
	[[ -e "$HOME/$1" ]]
}

function rundel {
	local dir file
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
	[[ -e "${@:(-1)}/$(basename "$1")" ]] || cp -Rvf "$@"
}

function move {
	makedir "${@:(-1)}"
	[[ -e "${@:(-1)}/$(basename "$1")" ]] || mv -vf "$@"
}

function link {
	ln -vs "$@"
}

function makedir {
	[[ -d $1 ]] || mkdir -vp "$@"
}

function rerun {
	if [[ $platform == "linux" ]]; then
		exec -c sudo bash "$cwd/$script" "${args[@]}"
	else
		exec -c bash "$cwd/$script" "${args[@]}"
	fi
}

function mapval {
	set -f
	if [[ ${1-} && ${!1+1} ]]; then
		local map str mapvar=$1_map
		if [[ ${!mapvar-} ]]; then
			for str in "${!mapvar[@]}"; do
				IFS="=" eval 'map=($str)'
				[[ ${map[1]+1} && ${map[0]} == ${!1} ]] && declare -g $1="${map[1]}"
			done
		fi
	fi
	set +f
}

function run {
	# execute ubuntu/$1.bash, but not linux/$1.bash
}

function load {
	# execute linux/$1.bash and ubuntu/$1.bash
}

function getval {
	local name
	for name in "${desktop}_${dist}_$1" "${desktop}_${platform}_$1" \
		"${desktop}_$1" "${dist}_$1" "${platform}_$1"; do
		if [[ ${!name+1} ]]; then
			printf "${!name}"
			return
		fi
	done
	[[ ${!1} ]] && printf "${!1}"
}

function getlist {
	local name str
	for name in $1 "${platform}_$1" "${dist}_$1" "${desktop}_$1" \
		"${desktop}_${platform}_$1" "${desktop}_${dist}_$1"; do
		if [[ ${!name+1} ]]; then
			for str in "${!name[@]}"; do
				printf "$str\n"
			done
		fi
	done
}

function help {
	cat <<-EOF
	usage: $script CONFIG...
	
	Set up environment according to the currently used OS, desktop manager,
	and CONFIG files.
	
	On macOS, some commands require elevated privileges, so you may have to
	authenticate as administrator a few times.
EOF
}

