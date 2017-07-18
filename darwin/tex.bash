if ! exist latex; then
	installapp mactex
	
	function tex_cleanup {
		rm -rf "$prefix/Caskroom/mactex"
	}
fi
