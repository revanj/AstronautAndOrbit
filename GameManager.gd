extends Node

var levels = [
	"res://TestLevels/TestOrbitalCorrection.tscn",
	"res://TestLevels/TestThrusterStarShift.tscn",
	"res://TestLevels/TestSimpleSlingshot.tscn",
	"res://TestLevels/TestMultipleSlingshot.tscn",
	"res://TestLevels/TestWormHole.tscn",
	"res://TestLevels/TestBlackholeSlingshot.tscn"
]

var ending_level = "res://EndingScene.tscn"
var title_scene = "res://TitleScene.tscn"

var current_level: int = 0

func find_current_level():
	var scene_path = get_tree().current_scene.scene_file_path
	if scene_path != "":
		print("scene path", scene_path)
		current_level = levels.find(scene_path, 0)
		print("found current level", current_level)

func load_next_level():
	current_level += 1
	if current_level < len(levels):
		print("loading level", levels[current_level])
		get_tree().change_scene_to_file(levels[current_level])
	else:
		get_tree().change_scene_to_file(ending_level)
		
func start_game():
	get_tree().change_scene_to_file(levels[0])
