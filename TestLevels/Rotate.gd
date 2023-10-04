extends Node2D

@export var rotation_rate: float = 30
signal player_dead_by_star

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees += rotation_rate * delta


func _on_body_entered(body):
	if body.is_in_group("spaceship"):
		emit_signal("player_dead_by_star")
