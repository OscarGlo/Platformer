class_name _World
extends Node2D

const TILEMAP_SCALE = 0.9375

var level: Level
var die_out_of_bounds = true

func set_block(pos: Vector2, type: int):
	$TileMap.set_cellv(pos, type)

func add_room(room: ReferenceRect):
	$Rooms.add_child(room)

func add_entity(entity: Entity):
	$Entities.add_child(entity)
	
	if entity is Player:
		level.player = entity

func get_room_at_pos(pos) -> ReferenceRect:
	for r in $Rooms.get_children():
		if VectorUtil.is_in(pos, r.rect_position, r.rect_size):
			return r
	return null

func _ready():
	$TileMap.scale = TILEMAP_SCALE * Vector2.ONE
