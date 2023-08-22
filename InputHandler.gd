extends Node2D

enum InputState {
	Normal,
	GetBigJump,
	TruePause
}

var input_state = InputState.Normal

@export var spaceship: Spaceship

var cache_spaceship_velocity: Vector2

var drag_start_position: Vector2

var max_jump_speed = 500

func _physics_process(delta):
	match input_state:
		InputState.Normal:
			spaceship.hide_big_jump_display()
			if Input.is_action_just_pressed("big_jump"):
				cache_spaceship_velocity = spaceship.velocity
				drag_start_position = get_global_mouse_position()
				spaceship.process_mode = Node.PROCESS_MODE_DISABLED
				input_state = InputState.GetBigJump
		InputState.GetBigJump:
			var mouse_velocity = (drag_start_position - get_global_mouse_position()) * 0.1
			spaceship.set_big_jump_display(
				mouse_velocity.length()/max_jump_speed, mouse_velocity.normalized())
			
			if Input.is_action_just_pressed("cancel_big_jump"):
				spaceship.process_mode = Node.PROCESS_MODE_INHERIT
				spaceship.load_velocity(cache_spaceship_velocity)
				input_state = InputState.Normal
			
			if Input.is_action_just_released("big_jump"):
				if mouse_velocity.length() > 10:
					spaceship.load_velocity(mouse_velocity)
				spaceship.process_mode = Node.PROCESS_MODE_INHERIT
				input_state = InputState.Normal
			spaceship.velocity = mouse_velocity
	
