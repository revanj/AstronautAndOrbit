extends Node2D

enum InputState {
	Normal,
	GetBigJump,
	TruePause
}

var input_state = InputState.Normal

@export var spaceship: CharacterBody2D

var cache_spaceship_velocity: Vector2
var mouse_movement_velocity: Vector2

func _physics_process(delta):
	print(get_tree().paused)
	match input_state:
		InputState.Normal:
			if Input.is_action_just_pressed("big_jump"):
				cache_spaceship_velocity = spaceship.velocity
				mouse_movement_velocity = Vector2.ZERO
				get_tree().paused = true
				input_state = InputState.GetBigJump
		InputState.GetBigJump:
			print("state big jump")
			var mouse_velocity = (get_global_mouse_position() - spaceship.global_position) * 0.1
			spaceship.load_velocity(mouse_velocity)
			
			if Input.is_action_just_pressed("cancel_big_jump"):
				get_tree().paused = false
				spaceship.load_velocity(cache_spaceship_velocity)
				input_state = InputState.Normal
			
			if Input.is_action_just_released("big_jump"):
				spaceship.load_velocity(mouse_velocity)
				get_tree().paused = false
				input_state = InputState.Normal

func _input(event):
	match input_state:
		InputState.GetBigJump:
			if event is InputEventMouseMotion:
				mouse_movement_velocity += event.relative
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		print("Mouse Motion at: ", event.position)
