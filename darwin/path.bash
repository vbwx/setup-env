guipath="$(launchctl getenv PATH)"
echo "GUI PATH = $guipath"

if [ "${guipath#*$prefix/bin}" = "$guipath" ]; then
	guipath="$(IFS=: printf "${lpaths[*]}:${texpaths[*]}"):$guipath"
	echo "New GUI PATH:"
	echo "$guipath"
	sudo launchctl config user path "$guipath"
fi
if [[ $(head -n 1 /etc/paths) != "$prefix/bin" ]]; then
	IFS=$'\n' printf "${lpaths[*]}\n" > "$TMPDIR/paths"
	cat /etc/paths >> "$TMPDIR/paths"
	echo "New /etc/paths:"
	cat "$TMPDIR/paths"
	sudo mv -vf "$TMPDIR/paths" /etc
fi
if ! grep -sq texbin /etc/paths /etc/paths.d/*; then
	IFS=$'\n' printf "${texpaths[*]}\n" | sudo tee /etc/paths.d/TeX > /dev/null
	echo "New /etc/paths.d/TeX:"
	cat /etc/paths.d/TeX
fi

