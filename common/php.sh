if ! exist composer; then
	download "https://getcomposer.org/installer" "$TMPDIR/composer.php"
	rundel php "$TMPDIR/composer.php" --install-dir=$prefix/bin --filename=composer
fi
