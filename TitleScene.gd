extends Control

func _input(event):
	if event is InputEventMouseButton || event is InputEventKey:
		GameManager.start_game()
