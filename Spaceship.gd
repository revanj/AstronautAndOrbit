extends CharacterBody2D
class_name Spaceship

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var forward_speed = 0.5

@onready var visual = $SpaceshipVisual
@onready var big_jump_display = $BigJumpDisplay

var velocity_cached = Vector2.INF
var field_dir: Vector2
var heading_direction: Vector2

func _physics_process(delta):
	if (velocity_cached != Vector2.INF):
		velocity = velocity_cached
		velocity_cached = Vector2.INF
		
	velocity += field_dir * delta
	visual.set_heading(heading_direction)
	move_and_slide()

func turn_heading(rad):
	heading_direction = heading_direction.rotated(rad)
	

# this gurantees cached velocity to be loaded by next frame start
func load_velocity(vel: Vector2):
	velocity_cached = vel
	heading_direction = vel.normalized()

func set_big_jump_display(strength: float, direction: Vector2):
	big_jump_display.visible = true
	big_jump_display.set_strength_direction(strength, direction)
	visual.set_heading(direction)

func hide_big_jump_display():
	big_jump_display.visible = false

func add_thruster():
	velocity += heading_direction * forward_speed
	$SpaceshipVisual/FlameRed.show()

func disable_flame():
	$SpaceshipVisual/FlameRed.hide()

func show_big_jump_flame():
	var tween = get_tree().create_tween()
	tween.tween_property($SpaceshipVisual/FlameBlue, "modulate", Color.WHITE, 0.1)
	tween.tween_property($SpaceshipVisual/FlameBlue, "modulate", Color.WHITE, 0.25)
	tween.tween_property($SpaceshipVisual/FlameBlue, "modulate", Color.TRANSPARENT, 0.1)

