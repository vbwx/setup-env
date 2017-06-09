guipath="$(launchctl getenv PATH)"
echo "GUI PATH = $guipath"

if [ "${guipath#*$prefix/bin}" = "$guipath" ]; then
	echo "New GUI PATH:"
	guipath="$(IFS=: ; printf "${lpaths[*]}:${texpaths[*]}"):$guipath"
	echo "$guipath"
	sudo launchctl config user path "$guipath"
fi
if [[ $(head -n 1 /etc/paths) != "$prefix/bin" ]]; then
	(IFS=$'\n'; printf "${lpaths[*]}\n" > "$TMPDIR/paths")
	cat /etc/paths >> "$TMPDIR/paths"
	echo "New /etc/paths:"
	cat "$TMPDIR/paths"
	sudo mv -v -f "$TMPDIR/paths" /etc || exit 1
fi
if ! grep -sq texbin /etc/paths /etc/paths.d/*; then
	echo "$(IFS=$'\n'; printf "${texpaths[*]}")\n" | sudo tee /etc/paths.d/TeX > /dev/null
fi
