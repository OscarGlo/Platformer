class_name Game
extends Node2D

var level_path = "res://Levels/level.json"
var level: Level
var world: _World
var player: Player setget set_player

var mode = GameUtil.PLAY setget set_mode

var time = 0

const PAUSE_SCREEN = preload("res://Scenes/GUI/PauseScreen.tscn")
var pause_menu

const EDIT_MENU = preload("res://Scenes/GUI/EditMenu.tscn")
var edit_menu

func set_player(p):
	player = p
	$Camera.follow = player

func set_mode(m):
	mode = m
	$CanvasLayer/Timer.visible = mode == GameUtil.PLAY
	$CanvasLayer/Hotbar.visible = mode == GameUtil.EDIT
	print(mode)

func _ready():
	# Register instance
	GameUtil.game = self
	
	# Get info from menus
	level_path = LevelInfo.level_path
	set_mode(LevelInfo.mode)
	
	# Initialize menus
	pause_menu = PAUSE_SCREEN.instance()
	pause_menu.get_node("VBoxContainer/Continue").connect("pressed", self, "toggle_pause")
	
	edit_menu = EDIT_MENU.instance()
	edit_menu.get_node("VBoxContainer/Back").connect("pressed", self, "toggle_pause")
	
	$CanvasLayer/PauseButton.connect("pressed", self, "toggle_pause")
	
	# Get level from path
	level = LevelGen.parse_level_file(level_path)
	world = level.worlds[0]
	add_child(world)
	set_player(level.player)
	
	$Camera.init()
	
	# Get textures from file
	# TODO: Move this to global file
	var tileset = TileSet.new()
	TilesetGen.generate("res://Tiles/dirt_a8.png", tileset)
	$World/TileMap.tile_set = tileset
	$World/TileMap.update_bitmask_region()

func toggle_pause():
	if death_screen or win_screen:
		return
	
	get_tree().paused = not get_tree().paused
	var menu = pause_menu if mode == GameUtil.PLAY else edit_menu
	if get_tree().paused:
		$CanvasLayer.add_child(menu)
	else:
		$CanvasLayer.remove_child(menu)

const DEATH_SCREEN = preload("res://Scenes/GUI/DeathScreen.tscn")
var death_screen

func death():
	get_tree().paused = true
	death_screen = DEATH_SCREEN.instance()
	$CanvasLayer.add_child(death_screen)

const WIN_SCREEN = preload("res://Scenes/GUI/WinScreen.tscn")
var win_screen

func win():
	get_tree().paused = true
	win_screen = WIN_SCREEN.instance()
	$CanvasLayer.add_child(win_screen)

func process_play(delta):
	time += delta
	$CanvasLayer/Timer.text = str(int(time/60)).pad_zeros(2) + ":" + str(int(time) % 60).pad_zeros(2)
	
	if world.get_room_at_pos(player.position) == null and world.die_out_of_bounds and not death_screen:
		death()

func process_edit(delta):
	pass

func _process(delta):
	if mode == GameUtil.PLAY:
		process_play(delta)
	else:
		process_edit(delta)
	
	# Handle escape
	if Input.is_action_just_pressed("esc"):
		if death_screen or win_screen:
			get_tree().change_scene("res://Scenes/GUI/LevelMenu.tscn")
			get_tree().paused = false
			GameUtil.game = null
		else:
			toggle_pause()
