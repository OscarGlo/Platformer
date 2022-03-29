extends LivingEntity

var move_speed = 1000

func _ready():
	kill_on_collide = true
	gravity = 0
	speed = Vector2.ONE * move_speed
	# Remove friction
	air_friction = 1
	air_resistance = 1
	floor_friction = 1

func _physics_process(_delta):
	if $Up.is_colliding() or $Down.is_colliding():
		speed.y = -speed.y
		
	if $Left.is_colliding() or $Right.is_colliding():
		speed.x = -speed.x
