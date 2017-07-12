function println {
	printf "%s\n" "$*"
}

function print {
	printf "%s" "$*"
}

function die {
	>&2 printf "\n%s!\n" "$*"
	exit 1
}

function warn {
	>&2 printf "\n%s!\n\n" "$*"
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
	if [[ ${1-} ]]; then
		makedir "${@:(-1)}"
		[[ -e "${@:(-1)}/$(basename "$1")" ]] || cp -Rvf "$@"
	fi
}

function difcopy {
	if [[ -f ${1-} ]]; then
		local file="${2-}"
		if [[ -f $file ]]; then
			file="$file/$(basename "$1")"
			makedir "$2"
		else
			makedir "$(dirname "$2")"
		fi
		diff "$1" "$file" &> /dev/null || cp -vf "$@"
	fi
}

function move {
	if [[ ${1-} ]]; then
		makedir "${@:(-1)}"
		[[ -e "${@:(-1)}/$(basename "$1")" ]] || mv -vf "$@"
	fi
}

function link {
	if [[ ${1-} ]]; then
		ln -vs "$@"
	fi
}

function makedir {
	if [[ ${1-} ]]; then
		[[ -d $1 ]] || mkdir -vp "$@"
	fi
}

function rerun {
	if [[ $platform == "linux" ]]; then
		exec -c sudo bash "$cwd/$script" "${args[@]}"
	else
		exec -c bash "$cwd/$script" "${args[@]}"
	fi
}

function mapval {
	if [[ ${1-} && ${!1+1} ]]; then
		local map str mapvar=$1_map
		if [[ ${!mapvar-} ]]; then
			for str in "${!mapvar[@]}"; do
				map=($(explode "$str"))
				[[ ${map[1]+1} && ${map[0]} == ${!1} ]] && declare -g $1="${map[1]}"
			done
		fi
	fi
}

function run {
	local name
	set +f
	for name in "$platform/$dist/$desktop/$1" "$platform/$desktop/$1" \
		"$platform/$dist/$1" "$platform/$1" "${2-undefined}/$1"; do
		if [[ -f "$cwd/$name.bash" ]]; then
			scope="$1"
			println ">> ${scope^}"
			source "$cwd/$name.bash"
			unset scope
			return
		fi
	done
	set -f
}

function load {
	scope="$1"
	local name
	for name in "${2-undefined}/$1" "$platform/$1" "$platform/$dist/$1" \
		"$platform/$desktop/$1" "$platform/$dist/$desktop/$1"; do
		if [[ -f "$cwd/$name.bash" ]]; then
			source "$cwd/$name.bash"
		fi
	done
	unset scope
}

function res {
	local name
	for name in "$platform/$dist/$desktop/res/$1" "$platform/$desktop/res/$1" \
		"$platform/$dist/res/$1" "$platform/res/$1" "${2-undefined}/res/$1"; do
		if [[ -e "$cwd/$name" ]]; then
			print "$cwd/$name"
			return
		fi
	done
}

function respath {
	local path
	if [[ $(res "$@") ]]; then
		path="$(res "$1.path" "${2-}")"
		[[ -f $path ]] && cat "$path" | modify "s/(^| )~/$(quote "$HOME")/g"
	fi
}

function var {
	local name
	for name in "${desktop}_${dist}_$1" "${desktop}_${platform}_$1" \
		"${dist}_$1" "${platform}_$1"; do
		if [[ ${!name+1} ]]; then
			print "${!name}"
			return
		fi
	done
	[[ ${!1+1} ]] && print "${!1}" || print "${2-}"
}

function myvar {
	if [[ ${scope-} ]]; then
		var "${scope}_$1" "${2-}"
	else
		var "$1" "${2-}"
	fi
}

function list {
	local name str arg found=""
	[[ $# -eq 0 ]] && return
	for name in "$1" "${platform}_$1" "${dist}_$1" \
		"${desktop}_${platform}_$1" "${desktop}_${dist}_$1"; do
		if [[ ${!name+1} ]]; then
			found=1
			for str in "${!name[@]}"; do
				println "${str//$'\n'/ }"
			done
		fi
	done
	if [[ ! $found ]]; then
		shift
		for arg in "$@"; do
			println "$arg"
		done
	fi
}

function mylist {
	local name="$1"
	shift
	if [[ ${scope-} ]]; then
		list "${scope}_$name" "$@"
	else
		list "$name" "$@"
	fi
}

function trim {
	local str
	for str in "$@"; do
		str="${str#"${str%%[![:space:]]*}"}"
		str="${str%"${str##*[![:space:]]}"}"
		if [[ $str ]]; then
			if [[ $# -eq 1 ]]; then
				print "$str"
			else
				println "$str"
			fi
		fi
	done
}

function explode {
	[[ $# -eq 0 ]] && return
	local items
	items=(${1//${2-;}/$'\n'})
	print "$(trim "${items[@]}")"
}

function quote {
	print "$(echo "$1" | sed 's/[]\\\\/.$&*{}|+?()[^]/\\&/g')"
}

function modify {
	if [[ ${2-} ]]; then
		sed -E -i .bak "$1" "$2" || warn "Can't modify $2"
	else
		sed -E "$1"
	fi
}

function help {
	cat <<-EOF
	usage: $script CONFIG...

	Set up your environment according to the currently used OS, desktop manager,
	and CONFIG files.

	Some commands require elevated privileges, so you may have to
	authenticate as administrator a few times.
EOF
	exit
}
