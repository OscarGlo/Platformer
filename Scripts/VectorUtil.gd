extends Node

func is_in(v: Vector2, pos: Vector2, size: Vector2):
	var end = pos + size
	return v.x >= pos.x and v.y >= pos.y and v.x <= end.x and v.y <= end.y

func min(u: Vector2, v: Vector2):
	return Vector2(min(u.x, v.x), min(u.y, v.y))
	
func max(u: Vector2, v: Vector2):
	return Vector2(max(u.x, v.x), max(u.y, v.y))
