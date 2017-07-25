# Variables:
#     php_ver (string) The PHP version to be installed

local ver

clone https://github.com/phpenv/phpenv "$prefix/phpenv"
exist phpenv || PATH="$prefix/phpenv/bin:$PATH"

islocal php || eval "$(phpenv init -)"

if ! islocal php; then
	ver="$(myvar ver latest)"
	[[ $ver == "latest" ]] && ver="$(phpenv install --releases | sort -nr | perl -ne \
		'next unless /^\s*php-\d+\.\d+(\.\d+)?\n$/; s/\s//g; print; exit;')"
	phpenv install "$ver"
	phpenv global "$ver"
	phpenv rehash
fi

islocal php || rerun
