extends Node

func file_name(path: String, ext: bool = true):
	var name = path.split("/", false, 1)[-1]
	return name if ext else name.rsplit(".", false, 1)[0]
