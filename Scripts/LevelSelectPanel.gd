@tool
extends Panel

@export var level_path: String
@export var level_thumbnail: Texture:
	set(value):
		level_thumbnail = value
		$MarginContainer/TextureRect.texture = value

@export var disabled: bool:
	set(value):
		disabled = value
		$Button.disabled = value
		if value:
			$Label.text = "Coming Soon"
			$MarginContainer/TextureRect.texture = placeholder_texture
			
@export var placeholder_texture: Texture

@export var level_description: String:
	set(value):
		level_description = value
		$Label.text = value

func _on_button_pressed():
	get_tree().change_scene_to_file(level_path)
