@tool
extends Node2D
class_name NavDisplay
# this class will collect all children of GravityObject
# and give gravity strength at certain point
# unfortunately it might be necessary to generate this per query
# or at least update everytime something moves

var stars
var spaceship: Spaceship
@export var arrow_texture: Texture2D


var previous_pos: Vector2 = Vector2.ZERO
var previous_speed: int   = 0

var half_texture_width: float

class TrajectoryData:
	var points_arc
	var arrow_pos
	var arrow_dir

var trajectory_data: TrajectoryData

func _ready():
	set_as_top_level(true)
	global_position = Vector2.ZERO
	global_rotation = 0
	scale = Vector2.ONE
	stars = get_tree().get_nodes_in_group("gravity_objects")
	half_texture_width = arrow_texture.get_width() / 2.0
	
func get_field_at(pos: Vector2) -> Vector2:
	var result: Vector2 = Vector2.ZERO
	for star: GravityObject in stars:
		result += star.get_gravity_vector(pos)
	return result
	
func _physics_process(_delta):
	if !Engine.is_editor_hint():
		spaceship.field_dir = get_field_at(spaceship.global_position)
	else: # this runs in editor
		var spaceship_editor: Spaceship = get_parent() as Spaceship
		var pos_changed: bool = spaceship_editor.global_position != previous_pos
		var vel_changed: bool = spaceship_editor.starting_velocity != previous_speed
		if pos_changed || vel_changed:
			queue_redraw()
		previous_pos = spaceship_editor.global_position
		previous_speed = spaceship_editor.starting_velocity

func get_trajectory(start_pos: Vector2, start_vel: Vector2, nb_points: int, dt: float, ds: int):
	var points_arc: PackedVector2Array       = PackedVector2Array()
	var arrow_pos: PackedVector2Array        = PackedVector2Array()
	var arrow_directions: PackedVector2Array = PackedVector2Array()
	
	points_arc.push_back(start_pos)
	var current_point: Vector2 = start_pos
	var current_vel: Vector2   = start_vel
	for i in range(nb_points + 1):
		var s = current_vel * dt
		current_point = current_point + s
		current_vel = current_vel + get_field_at(current_point) * dt
		points_arc.push_back(current_point)
		if (i + 1) % ds == 0:
			arrow_pos.push_back(current_point)
			arrow_directions.push_back(current_vel)

	var ret = TrajectoryData.new()
	ret.points_arc = points_arc
	ret.arrow_pos = arrow_pos
	ret.arrow_dir = arrow_directions
	return ret


func _draw() -> void:
	var color: Color   = Color(1, 1, 1)
	var nb_points: int = 200
	
	if Engine.is_editor_hint():
		stars = get_tree().get_nodes_in_group("gravity_objects")
		var spaceship:Spaceship = get_parent()
		var calculating_velocity = -spaceship.transform.y * spaceship.starting_velocity
		trajectory_data = get_trajectory(
			spaceship.global_position, 
			calculating_velocity, 200, 1.0 / 30.0, 20)

	if trajectory_data == null:
		return

	var points_arc = trajectory_data.points_arc
	var arrow_pos = trajectory_data.arrow_pos
	var arrow_dir = trajectory_data.arrow_dir
	
	draw_set_transform(Vector2.ZERO, 0)
	for index_point in range(nb_points - 1):
		draw_line(
			points_arc[index_point],
			points_arc[index_point + 1],
			lerp(color, Color(0, 0, 0, 0) ,float(index_point)/nb_points),
			1,
			true
		)

	for index_point in range(len(arrow_pos)):
		draw_set_transform(
			arrow_pos[index_point], 
			Vector2.DOWN.angle_to(arrow_dir[index_point]) + PI,
			Vector2(0.08, 0.08)
		)
		var arrow_len: int = len(arrow_pos)
		draw_texture(
			arrow_texture,
			Vector2(-half_texture_width, 0),
			lerp(color, Color(0, 0, 0, 0), float(index_point)/arrow_len)
		)
