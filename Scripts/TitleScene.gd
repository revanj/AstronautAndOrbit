extends Control


func _on_start_game_button_pressed():
	GameManager.start_game()



func _on_select_chapter_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/ChapterSelect.tscn")
