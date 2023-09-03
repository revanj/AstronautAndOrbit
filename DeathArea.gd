extends Area2D

signal player_dead_by_out_of_bounds




func _on_body_entered(body):
	if body.is_in_group("spaceship"):
		emit_signal("player_dead_by_out_of_bounds")
