function installapp {
	install "$@"
}

function rerun {
	exec -c su -c "bash \"$cwd/$script\" $(quote "${args[@]}")"
}
