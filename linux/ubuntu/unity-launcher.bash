if inshare unity/5 && ! inshare unity/5/icon54.png; then
	download "https://i.stack.imgur.com/MiFpK.png" /usr/share/unity/5/icon54.png
	download "https://i.stack.imgur.com/0NvP0.png" /usr/share/unity/5/icon62.png

	local name

	for name in squircle_shine squircle_edge squircle_base squircle_base_selected launcher_icon_back launcher_icon_edge launcher_icon_shine; do 
		move ${name}_54.png ${name}_54.png~
		link icon54.png ${name}_54.png
	done

	for name in squircle_shadow launcher_icon_glow launcher_icon_shadow; do 
		move ${name}_62.png ${name}_62.png~
		link icon62.png ${name}_62.png
	done
fi
