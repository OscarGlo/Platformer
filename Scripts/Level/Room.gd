tool
class_name _Room
extends ReferenceRect

# TODO: Move to global settings script?
var window_size = Vector2(
	ProjectSettings.get("display/window/size/width"),
	ProjectSettings.get("display/window/size/height")
)

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
}

var world: _World
var entities = []

func set_room_size(s):
	room_size = s
	update_rect_size()

func set_scale(s):
	scale = s
	update_rect_size()

func update_rect_size():
	rect_size = window_size * room_size * scale
	$Walls.scale = Vector2.ONE * scale

func set_room_offset(o):
	room_offset = o
	
	# Update rect position
	rect_position = window_size * room_offset
	update_walls()

func update_walls():
	for side in blocked:
		get_node("Walls/" + side).disabled = not blocked[side]

# Init setters on start
func _ready():
	update_rect_size()
	set_room_offset(room_offset)
	update_walls()

