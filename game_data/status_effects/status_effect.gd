class_name status_effect
extends RefCounted

var data: status_effect_data

var stacks: int
var magnitude: int
var duration_active: int

func _init(status_data: status_effect_data) -> void:
	data = status_data
	stacks = 0
	duration_active = 0
