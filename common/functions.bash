function println {
	printf "%s\n" "$*"
}

function print {
	printf "%s" "$*"
}

function die {
	println "$script: $1" >&2
	exit 1
}

function warn {
	printf "\n%s!\n" "$*" >&2
}

function exist {
	type -t "$1" > /dev/null
}

function inshare {
	[[ -e "/usr/share/$1" || -e "$prefix/share/$1" || -e "$HOME/.local/share/$1" ]]
}

function islocal {
	local bin="$(type -P "$1" 2> /dev/null)"
	exist "$1" && [[ ${bin#*$prefix} != $bin ]]
}

function inhome {
	[[ -e "$HOME/$1" || -e "$HOME/.local/$1" ]]
}

function postinstall {
	true
}

function installed {
	exist "$1" || inshare "$1" || inhome "bin/$1"
}

function available {
	false
}

function rundel {
	local dir
	[[ ! -e ${@:(-1)} && ${download-} ]] && set - "$@" "$download"
	if [[ -e ${@:(-1)} ]]; then
		if [[ -d ${1-} ]]; then
			dir="$1"
			shift
			(
				cd "$dir"
				"$@"
				cd ..
				rm -rvf "$dir"
			)
		else
			"$@"
			rm -vf "${@:(-1)}"
		fi
		download=""
	fi
}

function clone {
	[[ -e "${@:(-1)}" ]] || git clone --recursive "$@"
}

function download {
	[[ ${2-} ]] || set - "$1" "$TMPDIR/$(basename "$1")"
	[[ -e $2 ]] && return
	curl --create-dirs -fsSLo "$2" "$1"
	download="$2"
}

function copy {
	local i dest
	if [[ ${1-} && ${2-}]]; then
		dest="${@:(-1)}"
		i=$[$#-2]
		[[ ${dest:(-1)} == '/' ]] && set - "${@:1:$i}" "$dest$(basename "$1")"
		makedir "$(dirname "$dest")"
		[[ -e "$dest" ]] || cp -Rvf "$@"
	fi
}

function difcopy {
	if [[ ${1-} && ${2-} ]]; then
		[[ ${2:(-1)} == '/' ]] && set - "$1" "$2$(basename "$1")"
		makedir "$(dirname "$2")"
		diff "$1" "$2" &> /dev/null || cp -vf "$1" "$2"
	fi
}

function move {
	local i dest
	if [[ ${1-} && ${2-} ]]; then
		i=$[$#-2]
		dest="${@:(-1)}"
		[[ ${dest:(-1)} == '/' ]] && set - "${@:1:$i}" "$dest$(basename "$1")"
		makedir "$(dirname "$dest")"
		[[ -e "$dest" ]] || mv -vf "$@"
	fi
}

function link {
	local i dest
	if [[ ${1-} ]]; then
		if [[ ${2-} ]]; then
			i=$[$#-2]
			dest="${@:(-1)}"
			if [[ ${dest:(-1)} == '/' ]]; then
				makedir "$dest"
			else
				makedir "$(dirname "$dest")"
			fi
		fi
		ln -vs "$@"
	fi
}

function makedir {
	if [[ ${1-} ]]; then
		[[ -d $1 ]] || mkdir -vp "$@"
	fi
}

function rerun {
	exec -c bash "$swd/$script" "${args[@]}"
}

function mapval {
	if [[ ${1-} && ${!1+1} ]]; then
		local map str mapvar=$1_map
		if [[ ${!mapvar-} ]]; then
			mapvar+="[@]"
			for str in "${!mapvar}"; do
				map=($(explode "$str"))
				[[ ${map[1]+1} && ${map[0]} == ${!1} ]] && declare -g $1="${map[1]}"
			done
		fi
	fi
}

function run {
	local name prev="$PWD"
	set +f
	for name in "$platform/$dist/$desktop/$1" "$platform/$desktop/$1" \
		"$platform/$dist/$1" "$platform/$1" "${2:-undefined}/$1"; do
		if [[ -e "$swd/$name.bash" ]]; then
			if [[ ${ref-} ]]; then
				println "$swd/$name.bash"
			else
				declare -g scope="$1"
				println ">>>> ${scope^}"
				source "$swd/$name.bash"
				cd "$prev"
				unset scope
			fi
			return
		fi
	done
	set -f
}

function load {
	declare -g scope="$1"
	local name prev="$PWD"
	for name in "${2:-undefined}/$1" "$platform/$1" "$platform/$dist/$1" \
		"$platform/$desktop/$1" "$platform/$dist/$desktop/$1"; do
		if [[ -e "$swd/$name.bash" ]]; then
			source "$swd/$name.bash"
		fi
	done
	cd "$prev"
	unset scope
}

function res {
	local name
	for name in "$platform/$dist/$desktop/res/$1" "$platform/$desktop/res/$1" \
		"$platform/$dist/res/$1" "$platform/res/$1" "${2:-undefined}/res/$1"; do
		if [[ -e "$swd/$name" ]]; then
			print "$swd/$name"
			return
		fi
	done
}

function use {
	local name
	for name in "$platform/$1" "$platform/$1/$desktop" "$1" "$1/$desktop"; do
		if [[ -e "$swd/$name/$scope.bash" ]]; then
			[[ ${ref-} ]] && print "$swd/$name/$scope.bash" || \
				source "$swd/$name/$scope.bash"
		fi
	done
}

function respath {
	local path
	if [[ $(res "$@") ]]; then
		path="$(res "$1.path" "${2-}")"
		if [[ -e $path ]]; then
			[[ ${ref-} ]] && print "$path" || \
				cat "$path" | modify "s/(^| )~/$(escape "$HOME")/g"
		fi
	fi
}

function var {
	local name
	for name in "${desktop}_${dist}_$1" "${desktop}_${platform}_$1" \
		"${dist}_$1" "${platform}_$1"; do
		if [[ ${!name+1} ]]; then
			[[ ${ref-} ]] && print "\$$name" || print "${!name}"
			return
		fi
	done
	if [[ ${!1+1} ]]; then
		[[ ${ref-} ]] && print "\$$1" || print "${!1}"
	else
		[[ ${ref-} ]] || print "${2-}"
	fi
}

function myvar {
	if [[ ${scope-} ]]; then
		var "${scope}_$1" "${2-}"
	else
		var "$1" "${2-}"
	fi
}

function list {
	local name str found=""
	[[ $# -eq 0 ]] && return
	for name in "$1" "${platform}_$1" "${dist}_$1" \
		"${desktop}_${platform}_$1" "${desktop}_${dist}_$1"; do
		if [[ ${!name+1} ]]; then
			if [[ ${ref-} ]]; then
				println "\$$name"
			else
				name+="[@]"
				found=1
				for str in "${!name}"; do
					println "${str//$'\n'/ }"
				done
			fi
		fi
	done
	if [[ ! $found && -z ${ref-} ]]; then
		shift
		for str in "$@"; do
			println "$str"
		done
	fi
}

function get {
	local str name
	[[ $# -eq 0 ]] && return
	if [[ ${!1+1} ]]; then
		if [[ ${ref-} ]]; then
			print "\$$1"
		else
			name="$1[@]"
			for str in "${!name}"; do
				println "${str//$'\n'/ }"
			done
		fi
	elif [[ -z ${ref-} ]]; then
		shift
		for str in "$@"; do
			println "$str"
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
	items=(${1//${2:-;}/$'\n'})
	print "$(trim "${items[@]}")"
}

function escape {
	print "$(echo "$1" | LC_ALL=C sed 's/[]\\\\/.$&*{}|+?()[^]/\\&/g')"
}

function quote {
	local first=1
	for str in "$@"; do
		[[ $first -eq 0 ]] && print " "
		first=0
		print "\"$(echo "$str" | LC_ALL=C sed -e \
			's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/' \
			)\""
	done
}

function modify {
	if [[ ${2-} ]]; then
		sed -E -i "~" "$1" "$2"
	else
		sed -E "$1"
	fi
}

function usage {
	println "usage: $script [OPTION]... CONFIG..." >&2
	if [[ $# -eq 0 ]]; then
		println "   or  $script --version"
	else
		println "Try '$script --help' for more information." >&2
		exit $1
	fi
	println
}

function help {
	usage 2>&1
	cat <<-EOF
	Set up your environment according to the currently used OS, desktop manager,
	and CONFIG files.

	Some commands require elevated privileges, so you may have to
	authenticate as administrator a few times.

	OPTIONS
	  -s    Show what would be done (doesn't install or delete anything)
	  -v    Explain what is being done
EOF
	exit
}
