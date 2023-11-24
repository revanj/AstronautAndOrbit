extends Panel

@export var level_path: String

func _on_button_pressed():
	get_tree().change_scene_to_file(level_path)
