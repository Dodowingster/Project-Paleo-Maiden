@abstract
extends Node
class_name Effect

## Executes the effect
@abstract
func execute_effect(delta: float) -> void

@abstract
func execute_physics_effect(delta: float) -> void

@abstract
func reset() -> void
