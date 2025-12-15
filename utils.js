function shorten(string, limit) {
	if(string.length > limit) {
		if (limit>5){
			return string.substring(0,Math.floor((limit-5)/2))+" ... "+string.substring(string.length-Math.floor((limit-5)/2))
		} else return string.substring(0, limit)
	} else return string
}
