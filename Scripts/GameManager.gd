extends Node

var levels = [
	"res://TestLevels/TestOrbitalCorrection.tscn",
	"res://TestLevels/TestSimpleSlingshot.tscn",
	"res://TestLevels/TestMultipleSlingshot.tscn",
	"res://TestLevels/TestThrusterStarShift.tscn",
	"res://TestLevels/TestPulsars.tscn",
	"res://TestLevels/TestWormHole.tscn",
	"res://TestLevels/TestWormHoleRedirection.tscn",
	"res://TestLevels/TestZigZag.tscn",
	"res://TestLevels/TestBlackholeSlingshot.tscn"
]

var ending_level = "res://Scenes/TitleScene.tscn"
var title_scene = "res://Scenes/EndingScene.tscn"

var current_level: int = 0

func find_current_level():
	var scene_path = get_tree().current_scene.scene_file_path
	return scene_path

func load_next_level():
	current_level = levels.find(find_current_level())
	current_level += 1
	if current_level < len(levels):
		get_tree().change_scene_to_file(levels[current_level])
	else:
		get_tree().change_scene_to_file(ending_level)
		
func start_game():
	get_tree().change_scene_to_file(levels[0])
