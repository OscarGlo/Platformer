extends Node

func from_arr(arr: Array) -> Vector2:
	assert(len(arr) == 2 and arr[0] is float and arr[1] is float, "array should contain exactly 2 float values")
	return Vector2(arr[0], arr[1])

func tile_to_pos(tile: Vector2, center = true) -> Vector2:
	var offset = (Vector2.ONE / 2) if center else Vector2.ZERO
	return (tile + offset) * TilesetGen.TILE_SIZE * _World.TILEMAP_SCALE

func is_in(v: Vector2, pos: Vector2, size: Vector2) -> bool:
	var end = pos + size
	return v.x >= pos.x and v.y >= pos.y and v.x <= end.x and v.y <= end.y

func min(u: Vector2, v: Vector2) -> Vector2:
	return Vector2(min(u.x, v.x), min(u.y, v.y))
	
func max(u: Vector2, v: Vector2) -> Vector2:
	return Vector2(max(u.x, v.x), max(u.y, v.y))
