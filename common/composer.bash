# Variables:
#     composer_pkg (array) List of Composer packages to be installed

if ! exist composer; then
	download "https://getcomposer.org/installer" "$TMPDIR/composer.php"
	rundel php --install-dir=$prefix/bin --filename=composer "$TMPDIR/composer.php"
fi
