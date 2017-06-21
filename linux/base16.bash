function _install_base16 {
	for s in color-scripts/*-256.sh; do
		echo "${s/color-scripts\//}"
		sed -i -e "s/\"base 16 /\"/i" -e "s/ 256\"/\"/" "$s"
		bash "$s"
	done
}

