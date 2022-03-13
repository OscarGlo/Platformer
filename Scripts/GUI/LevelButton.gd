class_name LevelButton
extends Button

var level_path: String

func _ready():
	connect("pressed", self, "on_press")

func on_press():
	if level_path:
		LevelInfo.level_path = level_path
	get_tree().change_scene("res://Scenes/Game.tscn")
	get_tree().paused = false
