extends Sprite2D

func set_heading(dir:Vector2):
	if (dir == Vector2.ZERO):
		pass
	else:
		global_rotation = dir.angle()
