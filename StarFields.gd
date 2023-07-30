extends Node2D
# this class will collect all children of GravityObject
# and give gravity strength at certain point
# unfortunately it might be necessary to generate this per query
# or at least update everytime something moves

var stars

@onready var spaceship:Node2D = $Spaceship



func _ready():
	stars = get_children().filter(func(x:Node): return x.has_method("get_gravity_vector"))
	print(len(stars))
	
	print("spaceship is", spaceship)	

func get_field_at(pos):
	var result = Vector2.ZERO
	for star in stars:
		result += star.get_gravity_vector(pos)
	return result
	
func _physics_process(delta):
	spaceship.field_dir = get_field_at(spaceship.global_position)
		
		
func get_trajectory(start_pos, start_vel, nb_points, dt):
	var points_arc = PackedVector2Array()
	points_arc.push_back(start_pos)
	var current_point = start_pos
	var current_vel = start_vel
	for i in range(nb_points + 1):
		current_point = current_point + current_vel * dt
		current_vel = current_vel + get_field_at(current_point) * dt
		points_arc.push_back(current_point)
	
	return points_arc
	
func _process(delta):
	queue_redraw()

func _draw():
	var color = Color(1.0, 1.0, 1.0)
	var nb_points = 1000
	var points_arc = PackedVector2Array()
	print(get_global_mouse_position())
#	if (spaceship.velocity_cached == Vector2.INF):
#		points_arc = get_trajectory(spaceship.global_position, spaceship.velocity, nb_points, 50)
#	else:
	print(spaceship.velocity)
	points_arc = get_trajectory(spaceship.global_position, spaceship.velocity, nb_points, 1.0/30.0)
	
	for index_point in range(nb_points):
		draw_circle(points_arc[index_point], 2, color)
