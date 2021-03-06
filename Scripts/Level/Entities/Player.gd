class_name Player
extends LivingEntity

const move_speed = 2300
var jump_force = gravity * 10

var wall_friction = 0.8

var coyote = BufferTimer.new().with_time(0.05)
var jump_buf = BufferTimer.new().with_time(0.1)
var jump_hold = BufferTimer.new().with_time(0.2)

func _ready():
	snap = 8
	
	connect("collide", self, "on_collide")
	
	# Instantiate timers
	add_child(coyote)
	add_child(jump_buf)
	add_child(jump_hold)

func update_horizontal_movement():
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1
	
	if direction != 0:
		# Add speed incrementally so that max speed is move_speed
		speed.x += direction * move_speed * (1 - (floor_friction if body.is_on_floor() else air_friction))
	
	# Stop against walls
	if body.is_on_wall():
		speed.x = sign(speed.x) * epsilon

func update_jump(_delta):
	# Set timers
	if body.is_on_floor():
		coyote.start()
	
	if body.is_on_ceiling():
		speed.y = 0
		jump_hold.stop()
	
	if jump_hold.running() and not Input.is_action_pressed("ui_up"):
		jump_hold.stop()
	
	if Input.is_action_just_pressed("ui_up"):
		jump_buf.start()
	
	# Wall sliding
	if speed.y > 0 and abs(speed.x) > 0 and body.is_on_wall():
		speed.y *= wall_friction
	
	# Jump
	if (jump_buf.running() and coyote.running()) or (jump_hold.running() and Input.is_action_pressed("ui_up")):
		speed.y = -jump_force
		# Reset timers
		if coyote.running():
			jump_buf.stop()
			coyote.stop()
			# Set hold timer on jump start
			jump_hold.start()
	
	# Wall jump
	if body.is_on_wall() and jump_buf.running():
		speed.x = -sign(speed.x) * move_speed
		speed.y = -jump_force
		
		jump_hold.start()

func _physics_process(delta):
	if GameUtil.game != null and GameUtil.game.mode == GameUtil.PLAY:
		update_horizontal_movement()
		update_jump(delta)

func on_collide(collider):
	if collider is LivingEntity and collider.kill_on_collide:
		GameUtil.game.death()
