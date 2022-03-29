extends LivingEntity

var direction = Vector2.RIGHT
var move_speed = 1000

func _ready():
	snap = 8
	kill_on_collide = true

func _physics_process(delta):
	# Bounce on walls
	if $LeftRay.is_colliding() or $RightRay.is_colliding():
		direction = -direction
	
	if body.is_on_floor():
		# Turn over ledges
		if (direction.x < 0 and not $BottomLeftRay.is_colliding()) or\
			(direction.x > 0 and not $BottomRightRay.is_colliding()):
			direction = -direction
		speed = direction * move_speed
