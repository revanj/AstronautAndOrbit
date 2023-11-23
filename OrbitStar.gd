@tool
extends GravityObject
class_name OrbitStar

@export var orbit_center: Node2D 
@export var orbit_rate: float
@onready var parent = self.get_parent()
@onready var radius = self.position.length()

func _physics_process(delta):
	if !Engine.is_editor_hint():
		print("update star position")
		var current_angle = position.angle()
		var new_position = Vector2.from_angle(current_angle + deg_to_rad(orbit_rate) * delta)
		position = new_position * radius
