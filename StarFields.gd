extends Node2D
# this class will collect all children of GravityObject
# and give gravity strength at certain point
# unfortunately it might be necessary to generate this per query
# or at least update everytime something moves

var stars

@onready var spaceship:Node2D = $Spaceship
@export var arrow_texture: Texture

var half_texture_width: float

class TrajectoryData:
	var points_arc
	var arrow_pos
	var arrow_dir

func _ready():
	stars = get_children().filter(func(x:Node): return x.has_method("get_gravity_vector"))
	half_texture_width = arrow_texture.get_width()/2
	
func get_field_at(pos):
	var result = Vector2.ZERO
	for star in stars:
		result += star.get_gravity_vector(pos)
	return result
	
func _physics_process(delta):
	spaceship.field_dir = get_field_at(spaceship.global_position)
		
		
func get_trajectory(start_pos, start_vel, nb_points, dt, ds):
	var points_arc = PackedVector2Array()
	var arrow_pos = PackedVector2Array()
	var arrow_directions = PackedVector2Array()
	
	points_arc.push_back(start_pos)
	var current_point = start_pos
	var current_vel = start_vel
	var s_accumulate = 0
	for i in range(nb_points + 1):
		var s = current_vel * dt
		current_point = current_point + s
		current_vel = current_vel + get_field_at(current_point) * dt
		s_accumulate += s.length()
		if s_accumulate >= ds:
			arrow_pos.push_back(current_point)
			arrow_directions.push_back(current_vel)
			s_accumulate = 0
		points_arc.push_back(current_point)
	var ret = TrajectoryData.new()
	ret.points_arc = points_arc
	ret.arrow_pos = arrow_pos
	ret.arrow_dir = arrow_directions
	return ret
	
func _process(delta):
	queue_redraw()

func _draw():
	var color = Color(1.0, 1.0, 1.0)
	var nb_points = 2000
	
	var trajectory_data = get_trajectory(
		spaceship.global_position,
		spaceship.velocity,
		nb_points, 1.0/30.0, 100)
	
	var points_arc = trajectory_data.points_arc
	var arrow_pos = trajectory_data.arrow_pos
	var arrow_dir = trajectory_data.arrow_dir
	
	draw_set_transform(Vector2.ZERO, 0)
	for index_point in range(nb_points):
		draw_circle(points_arc[index_point], 1, color)
	
	for index_point in range(len(arrow_pos)):
		draw_set_transform(
			arrow_pos[index_point], 
			Vector2.DOWN.angle_to(arrow_dir[index_point]) + PI,
			Vector2(0.08, 0.08)
		)
		draw_texture(arrow_texture, Vector2(-half_texture_width, 0))
