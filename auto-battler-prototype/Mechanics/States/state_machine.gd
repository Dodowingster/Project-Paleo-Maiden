extends Node
class_name StateMachine

@export var initialState: State
var currentState: State
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)
	
	if initialState:
		initialState.enter()
		currentState = initialState

func _physics_process(delta):
	if owner.has_method("set_char_velocity"):
		owner.set_char_velocity(delta)
	else:
		print("RENAME YOUR SHIT")
	if currentState:
		currentState.physics_update(delta)
	owner.move_and_slide()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentState:
		currentState.update(delta)

func on_child_transition(state, new_state_name):
	if state != currentState:
		return
	
	var newState = states.get(new_state_name.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.exit()
	
	newState.enter()
	currentState = newState
	
