extends Node2D

func _ready():
	$VBoxContainer/Quit.connect("pressed", self, "on_quit")

func on_quit():
	get_tree().quit(0)
