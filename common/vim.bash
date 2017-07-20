# Variables:
#     vim_lang (string) Short ISO code of the spelling file to be downloaded
#         For example:
#          - de
#          - es
#          - fr
#     vim_pm (string) Short name of the package manager to be installed
#         Possible values:
#          - plug
#          - vundle
#          - neobundle
#          - dein
#          - pathogen
#          - vam

if [[ $(myvar lang) ]]; then
	local lang="$(myvar lang)"
	download "http://ftp.vim.org/pub/vim/runtime/spell/$lang.utf-8.spl" "$HOME/.vim/spell/$lang.utf-8.spl"
fi

case $(myvar pm) in
	(plug)
		if ! inhome .vim/autoload/plug.vim; then
			download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
				"$HOME/.vim/autoload/plug.vim"
			$prefix/bin/vim -c PlugInstall -c q
		fi
		;;
	(*)
		warn "Invalid value in $(ref=1 myvar pm)"
		;;
esac
