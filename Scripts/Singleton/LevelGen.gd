extends Node

func parse_level_file(path: String) -> Level:
	var p = FileUtil.read_as_json(FileUtil.open(path, File.READ))
	assert(not p.error and typeof(p.result) == TYPE_DICTIONARY, "JSON file should contain a dictionary")
	return parse_level(p.result)


func parse_level(d: Dictionary) -> Level:
	var level = Level.new()
	level.name = d["name"]
	for world in d["worlds"]:
		level.worlds.append(parse_world(world, level))
	return level


const WORLD_SCENE = preload("res://Scenes/World.tscn")

func parse_world(d: Dictionary, level: Level) -> _World:
	var world = WORLD_SCENE.instance()
	world.level = level
	
	for room in d["rooms"]:
		world.add_room(parse_room(room, world))
	
	return world


enum { GROUND }
const TILE_CHARS = {
	"a": GROUND
}
const ROOM_SCENE = preload("res://Scenes/Room.tscn")

const DIR_MAP = { "u": "up", "d": "down", "l": "left", "r": "right" }

func parse_room(d: Dictionary, world: _World) -> _Room:
	var room = ROOM_SCENE.instance()
	room.world = world
	room.room_offset = VectorUtil.from_arr(d["pos"])
	room.scale = d["scale"]
	room.room_size = VectorUtil.from_arr(d["size"])
	
	if "wrap" in d:
		if d["wrap"] == "vertical" or d["wrap"] == "both":
			room.v_wrap = true
		if d["wrap"] == "horizontal" or d["wrap"] == "both":
			room.h_wrap = true
	
	if "blocked" in d:
		for c in d["blocked"]:
			room.blocked[DIR_MAP[c]] = true
	
	var offset = VectorUtil.pos_to_tile(room.rect_position)
	for y in len(d["blocks"]):
		var row = d["blocks"][y]
		for x in len(row):
			var c = row[x]
			if c in TILE_CHARS:
				world.set_block(Vector2(x, y) + offset, TILE_CHARS[c])
	
	for entity in d["entities"]:
		var node = parse_entity(entity)
		node.position += room.rect_position
		world.add_entity(node)
	
	return room


const ENTITY_SCENES = {
	"player": preload("res://Scenes/Entities/Player.tscn"),
	"exit": preload("res://Scenes/Entities/Exit.tscn")
}

func parse_entity(d: Dictionary):
	var entity: Entity = ENTITY_SCENES[d["type"]].instance()
	entity.position = VectorUtil.tile_to_pos(VectorUtil.from_arr(d["pos"]))
	return entity
