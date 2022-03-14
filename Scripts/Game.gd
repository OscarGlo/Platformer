extends Node2D

var level_path = "res://Levels/level.json"
var level: Level
var world: _World
var player: Player setget set_player

var time = 0

func set_player(p):
	player = p
	$Camera.follow = player

func _ready():
	if LevelInfo.level_path:
		level_path = LevelInfo.level_path
	
	$CanvasLayer/PauseButton.connect("pressed", self, "toggle_pause")
	
	level = LevelGen.parse_level_file(level_path)
	set_player(level.player)
	world = level.worlds[0]
	add_child(world)
	RoomUtil.rooms = $World/Rooms.get_children()
	
	if level.exit:
		level.exit.connect("level_end", self, "on_level_end")
	
	var tileset = TileSet.new()
	TilesetGen.generate("res://Tiles/dirt_a8.png", tileset)
	$World/TileMap.tile_set = tileset
	$World/TileMap.update_bitmask_region()

const PAUSE_SCREEN = preload("res://Scenes/GUI/PauseScreen.tscn")
var pause_menu

func toggle_pause():
	if death_screen or win_screen:
		return
	
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		# TODO: Initialize pause menu in ready
		if not pause_menu:
			pause_menu = PAUSE_SCREEN.instance()
			# Connect continue button
			pause_menu.get_node("VBoxContainer/Continue").connect("pressed", self, "toggle_pause")
		$CanvasLayer.add_child(pause_menu)
	else:
		$CanvasLayer.remove_child(pause_menu)

const DEATH_SCREEN = preload("res://Scenes/GUI/DeathScreen.tscn")
var death_screen

func death():
	get_tree().paused = true
	death_screen = DEATH_SCREEN.instance()
	$CanvasLayer.add_child(death_screen)

const WIN_SCREEN = preload("res://Scenes/GUI/WinScreen.tscn")
var win_screen

func on_level_end():
	get_tree().paused = true
	win_screen = WIN_SCREEN.instance()
	$CanvasLayer.add_child(win_screen)

func _process(delta):
	time += delta
	$CanvasLayer/Label.text = str(int(time/60)).pad_zeros(2) + ":" + str(int(time) % 60).pad_zeros(2)
	
	if RoomUtil.get_room_at_pos(player.position) == null and world.die_out_of_bounds and not death_screen:
		death()
	
	if Input.is_action_just_pressed("ui_esc"):
		if death_screen or win_screen:
			get_tree().change_scene("res://Scenes/GUI/LevelMenu.tscn")
			get_tree().paused = false
		else:
			toggle_pause()
