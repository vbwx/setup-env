platform="$(uname)"
platform="${platform,,}"
dist=""
desktop=""
if [[ $platform == "linux" ]]; then
	if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
		dist="$(lsb_release -i | cut -d: -f2 | sed 's/^\t//')"
	else
		set +f
		dist="$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v lsb | cut -d/ -f3 | cut -d- -f1 | cut -d_ -f1)"
		set -f
	fi
	desktop="$DESKTOP_SESSION"
	mapval desktop
elif [[ $platform == *bsd ]]; then
	dist="$platform"
	platform=bsd
	desktop="$DESKTOP_SESSION"
fi

[[ ${PATH#*$prefix/bin} = "$PATH" ]] && PATH="$prefix/bin:$PATH"
