extends Node2D

func _ready():
	var tileset = TileSet.new()
	TilesetGen.generate("res://Tiles/green_template_120.png", tileset)
	
	$TileMap.tile_set = tileset
