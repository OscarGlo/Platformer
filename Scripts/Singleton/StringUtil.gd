extends Node

func regex(s: String) -> RegEx:
	var re = RegEx.new()
	re.compile(s)
	return re

func re_split(s: String, re: String, all = true, temp_char = "¤") -> PoolStringArray:
	return regex(re).sub(s, temp_char, all).split(temp_char)
