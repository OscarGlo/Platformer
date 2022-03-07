class_name Entity
extends KinematicBody2D

var gravity = ProjectSettings.get("physics/2d/default_gravity")
const up_dir = Vector2.UP
# Minimum y speed (to ensure is_on_floor() is set each frame)
const epsilon = 1
const air_resistance = 0.92
const air_friction = 0.8
const floor_friction = 0.85

var speed = Vector2.ZERO
var snap = 0

func _physics_process(_delta):
	if is_on_floor():
		speed.x *= floor_friction
		# Reduce speed to minimum
		if speed.y > epsilon:
			speed.y = epsilon
	else:
		speed.y += gravity
		speed *= Vector2(air_friction, air_resistance)
	
	move_and_slide_with_snap(speed, Vector2.DOWN * snap, up_dir)
