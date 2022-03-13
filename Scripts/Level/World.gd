class_name _World
extends Node2D

var level: Level
var die_out_of_bounds = true

func set_block(pos: Vector2, type: int):
	$TileMap.set_cellv(pos, type)

func add_room(room: ReferenceRect):
	$Rooms.add_child(room)

func add_entity(entity: Entity):
	print(entity)
	$Entities.add_child(entity)
	
	if entity is Player:
		level.player = entity
	if entity is Exit:
		level.exit = entity
