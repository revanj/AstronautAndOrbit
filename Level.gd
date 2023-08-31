extends Node2D
class_name Level
# This is the node that collects dependencies
# lower level nodes will query this node for scattered dependencies

@onready var crystals = $Crystals.get_children()
@onready var ui:UI = $UI
@onready var star_field = $StarFields

func _ready():
	ui.total_crystals = len(crystals)
	ui.update_crystal_label()
	
	for c in crystals:
		c = c as EnergyCrystal
		c.crystal_collected.connect(ui._on_crystal_collected)
	
	for s in get_tree().get_nodes_in_group("stars"):
		s.player_dead_by_star.connect(ui._on_player_dead_by_star)
