extends Node

signal update_data_to_char(distance: float, tick_count: int)

enum Strategy {AGGRESSIVE, BALANCED, DEFENSIVE, EVASIVE}

enum Action {ATTACK, CLASH, MOVE}

enum Direction {LEFT, RIGHT}

enum MapAction {SCOUT, MOVE, CAMP}

#enum GlobalEvent {MAP, CAMP, EVENT, BATTLE}

func frame_freeze(time_scale, duration):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale, true, true, true).timeout
	Engine.time_scale = 1.0
