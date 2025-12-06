extends Label

@export var tickTracker: TickTracker

func _ready() -> void:
	text = str(0)

func _process(_delta: float) -> void:
	text = str(tickTracker.tickCount)
