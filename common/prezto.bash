local rcfile

clone https://github.com/vbwx/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
if [ ! -L "${ZDOTDIR:-$HOME}/.zpreztorc" ]; then
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/!(README.md); do
		link "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	done
fi

println "SHELL = $SHELL"
[[ $SHELL = "/bin/zsh" ]] || chsh -s /bin/zsh

inhome .hushlogin || touch "$HOME/.hushlogin"
