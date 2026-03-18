@abstract
extends Node
class_name Trigger

## The condition to check for. Unique to each trigger type.
@abstract
func check_condition() -> bool
