class_name CharStateMachine
extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _physics_process(delta):
	if owner.has_method("set_char_velocity"):
		owner.set_char_velocity(delta)
	else:
		print("RENAME YOUR SHIT")
	if current_state:
		current_state.physics_update(delta)
	if owner is Character:
		if !owner.is_on_wall():
			owner.velocity_x_before_wall = roundf(owner.velocity.x)
		else:
			if current_state is StunState:
				if owner.velocity_x_before_wall != 0:
					owner.opponent.velocity.x -= owner.velocity_x_before_wall
					owner.velocity_x_before_wall = 0
				else:
					if current_state.impact_just_applied:
						owner.opponent.velocity.x -= owner.velocity.x
		owner.move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return

	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
