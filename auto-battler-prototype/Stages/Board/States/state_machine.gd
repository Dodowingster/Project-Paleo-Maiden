extends Node
class_name StateMachine

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var newState = states.get(new_state_name.to_lower())
	if !newState:
		return
	
	if current_state:
		current_state.exit()
	
	newState.enter()
	current_state = newState
	
