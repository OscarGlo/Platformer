extends Node

onready var re_extension = StringUtil.regex("(?<=\\.)[a-z0-9]+$")

func file_name(path: String, ext: bool = true):
	var name = path.split("/", false, 1)[-1]
	return name if ext else name.rsplit(".", false, 1)[0]

func replace_extension(path: String, ext: String):
	return re_extension.sub(path, ext)

func read_as_json(f: File):
	return JSON.parse(f.get_as_text())

func open(path: String, mode: int):
	var f = File.new()
	f.open(path, mode)
	return f
