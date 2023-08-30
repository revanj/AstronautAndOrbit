extends Node2D

@onready var arrows = self.get_children()
@onready var n_arrows = len(arrows)

var max_length = 50
var min_length = 5

# direction is a normalized vector.
# seperating them so that strength 0 still has a direction
func set_strength_direction(strength: float, direction: Vector2):
	var starting_pos = self.global_position
	var ending_pos = (
		self.global_position 
		+ direction * (lerpf(min_length, max_length, strength)))
	for i in range(n_arrows):
		arrows[i].global_position = starting_pos.lerp(ending_pos, float(i+1)/float(n_arrows))
		arrows[i].rotation = Vector2.UP.angle_to(direction)
		
	
