guipath="$(launchctl getenv PATH)"
println "GUI PATH = $guipath"

if [ "${guipath#*$prefix/bin}" = "$guipath" ]; then
	guipath="$(IFS=: print "${lpaths[*]}:${texpaths[*]}"):$guipath"
	println "New GUI PATH:"
	println "$guipath"
	sudo launchctl config user path "$guipath"
fi
if [[ $(head -n 1 /etc/paths) != "$prefix/bin" ]]; then
	IFS=$'\n' println "${lpaths[*]}" > "$TMPDIR/paths"
	cat /etc/paths >> "$TMPDIR/paths"
	println "New /etc/paths:"
	cat "$TMPDIR/paths"
	sudo mv -vf "$TMPDIR/paths" /etc
fi
if ! grep -sq texbin /etc/paths /etc/paths.d/*; then
	IFS=$'\n' println "${texpaths[*]}" | sudo tee /etc/paths.d/TeX > /dev/null
	println "New /etc/paths.d/TeX:"
	cat /etc/paths.d/TeX
fi
