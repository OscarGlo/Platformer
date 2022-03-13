extends Node

const TILE_SIZE = 128

var coll_shape: Shape2D = RectangleShape2D.new()
var shape_tf: Transform2D = Transform2D(0, Vector2.ONE * TILE_SIZE / 2)

func _ready():
	coll_shape.extents = Vector2.ONE * TILE_SIZE / 2

func get_info(path: String) -> Array:
	var name = FileUtil.file_name(path, false)
	var info = name.rsplit("_", true, 1)[-1]
	return [int(info.lstrip("a")), info[0] == "a"]

func bitmask_from_custom(s: String) -> int:
	var n = 1
	var sum = 0
	for c in s:
		# *** M a g i c ***
		sum += n * [0, 2, 3, 6, 7, 65_538, 262_146, 327_682][int(c)]
		n *= 8
	return sum

func generate(path: String, tileset: TileSet):
	var data = get_info(path)
	var size = Vector2.ONE * data[0]
	var auto = data[1]
	
	# Load image and resize to tile size 128
	var img: Image = load(path)
	var orig_size = img.get_size()
	var new_size = TILE_SIZE * orig_size / size
	img.resize(new_size.x, new_size.y, Image.INTERPOLATE_NEAREST)
	
	# Load to a texture without filter
	var tex: ImageTexture = ImageTexture.new()
	tex.create_from_image(img)
	tex.flags = ImageTexture.FLAG_MIPMAPS
	
	# Common tile creation data
	var n = len(tileset.get_tiles_ids())
	tileset.create_tile(n)
	tileset.tile_set_texture(n, tex)
	var region = tex.get_size()
	tileset.tile_set_region(n, Rect2(Vector2.ZERO, region))
	tileset.autotile_set_size(n, Vector2.ONE * TILE_SIZE)
	tileset.autotile_set_bitmask_mode(n, TileSet.BITMASK_3X3_MINIMAL)
	
	# Get description file if it exists
	var f = File.new()
	var data_path = FileUtil.replace_extension(path, "txt")
	if f.file_exists(data_path):
		f.open(data_path, File.READ)
	else:
		assert(not auto, "Auto tiles should have a description file")
		f = null
	
	var coll_shapes = []
	var mode = TileSet.AUTO_TILE
	
	# Single tile
	if orig_size == size:
		mode = TileSet.SINGLE_TILE
	# Auto/Atlas with description file
	elif f:
		var pos = Vector2.ZERO
		while not f.eof_reached():
			var tiles = StringUtil.re_split(f.get_line(), "\\s+")
			pos.x = 0
			for t in tiles:
				var tile_data = t.split(",")
				# Mask (all wildcard if atlas)
				tileset.autotile_set_bitmask(n, pos, bitmask_from_custom(tile_data[0]) if auto else 33_488_896)
				
				# Weight
				if len(tile_data) > 1 or not auto:
					tileset.autotile_set_subtile_priority(n, pos, int(tile_data[1 if auto else 0]))
				
				coll_shapes.append({"autotile_coord": pos, "shape": coll_shape, "shape_transform": shape_tf})
				pos.x += 1
			pos.y += 1
	else:
		for x in range(region.x / TILE_SIZE):
			for y in range(region.y / TILE_SIZE):
				# All wildcard bitmask
				tileset.autotile_set_bitmask(n, Vector2(x, y), 33_488_896)
				coll_shapes.append({"autotile_coord": Vector2(x, y), "shape": coll_shape, "shape_transform": shape_tf})
	
	tileset.tile_set_tile_mode(n, mode)
	tileset.tile_set_shapes(n, coll_shapes)
	
	return tileset
