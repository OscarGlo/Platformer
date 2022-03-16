extends Node2D

func _ready():
	$VBoxContainer/Play.connect("pressed", self, "set_mode", [GameUtil.PLAY])
	$VBoxContainer/Edit.connect("pressed", self, "set_mode", [GameUtil.EDIT])
	$VBoxContainer/Quit.connect("pressed", self, "on_quit")

func set_mode(m):
	LevelInfo.mode = m

func on_quit():
	get_tree().quit(0)
