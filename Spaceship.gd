extends CharacterBody2D
class_name Spaceship


# About the structure of the spaceship:
# This script takes player inputs and outputs:
#	velocity -> used to move and slide
#	display_velocity -> grabbed by the star field to integrate and draw route
#	heading -> used by the display to display spaceship heading 

var forward_speed = 0.5
var brake_speed = 10
var turn_factor = 0.05

enum InputState {
	Normal,
	GetBigJump,
	TruePause
}

signal fuel_changed
signal big_jump_fuel_changed

var input_state = InputState.Normal

@onready var visual = $SpaceshipVisual
@onready var big_jump_display = $BigJumpDisplay
@onready var spaceship: Spaceship = self

var velocity_cached = Vector2.INF
var field_dir: Vector2
var heading_direction: Vector2
var display_velocity: Vector2

var cache_spaceship_velocity: Vector2
var drag_start_position: Vector2
var max_jump_speed = 500

var fuel_decrease_amount = 0.6
var big_jump_fuel_amount = 30

@export var starting_big_jump_fuel = 90
@export var starting_fuel:float = 100
	
@onready var star_field = $NavDisplay

@export var starting_velocity:float:
	set(value):
		starting_velocity = value
		if star_field != null:
			star_field.queue_redraw()

var fuel_meter: float = 100 :
	set(value):
		fuel_meter = value
		emit_signal("fuel_changed", value)

var big_jump_fuel: float = 90:
	set(value):
		big_jump_fuel = value
		emit_signal("big_jump_fuel_changed", value)

func _ready():
	star_field.spaceship = self
	load_velocity(-transform.y * starting_velocity)
	
	fuel_meter = starting_fuel
	big_jump_fuel = starting_big_jump_fuel

func _physics_process(delta):
	match input_state:
		InputState.Normal:
			spaceship.hide_big_jump_display()
			if Input.is_action_just_pressed("big_jump"):
				if (big_jump_fuel >= big_jump_fuel_amount):
					cache_spaceship_velocity = spaceship.velocity
					drag_start_position = get_global_mouse_position()
					spaceship.velocity = Vector2.ZERO
					input_state = InputState.GetBigJump
			if Input.is_action_pressed("thruster_forward") && fuel_meter > 0:
				spaceship.add_thruster()
				fuel_meter -= fuel_decrease_amount
			else:
				spaceship.disable_flame()
			if Input.is_action_pressed("thruster_brake"):
				spaceship.velocity *= 0.95
				fuel_meter -= fuel_decrease_amount
			if Input.is_action_pressed("thruster_left_turn"):
				spaceship.turn_heading(-turn_factor)
			if Input.is_action_pressed("thruster_right_turn"):
				spaceship.turn_heading(turn_factor)
			
			velocity += field_dir * delta
			display_velocity = velocity
			visual.set_heading(heading_direction)
			
		InputState.GetBigJump:
			var mouse_velocity = (drag_start_position - get_global_mouse_position()) * 2
			spaceship.set_big_jump_display(
				mouse_velocity.length()/max_jump_speed, mouse_velocity.normalized())
			if mouse_velocity.length() > 10:
				display_velocity = mouse_velocity
			else:
				display_velocity = cache_spaceship_velocity
			
			if Input.is_action_just_pressed("cancel_big_jump"):
				spaceship.process_mode = Node.PROCESS_MODE_INHERIT
				spaceship.load_velocity(cache_spaceship_velocity)
				input_state = InputState.Normal
			
			if Input.is_action_just_released("big_jump"):
				big_jump_fuel -= big_jump_fuel_amount
				if mouse_velocity.length() > 10:
					spaceship.load_velocity(mouse_velocity)
					spaceship.show_big_jump_flame()
				input_state = InputState.Normal
			

	if (velocity_cached != Vector2.INF):
		velocity = velocity_cached
		velocity_cached = Vector2.INF
	
	
	star_field.trajectory_data = star_field.get_trajectory(
		spaceship.global_position,
		spaceship.display_velocity,
		200, 1.0/30.0, 10)
		
	move_and_slide()

func turn_heading(rad):
	heading_direction = heading_direction.rotated(rad)
	
# this gurantees cached velocity to be loaded by next frame start
func load_velocity(vel: Vector2):
	velocity = vel
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

#func _unhandled_input(event):
#	if event is InputEventMouseButton && event.is_pressed():
#		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
#			camera.zoom /= 1.1
#		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#			camera.zoom *= 1.1
