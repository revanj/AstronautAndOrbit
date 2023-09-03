extends Node2D
class_name Level
# This is the node that collects dependencies
# lower level nodes will query this node for scattered dependencies

@onready var crystals = $Crystals.get_children()
@onready var ui:UI = $UI
@onready var stars = $Stars.get_children()
@onready var spaceship:Spaceship = $Spaceship
@onready var death_area = $DeathArea

func _ready():
	# GameManager.find_current_level()
	
	spaceship.fuel_changed.connect(ui._on_spaceship_fuel_changed)
	spaceship.big_jump_fuel_changed.connect(ui._on_spaceship_big_jump_fuel_changed)
	
	spaceship.emit_signal("big_jump_fuel_changed", spaceship.big_jump_fuel)
	spaceship.emit_signal("fuel_changed", spaceship.fuel_meter)
	
	ui.total_crystals = len(crystals)
	ui.update_crystal_label()
	for c in crystals:
		c = c as EnergyCrystal
		c.crystal_collected.connect(ui._on_crystal_collected)
	
	for s in stars:
		s.player_dead_by_star.connect(ui._on_player_dead_by_star)
	
	death_area.player_dead_by_out_of_bounds.connect(ui._on_player_dead_by_out_of_bounds)
