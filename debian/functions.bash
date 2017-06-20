inlists() {
	grep -qi "$1" /etc/apt/sources.list /etc/apt/sources.list.d/*
}

install() {
	apt-get -y install "$@"
}

