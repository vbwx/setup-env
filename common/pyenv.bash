# Variables:
#     python_ver (string, default: latest) Python version to be installed
#     python_pkg (array) List of packages to be installed by pip

local ver

islocal python || eval "$(pyenv init -)"

if ! islocal python; then
	ver="$(myvar ver latest)"
	[[ $ver == "latest" ]] && ver="$(pyenv install --list | sort -nr | perl -ne \
		'next unless /^\s*\d+\.\d+(\.\d+)?\n$/; s/\s//g; print; exit;')"
	pyenv install "$ver"
	pyenv global "$ver"
fi

islocal pip || rerun
