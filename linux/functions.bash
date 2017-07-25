function modify {
	if [[ ${2-} ]]; then
		sed -i~ -r "$1" "$2"
	else
		sed -r "$1"
	fi
}

function isroot {
	[[ -w /etc ]]
}

function installapp {
	install "$@"
}

function rerun {
	exec -c sudo bash "$cwd/$script" "${args[@]}"
}
