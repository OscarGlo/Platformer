extends Node2D

const LEVEL_DIR = "res://Levels/"

func _ready():
	var dir = Directory.new()
	dir.open(LEVEL_DIR)
	dir.list_dir_begin(true)
	
	while true:
		var f = dir.get_next()
		if f == "":
			break
		else:
			var but = LevelButton.new()
			but.text = f
			but.level_path = LEVEL_DIR + f
			$ScrollContainer/VBoxContainer.add_child(but)
