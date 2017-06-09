prefix=/usr/local
cfg="$HOME/.config/dotfiles"

TMPDIR="${TMPDIR:-/tmp}"
RBENV_ROOT="$prefix/rbenv"
PYENV_ROOT="$prefix/pyenv"
NVM_DIR="$prefix/nvm"
PERLBREW_ROOT="$prefix/perlbrew"

lpaths=(
	$prefix/bin
	$prefix/sbin
	$prefix/perlbrew/perls/default/bin
	$prefix/pyenv/shims
	$prefix/rbenv/shims
	$prefix/node/bin
)
texpaths=(
	/Library/TeX/texbin
)
