extends Node

var type_regex = RegEx.new()

func _ready():
	type_regex.compile("(a?r?)([0-9]+)")

func get_info(path: String):
	var name = FileUtil.file_name(path, false)
	var type_size = name.rsplit("_", true, 1)[-1]
	var res = type_regex.search(type_size)
	
	assert(res != null, "Wrong file name format (should end with _a?r?[0-9]+)")
	
	var type = res.get_string(1)
	
	return ["a" in type, "r" in type, int(res.get_string(2))]

func generate(path: String, tileset: TileSet):
	var info = get_info(path)
	var auto = info[0]
	var random = info[1]
	var size = info[2]
	
	var n = len(tileset.get_tiles_ids())
	tileset.create_tile(n)
	var tex: Texture = load(path)
	tileset.tile_set_texture(n, tex)
	tileset.tile_set_region(n, Rect2(Vector2.ZERO, tex.get_size()))
	tileset.autotile_set_size(n, Vector2.ONE * size)
	
	var mode = TileSet.AUTO_TILE
	if auto:
		if random:
			# Random autotile
			pass
		else:
			# Simple autotile
			pass
	else:
		if random:
			# Atlas tile
			mode = TileSet.ATLAS_TILE
		else:
			# Single tile
			mode = TileSet.SINGLE_TILE
	
	tileset.tile_set_tile_mode(n, mode)
	
	# Set all tiles' collision shape to a square
	var coll_shape = RectangleShape2D.new()
	coll_shape.extents = Vector2.ONE * size / 2
	for i in range(tex.get_size().x * tex.get_size().y / size):
		tileset.tile_set_shape(n, i, coll_shape)
		tileset.tile_set_shape_offset(n, i, coll_shape.extents)
	
	return tileset
