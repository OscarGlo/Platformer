extends Node

var rooms = null

func get_room_at_pos(pos) -> _Room:
	if not rooms:
		return null
	for r in rooms:
		if VectorUtil.is_in(pos, r.rect_position, r.rect_size):
			return r
	return null
