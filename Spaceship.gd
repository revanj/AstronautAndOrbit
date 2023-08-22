extends CharacterBody2D
class_name Spaceship

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var visual = $SpaceshipVisual
@onready var big_jump_display = $BigJumpDisplay

var velocity_cached = Vector2.INF
var field_dir: Vector2

func _physics_process(delta):
	if (velocity_cached != Vector2.INF):
		velocity = velocity_cached
		velocity_cached = Vector2.INF
		
	velocity += field_dir * delta
	visual.set_heading(velocity)
	move_and_slide()


# this gurantees cached velocity to be loaded by next frame start
func load_velocity(vel: Vector2):
	velocity_cached = vel

func set_big_jump_display(strength: float, direction: Vector2):
	big_jump_display.visible = true
	big_jump_display.set_strength_direction(strength, direction)
	visual.set_heading(direction)

func hide_big_jump_display():
	big_jump_display.visible = false
