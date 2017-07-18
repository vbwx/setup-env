function available {
	grep -qi "$1" /etc/apt/sources.list /etc/apt/sources.list.d/*
}

function install {
	apt-get -y install "$@"
}

#function installed {
#}
