extends CanvasLayer
class_name UI

var crystals_collected = 0
var total_crystals = 0
@onready var crystal_label:Label = $CrystalCollect/Label
@onready var fuel_progress_bar = $FuelMeter/FuelProgress
@onready var big_jump_fuel_progress = $FuelMeter/BigJumpProgress
@onready var facade = $Facade

func _ready():
	facade.color = Color.BLACK
	facade.show()
	facade_clear_await()
	get_tree().current_scene.scene_file_path

func _on_spaceship_fuel_changed(fuel):
	fuel_progress_bar.value = fuel

func _on_spaceship_big_jump_fuel_changed(fuel):
	big_jump_fuel_progress.value = fuel

func _on_crystal_collected():
	crystals_collected += 1
	update_crystal_label()
	if crystals_collected == total_crystals:
		facade_darken_await()
		GameManager.load_next_level()
	
func update_crystal_label():
	crystal_label.text = str(crystals_collected) + "/" + str(total_crystals)
 
func _on_player_dead_by_star():
	facade_darken_await()
	get_tree().reload_current_scene()


func facade_clear_await():
	var tween = get_tree().create_tween()
	tween.tween_property(facade, "color", Color(0,0,0,0), 1)
	await tween.finished
	facade.hide()
	
func facade_darken_await():
	var tween = get_tree().create_tween()
	facade.show()
	tween.tween_property(facade, "color", Color.BLACK, 1)
	await tween.finished
	
