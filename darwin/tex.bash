if ! exist latex; then
	installapp mactex
	
	function tex_clean {
		rm -rf "$prefix/Caskroom/mactex"
	}
fi
