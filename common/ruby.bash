# Variables:
#     ruby_ver (string) The Ruby version to be installed
#     ruby_pkg (array) List of Ruby gems to be installed

local ver

eval "$(rbenv init -)"

if ! islocal ruby; then
	ver="$(myvar ver latest)"
	[[ $ver == "latest" ]] && ver="$(rbenv install --list | sort -nr | perl -ne \
		'next unless /^\s*\d+\.\d+(\.\d+)?\n$/; s/\s//g; print; exit;')"
	rbenv install "$ver"
	rbenv global "$ver"
fi

islocal gem || rerun
