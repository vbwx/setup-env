if ! exist perlbrew; then
	download https://install.perlbrew.pl "$TMPDIR/perlbrew.sh"
	rundel bash "$TMPDIR/perlbrew.sh"
fi
exist perlbrew || source "$PERLBREW_ROOT/etc/bashrc" || diecmd perlbrew


if ! islocal perl; then
	perlbrew install -n stable || die "Can't install Perl"
	ver="$(perlbrew list | perl -ne '/perl-[\d.]+/; print $&; $& and exit;')"
	[ "$ver" ] || die "Can't find out installed Perl version"
	perlbrew alias create perl-"$ver" default && perlbrew switch default
fi

exist cpan   || diecmd cpan
islocal cpan || die "perlbrew doesn't seem to be active"
