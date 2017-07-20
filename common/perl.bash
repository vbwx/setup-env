# Variables:
#     perl_ver (string, default: latest) The Perl version to be installed

local ver

if ! exist perlbrew; then
	download https://install.perlbrew.pl "$TMPDIR/perlbrew.sh"
	rundel bash "$TMPDIR/perlbrew.sh"
fi
exist perlbrew || source "$PERLBREW_ROOT/etc/bashrc"

if ! islocal perl; then
	ver="$(myvar ver latest)"
	[[ $ver == "latest" ]] && ver="$(perlbrew list | perl -ne \
		'/perl-([\d.]+)/ and print "$1"; $& and exit;')"
	perlbrew install -n stable
	perlbrew alias create perl-"$ver" default && perlbrew switch default
fi

islocal cpan || rerun
