@tool
class_name GravityObject
extends Area2D


@export var gravity_factor = 100000
@export var texture: Texture2D:
	set(value):
		texture = value
		var sprite = get_node_or_null("Sprite2D")
		if sprite != null:
			sprite.texture = value

@export var effect_radius: float = 100 :
	set(value):
		effect_radius = value
		queue_redraw()

@onready var death_radius = $CollisionShape2D.shape.radius

signal player_dead_by_star

func get_gravity_vector(pos:Vector2):
	var r = (global_position - pos).length()
	if r > effect_radius:
		return Vector2.ZERO
	if r < death_radius:
		return Vector2(NAN, NAN)
	var r2 = (global_position - pos).length_squared()
	return (global_position - pos).normalized() / r2 * gravity_factor
	
func _draw():
	if Engine.is_editor_hint():
		draw_circle_arc(Vector2.ZERO, effect_radius, Color.AQUA)

func draw_circle_arc(center, radius, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(i * (360.0) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)


func _on_body_entered(body):
	if body.is_in_group("spaceship"):
		emit_signal("player_dead_by_star")
