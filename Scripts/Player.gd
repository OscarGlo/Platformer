class_name Player
extends Entity

const move_speed = 500
var jump_force = gravity * 12
# Timers max value
const coyote_time = 0.05
const jump_buf_time = 0.1
const jump_hold_time = 0.15

var coyote = 0
var jump_buf = 0
var jump_hold = 0

func _ready():
	snap = 8

func update_horizontal_movement():
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1
	
	if direction != 0:
		if is_on_floor():
			speed.x = direction * move_speed
		else:
			# Add speed incrementally so that max speed is move_speed
			speed.x += direction * move_speed * (1 - air_friction)

func update_jump(delta):
	if is_on_floor():
		coyote = coyote_time
	elif coyote > 0:
		coyote -= delta
	
	if Input.is_action_just_pressed("ui_up"):
		jump_buf = jump_buf_time
	if jump_buf > 0:
		jump_buf -= delta
	
	# Jump
	if (jump_buf > 0 and coyote > 0) or (jump_hold > 0 and Input.is_action_pressed("ui_up")):
		speed.y = -jump_force
		# Reset timers
		if coyote > 0:
			jump_buf = 0
			coyote = 0
			# Set hold timer on jump start
			jump_hold = jump_hold_time
	
	if jump_hold > 0:
		jump_hold -= delta

func _physics_process(delta):
	update_horizontal_movement()
	update_jump(delta)
	
	# Wrap position
	var height = get_viewport_rect().size.y
	if position.y > height:
		position.y -= height
