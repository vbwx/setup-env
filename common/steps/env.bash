for item in $(list env); do
	println ">>>> ${item^}"
	[[ $verbose ]] && ref=1 run "$item" common
	[[ $simulate ]] || run "$item" common
done
