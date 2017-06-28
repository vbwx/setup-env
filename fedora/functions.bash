source "$cwd/centos/functions.bash"

function install {
	dnf -y install "$@"
}

