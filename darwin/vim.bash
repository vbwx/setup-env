[ -r "$(res mvim)" ] || die "Can't find mvim script"
difcopy "$(res mvim)" $prefix/bin

islocal vi       || link $prefix/bin/mvim $prefix/bin/vi
islocal vim      || link $prefix/bin/mvim $prefix/bin/vim
islocal gvim     || link $prefix/bin/mvim $prefix/bin/gvim
islocal rvim     || link $prefix/bin/mvim $prefix/bin/rvim
islocal rmvim    || link $prefix/bin/mvim $prefix/bin/rmvim
islocal rgvim    || link $prefix/bin/mvim $prefix/bin/rgvim
islocal view     || link $prefix/bin/mvim $prefix/bin/view
islocal gview    || link $prefix/bin/mvim $prefix/bin/gview
islocal mview    || link $prefix/bin/mvim $prefix/bin/mview
islocal vimdiff  || link $prefix/bin/mvim $prefix/bin/vimdiff
islocal gvimdiff || link $prefix/bin/mvim $prefix/bin/gvimdiff
islocal mvimdiff || link $prefix/bin/mvim $prefix/bin/mvimdiff
islocal viman    || link $prefix/bin/mvim $prefix/bin/viman
islocal mviman   || link $prefix/bin/mvim $prefix/bin/mviman
islocal gviman   || link $prefix/bin/mvim $prefix/bin/gviman
islocal vim || diecmd vim

download http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl "$HOME/.vim/spell/de.utf-8.spl"

if ! inhome .vim/autoload/plug.vim; then
	download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim "$HOME/.vim/autoload/plug.vim"
	vim -c PlugInstall -c q
fi
