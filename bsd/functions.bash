function installapp {
	install "$@"
}

function rerun {
	exec -c su -c "bash \"$swd/$script\" $(quote "${args[@]}")"
}
