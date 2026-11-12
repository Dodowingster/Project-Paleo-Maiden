class_name CharacterData
extends Resource

@export var character_name : String
@export var anim_lib : AnimationLibrary
@export var anim_lib_name : String
@export var atk : int = 5
@export var def : int = 5
@export var spd : int = 10
@export var min_sta : int = 1
@export var max_sta : int = 10
@export var max_hp : int = 100
@export var strategy : GlobalValues.Strategy = GlobalValues.Strategy.AGGRESSIVE
@export var min_distance : int = 80
@export var max_distance : int = 100
@export var forward_spd_mult : float = 0.5
@export var backward_spd_mult : float = 0.25
@export var forward_dash_spd_mult : float = 1.0
@export var forward_dash_min_duration : float = 0.3
@export var backward_dash_spd_mult : float = 0.5
@export var backward_dash_min_duration : float = 0.33
@export var action_goal_total : int = 300
@export var base_atk_data : TechniqueData

@export var current_hp : int = 0
