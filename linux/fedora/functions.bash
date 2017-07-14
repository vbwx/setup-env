source "$cwd/linux/centos/functions.bash"

function install {
	dnf -y install "$@"
}

