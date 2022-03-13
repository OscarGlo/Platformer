tool
class_name _Room
extends ReferenceRect

export var scale = 1 setget set_scale
export var room_size = Vector2.ONE setget set_room_size
export var room_offset = Vector2.ZERO setget set_room_offset

export var v_wrap = false
export var h_wrap = false

var blocked = {
	"up": false,
	"down": false,
	"left": false,
	"right": false
} setget set_blocked

var world: _World
var entities = []

func set_room_size(s):
	room_size = s
	update_rect_size()
	update_walls()

func set_scale(s):
	scale = s
	update_rect_size()
	update_walls()

func update_rect_size():
	if is_inside_tree():
		rect_size = get_viewport_rect().size * room_size * scale

func set_room_offset(o):
	room_offset = o
	
	# Update rect position
	if is_inside_tree():
		rect_position = get_viewport_rect().size * room_offset
		update_walls()

# Wall stuff
const SIDE_VECS = {
	"up": [Vector2.ZERO, Vector2.RIGHT],
	"down": [Vector2.DOWN, Vector2.ONE],
	"left": [Vector2.ZERO, Vector2.DOWN],
	"right": [Vector2.RIGHT, Vector2.ONE]
}

func update_walls():
	for side in ["up", "down", "left", "right"]:
		var wall = get_node("Walls/" + side)
		var seg: SegmentShape2D = wall.shape
		var vecs = SIDE_VECS[side]
		seg.a = vecs[0] * rect_size + rect_position
		seg.b = vecs[1] * rect_size + rect_position

func set_blocked(b):
	for side in ["up", "down", "left", "right"]:
		get_node("Walls/" + side).disabled = not blocked[side]
	blocked = b

# Init setters on start
func _ready():
	update_rect_size()
	set_room_offset(room_offset)
	set_blocked(blocked)

