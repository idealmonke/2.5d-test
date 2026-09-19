class_name StatusEffect
extends RefCounted

var data: StatusEffectData

var stacks: int
var magnitude: float
var duration_active: int

func _init(status_data: StatusEffectData) -> void:
	data = status_data
	stacks = 0
	duration_active = 1
