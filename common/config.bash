prefix=/usr/local
cfg="$HOME/.config/dotfiles"

export TMPDIR="${TMPDIR:-/tmp}"
export RBENV_ROOT="$prefix/rbenv"
export PYENV_ROOT="$prefix/pyenv"
export NVM_DIR="$prefix/nvm"
export PERLBREW_ROOT="$prefix/perlbrew"
export PHPENV_ROOT="$prefix/phpenv"

lpaths=(
	$prefix/bin
	$prefix/sbin
	$prefix/perlbrew/perls/default/bin
	$prefix/pyenv/shims
	$prefix/rbenv/shims
	$prefix/phpenv/bin
	$prefix/phpenv/shims
	$prefix/node/bin
)
texpaths=(
	/Library/TeX/texbin
)
