extends Button

export(String, FILE, "*.tscn") var scene_path: String

func _ready():
	connect("pressed", self, "on_press")

func on_press():
	if scene_path:
		get_tree().change_scene(scene_path)
		get_tree().paused = false
		
		GameUtil.game = null
