extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var visual = $SpaceshipVisual

var velocity_cached = Vector2.INF
var field_dir: Vector2

func _physics_process(delta):
	print("processing physics")
	if (velocity_cached != Vector2.INF):
		velocity = velocity_cached
		velocity_cached = Vector2.INF
		
	velocity += field_dir * delta
	visual.set_heading(velocity)
	move_and_slide()


# this gurantees cached velocity to be loaded by next frame start
func load_velocity(vel: Vector2):
	velocity_cached = vel
