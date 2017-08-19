# Variables:
#     node_ver (string, default: latest) The Node.js version to be installed

local ver

if [[ ! -f "$NVM_DIR/nvm.sh" ]]; then
	clone https://github.com/creationix/nvm.git $NVM_DIR
	cd $NVM_DIR
	git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" origin)"
fi

exist nvm || source "$NVM_DIR/nvm.sh"

if ! islocal node; then
	ver="$(myvar ver latest)"
	[[ $ver == "latest" ]] && ver="node"
	nvm install "$ver"
fi

[ -e $prefix/node ] || link "$NVM_DIR/versions/node/$(nvm current)" $prefix/node
