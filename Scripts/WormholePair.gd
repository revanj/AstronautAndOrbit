extends Node2D

@onready var area2d2 = $Wormhole2/Area2D2
@onready var area2d = $Wormhole/Area2D
@onready var warp_player = $AudioStreamPlayer

var can_teleport_area2d = true
var can_teleport_area2d_2 = true

func _on_area_2d_body_entered(body):
	if can_teleport_area2d:
		var delta_pos = area2d.global_position - body.global_position
		body.global_position = area2d2.global_position - delta_pos
		can_teleport_area2d_2 = false
		warp_player.play()
	
	
func _on_area_2d_2_body_entered(body):
	if can_teleport_area2d_2:
		var delta_pos = area2d2.global_position - body.global_position
		body.global_position = area2d.global_position - delta_pos
		can_teleport_area2d = false
		warp_player.play()


func _on_area_2d_2_body_exited(body):
	can_teleport_area2d_2 = true



func _on_area_2d_body_exited(body):
	can_teleport_area2d = true
