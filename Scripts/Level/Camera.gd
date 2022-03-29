extends Camera2D

var follow: Node2D

export var follow_out_of_bounds = false
export var move_speed = 3000
export var zoom_strength = 0.95

func init():
	follow_constrained(Vector2.ZERO)

func _process(delta):
	if GameUtil.game == null:
		return
	
	if GameUtil.game.mode == GameUtil.PLAY:
		if follow:
			follow_constrained(follow.position)
	else:
		move_camera(delta)

func follow_constrained(pos):
	var room = GameUtil.game.world.get_room_at_pos(pos)
	
	# Follow node
	if room or follow_out_of_bounds:
		position = pos
	
	# Constrain camera to room size
	if room:
		zoom = Vector2.ONE * room.scale
		
		var size = room.scale * room.window_size / 2
		var start_offset = (position - size) - room.rect_position
		var end_offset = room.rect_position + room.rect_size - (position + size)
		
		start_offset = VectorUtil.min(start_offset, Vector2.ZERO)
		end_offset = VectorUtil.min(end_offset, Vector2.ZERO)
		
		position += end_offset - start_offset

var mouse_drag_offset: Vector2

func move_camera(delta):
	# Direction keys moving
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
	
	position += direction * move_speed * delta
	
	# TODO: Smooth zoom?
	if Input.is_action_just_released("zoom_in"):
		zoom *= zoom_strength
	elif Input.is_action_just_released("zoom_out"):
		zoom /= zoom_strength
	
	# Mouse dragging
	if Input.is_action_just_pressed("middle_click"):
		mouse_drag_offset = get_viewport().get_mouse_position()
	elif Input.is_action_pressed("middle_click"):
		var new_offset = get_viewport().get_mouse_position()
		position += mouse_drag_offset - new_offset
		mouse_drag_offset = new_offset
