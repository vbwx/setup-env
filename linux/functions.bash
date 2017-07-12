function inshare {
	[[ -e "/usr/share/$1" || -e "$prefix/share/$1" ]]
}

function modify {
	if [[ ${2-} ]]; then
		sed -i.bak -r "$1" "$2" || warn "Can't modify $2"
	else
		sed -r "$1"
	fi
}

function isroot {
	[[ -w /etc ]]
}

function installapp {
}

