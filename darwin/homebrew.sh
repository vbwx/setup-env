if ! exist brew; then
	download https://raw.githubusercontent.com/Homebrew/install/master/install "$TMPDIR/homebrew.rb"
	rundel /usr/bin/ruby "$TMPDIR/homebrew.rb"
fi
