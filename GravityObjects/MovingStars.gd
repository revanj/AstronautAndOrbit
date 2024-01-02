@tool
extends GravityObject

@export var rotation_center: Node2D
@export var angular_vel: float
var radius: float

func _ready():
    radius = (rotation_center.global_position - self.global_position).length()

func _physics_process( delta: float, ) -> void:
    if !Engine.is_editor_hint():
        var dir_vector: Vector2 = self.global_position - rotation_center.global_position
        self.global_position = rotation_center.global_position + dir_vector.rotated(angular_vel * delta)
