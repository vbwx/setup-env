function inshare {
	[[ -e "/usr/share/$1" || -e "$prefix/share/$1" ]]
}

function modify {
	sed -i.bak -r "$1" "$2" || warn "Can't modify $2"
}

function isroot {
	[[ -w /etc ]]
}

function installapp {
}

