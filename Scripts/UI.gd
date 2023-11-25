extends CanvasLayer
class_name UI

var crystals_collected = 0
var total_crystals = 0
@onready var crystal_label:Label = $CrystalCollect/Label
@onready var fuel_progress_bar = $FuelMeter/FuelProgress
@onready var facade = $Facade
@onready var pause_menu = $PauseMenu

signal pause_game

func _ready():
	facade.color = Color.BLACK
	facade.show()
	facade_clear_await()
	get_tree().current_scene.scene_file_path

func _on_spaceship_fuel_changed(fuel):
	fuel_progress_bar.value = fuel

func _on_crystal_collected():
	crystals_collected += 1
	update_crystal_label()
	if crystals_collected == total_crystals:
		facade_darken_await()
		print("calling load_next_level")
		GameManager.load_next_level()
	
func update_crystal_label():
	crystal_label.text = str(crystals_collected) + "/" + str(total_crystals)
 
func _on_player_dead_by_star():
	facade_darken_await()
	get_tree().reload_current_scene()

func _on_player_dead_by_out_of_bounds():
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
	
func _input(event): 
	if event.is_action_pressed("pause"):
		pause_menu.visible = !pause_menu.visible
		pause_game.emit(pause_menu.visible)
	
func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_resume_button_pressed():
	pause_menu.hide()
	pause_game.emit(pause_menu.visible)


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/ChapterSelect.tscn")
