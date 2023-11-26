extends Node

@onready var thruster_loop = $ThrusterLoopPlayer
@onready var thruster_end = $ThrusterEndPlayer

enum State {NONE, LOOP, END}
var state: State = State.NONE

signal end_finish_or_start

func _process(delta):
	var next_state: State = state
	match state:
		State.NONE:
			if Input.is_action_just_pressed("thruster_forward"):
				next_state = State.LOOP
				thruster_loop.play()
		State.LOOP:
			if !Input.is_action_pressed("thruster_forward"):
				thruster_loop.stop()
				next_state = State.END
				thruster_end.play()
		State.END:
			if !thruster_end.playing:
				next_state = State.NONE
			if Input.is_action_just_pressed("thruster_forward"):
				thruster_end.stop()
				next_state = State.LOOP
				thruster_loop.play()
	state = next_state

