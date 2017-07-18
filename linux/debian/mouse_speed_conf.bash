local ids
xinput --list --short
print "IDs of your pointing devices (space-separated): "
read ids
assign ids "$ids"
