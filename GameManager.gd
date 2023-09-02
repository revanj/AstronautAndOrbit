extends Node

var levels = [
	"res://Levels/Level1/Level1Test.tscn",
	"res://Levels/Level2/Level2Test.tscn"
]

var ending_level = "res://EndingScene.tscn"
var title_scene = ""

var current_level: int = 0

func find_current_level():
	var scene_path = get_tree().current_scene.scene_file_path
	if scene_path != "":
		current_level = levels.find(scene_path, current_level)

func load_next_level():
	current_level += 1
	if current_level < len(levels):
		get_tree().change_scene_to_file(levels[current_level])
	else:
		get_tree().change_scene_to_file(ending_level)
