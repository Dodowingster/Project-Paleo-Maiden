@abstract
class_name Effect
extends Node

## Executes the effect
@abstract
func execute_effect(delta: float) -> void

@abstract
func execute_physics_effect(delta: float) -> void

@abstract
func reset() -> void
