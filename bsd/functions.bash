function rerun {
	exec -c su -c "bash \"$swd/$script\" $(quote "${args[@]}")"
}
