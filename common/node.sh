if [ ! -f "$NVM_DIR/nvm.sh" ]; then
	clone https://github.com/creationix/nvm.git $NVM_DIR && (
		cd $NVM_DIR
		git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" origin)" || die "Can't install nvm"
	)
fi
exist nvm || source "$NVM_DIR/nvm.sh" || diecmd nvm

if ! islocal node; then
	nvm install node || die "Can't install Node"
fi
[ -e $prefix/node ] || link "$NVM_DIR/versions/node/$(nvm current)" $prefix/node
