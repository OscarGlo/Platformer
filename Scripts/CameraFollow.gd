extends Camera2D

export var rooms_path: NodePath
onready var rooms: Node2D = get_node(rooms_path)

export var follow_path: NodePath
onready var follow: Node2D = get_node(follow_path)

var start_offset = null
var end_offset = null

func _process(_delta):
	position = follow.position
	
	var room = get_room_at_pos(position)
	if room:
		var size = get_viewport().size / 2
		start_offset = (position - size) - room.rect_position
		end_offset = room.rect_position + room.rect_size - (position + size)
		
		start_offset = VectorUtil.min(start_offset, Vector2.ZERO)
		end_offset = VectorUtil.min(end_offset, Vector2.ZERO)
		
		position += end_offset - start_offset
	else:
		start_offset = null
		end_offset = null
	
	update()

func _draw():
	var c = get_camera_screen_center()
	if start_offset:
		draw_line(-c, -c - start_offset, Color(255, 0, 0), 1)
	if end_offset:
		draw_line(c, c + end_offset, Color(0, 255, 0), 1)

func get_room_at_pos(pos) -> _Room:
	for r in rooms.get_children():
		if VectorUtil.is_in(pos, r.rect_position, r.rect_size):
			return r
	return null
