class_name LivingEntity
extends Entity

var gravity = ProjectSettings.get("physics/2d/default_gravity")
const up_dir = Vector2.UP
# Minimum y speed (to ensure is_on_floor() is set each frame)
const epsilon = 1
const air_resistance = 0.92
const air_friction = 0.9
const floor_friction = 0.7

onready var body = self # KinematicBody

var speed = Vector2.ZERO
var snap = 0

func _ready():
	assert(body is KinematicBody2D, "Living entities should be KinematicBodies")

func wrap_position(room: ReferenceRect):
	if room:
		var pos = room.rect_position
		var size = room.rect_size
		
		if room.h_wrap:
			if position.x < pos.x:
				position.x += size.x
			elif position.x > pos.x + size.x:
				position.x -= size.x
		
		if room.v_wrap:
			if position.y < pos.y:
				position.y += size.y
			elif position.y > pos.y + size.y:
				position.y -= size.y

func _physics_process(_delta):
	if GameUtil.game == null or GameUtil.game.mode == GameUtil.EDIT:
		return
	
	if body.is_on_floor():
		speed.x *= floor_friction
		# Reduce speed to minimum
		if speed.y > epsilon:
			speed.y = epsilon
	else:
		speed.y += gravity
		speed *= Vector2(air_friction, air_resistance)
	
	# Get current room before move
	var room = GameUtil.game.world.get_room_at_pos(position)
	body.move_and_slide_with_snap(speed, Vector2.DOWN * snap, up_dir)
	wrap_position(room)
