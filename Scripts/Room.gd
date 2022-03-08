tool
class_name _Room
extends ReferenceRect

export var room_size = Vector2.ONE setget set_room_size
export var room_offset = Vector2.ZERO setget set_room_offset

func set_room_size(s):
	room_size = s
	
	# Update rect size
	rect_size = get_viewport_rect().size * room_size

func set_room_offset(o):
	var prev = room_offset
	room_offset = o
	
	# Update rect position
	rect_position = get_viewport_rect().size * room_offset

# Update position on start
func _ready():
	set_room_size(room_size)
	set_room_offset(room_offset)
