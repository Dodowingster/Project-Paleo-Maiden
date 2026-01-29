extends Node

signal updateDataToChar(distance: float, tickCount: int)

enum STRATEGY {AGGRESSIVE, BALANCED, DEFENSIVE}

enum ACTION {ATTACK, CLASH, MOVE}

func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale, true, true, true).timeout
	Engine.time_scale = 1.0
