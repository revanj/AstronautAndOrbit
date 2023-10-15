extends Node2D

@export var arrow_texture: Texture

var arrow_count = 30
var radius = 220
var w = 2
@onready var half_texture_width: float = arrow_texture.get_width()/2.0



func _process(delta):
	queue_redraw()
	
	
func _draw():	
	for index_point in range(arrow_count * 2):
		var time =  Time.get_unix_time_from_system()
		var angle = fmod(PI * 2.0 / arrow_count * index_point - time * w, PI * 2.0)
		var pos = Vector2(cos(angle) * radius, sin(angle) * radius)
		var xform = Transform2D(
			(Vector2.RIGHT * 0.5).rotated(angle),
			(Vector2.DOWN * 0.1).rotated(angle),
			pos)
		draw_set_transform_matrix(
			xform
		)
		draw_texture(arrow_texture, Vector2(-half_texture_width, 0), Color(1, 1, 1, 0.2))
