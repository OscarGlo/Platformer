class_name BufferTimer
extends Timer

var time = 0

func _init():
	one_shot = true

func running():
	return time_left > 0

func with_time(t):
	wait_time = t
	return self
