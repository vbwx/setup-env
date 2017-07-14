if ! exist google-chrome; then
	download https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	rundel dpkg -i
fi
