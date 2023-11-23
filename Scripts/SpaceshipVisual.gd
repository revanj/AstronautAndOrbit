extends Node2D

func set_heading(dir:Vector2):
	if (dir == Vector2.ZERO):
		pass
	else:
		global_rotation = Vector2.UP.angle_to(dir)
