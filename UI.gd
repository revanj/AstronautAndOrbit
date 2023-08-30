extends CanvasLayer
class_name UI

var crystals_collected = 0
var total_crystals = 0
@onready var crystal_label:Label = $CrystalCollect/Label

func _on_crystal_collected():
	crystals_collected += 1
	update_crystal_label()
	
func update_crystal_label():
	crystal_label.text = str(crystals_collected) + "/" + str(total_crystals)
