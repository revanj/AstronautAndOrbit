extends Node2D

enum InputState {
	Normal,
	GetBigJump,
	TruePause
}

var input_state = InputState.Normal


var brake_speed = 10
var turn_factor = 0.05

@export var spaceship: Spaceship
@export var camera: Camera2D

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
			if Input.is_action_pressed("thruster_forward"):
				spaceship.add_thruster()
			else:
				spaceship.disable_flame()
			if Input.is_action_pressed("thruster_brake"):
				spaceship.velocity *= 0.95
			if Input.is_action_pressed("thruster_left_turn"):
				spaceship.turn_heading(-turn_factor)
			if Input.is_action_pressed("thruster_right_turn"):
				spaceship.turn_heading(turn_factor)
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
					spaceship.show_big_jump_flame()
				spaceship.process_mode = Node.PROCESS_MODE_INHERIT
				input_state = InputState.Normal
			spaceship.velocity = mouse_velocity
	
func _unhandled_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom /= 1.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom *= 1.1
