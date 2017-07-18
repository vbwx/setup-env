if ! inhome .config/dotfiles; then
	clone https://github.com/vbwx/dotfiles $HOME/.config/dotfiles
	$HOME/.config/dotfiles/install
fi
