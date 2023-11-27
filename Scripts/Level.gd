extends Node2D
class_name Level
# This is the node that collects dependencies
# lower level nodes will query this node for scattered dependencies

@onready var crystals = $Crystals.get_children()
@onready var ui:UI = $UI
@onready var stars = get_tree().get_nodes_in_group("stars")
@onready var spaceship:Spaceship = $Spaceship
@onready var death_area = $DeathArea
@onready var death_beams = get_tree().get_nodes_in_group("death_beam")

var paused = false

func _ready():
	# GameManager.find_current_level()
	
	spaceship.fuel_changed.connect(ui._on_spaceship_fuel_changed)
	spaceship.emit_signal("fuel_changed", spaceship.fuel_meter)
	
	ui.total_crystals = len(crystals)
	ui.update_crystal_label()
	for c in crystals:
		c = c as EnergyCrystal
		c.crystal_collected.connect(ui._on_crystal_collected)
	
	for s in stars:
		s.player_dead_by_star.connect(ui._on_player_dead_by_star)
		s.player_dead_by_star.connect(self._on_player_death)
	
	death_area.player_dead_by_out_of_bounds.connect(ui._on_player_dead_by_out_of_bounds)
	death_area.player_dead_by_out_of_bounds.connect(self._on_player_death)
	
	for b in death_beams:
		b.player_dead_by_star.connect(ui._on_player_dead_by_star)
		b.player_dead_by_star.connect(self._on_player_death)


			


func _on_ui_pause_game(visibility: bool):
	var target_pause_state = PROCESS_MODE_DISABLED
	if !visibility:
		target_pause_state = PROCESS_MODE_INHERIT
		
	spaceship.process_mode = target_pause_state
	for s in stars:
		s.process_mode = target_pause_state
	
func _on_player_death():
	spaceship.queue_free()
