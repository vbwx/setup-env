# Map [Shift]+[Backspace] to [Delete]
for file in pc inet us macintosh_vndr/apple macintosh_vndr/us; do
	modify "s/backspace,[[:space:]]*backspace/BackSpace, Delete/ig" /usr/share/X11/xkb/symbols/$file
done

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+mac'), ('xkb', 'de')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch', 'ctrl:swap_lwin_lctl', 'ctrl:swap_rwin_rctl', 'terminate:ctrl_alt_bksp']"

#}}}

