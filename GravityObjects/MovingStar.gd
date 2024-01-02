@tool
extends GravityObject
class_name MovingStar

@export var rotation_center: Node2D
@export var angular_vel: float
var radius: float
var starting_dir: Vector2

func _ready():
	radius = (rotation_center.global_position - self.global_position).length()
	starting_dir = self.global_position - rotation_center.global_position

func _physics_process( delta: float, ) -> void:
	if !Engine.is_editor_hint():
		var dir_vector: Vector2 = self.global_position - rotation_center.global_position
		self.global_position = rotation_center.global_position + dir_vector.rotated(angular_vel * delta)


func get_gravity_vector(pos:Vector2, time: float) -> Vector2:
	var timed_global_position: Vector2 = starting_dir.rotated(angular_vel * time) + rotation_center.global_position
	var r = (timed_global_position - pos).length()
	if r > effect_radius:
		return Vector2.ZERO
	if r < $CollisionShape2D.shape.radius:
		return Vector2(NAN, NAN)
	var r2 = (timed_global_position - pos).length_squared()
	return (timed_global_position - pos).normalized() / r2 * gravity_factor
