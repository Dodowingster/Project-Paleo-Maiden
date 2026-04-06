extends Resource
class_name CharacterData

@export var characterName : String
@export var animLib : AnimationLibrary
@export var animLibName : String
@export var atk : int = 5
@export var def : int = 5
@export var spd : int = 10
@export var minSta : int = 1
@export var maxSta : int = 10
@export var maxHP : int = 100
@export var strategy : GlobalValues.STRATEGY = GlobalValues.STRATEGY.AGGRESSIVE
@export var minDistance : int = 80
@export var maxDistance : int = 100
@export var forwardSpdMult : float = 1.0
@export var backwardSpdMult : float = 0.5
@export var actionGoalTotal : int = 300
@export var baseAtkData : TechniqueData
