class_name GravityObject
extends Node2D

@export var gravity_factor = 100000


func get_gravity_vector(pos:Vector2):
	var r2 = (global_position - pos).length_squared()
	if r2 < 1000:
		return Vector2(NAN, NAN)
	return (global_position - pos).normalized() / r2 * gravity_factor
	
