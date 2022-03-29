class_name Exit
extends Entity

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node2D):
	if body is Player:
		GameUtil.game.win()
