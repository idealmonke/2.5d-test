class_name Damage
extends RefCounted

var damage_type: COMMON_ENUMS.DAMAGE_TYPE
var amount: int
	
func get_amount() -> int:
	return amount
	
func set_amount(value):
	amount = value
	if amount < 0:
		amount = 0

func add_damage(value) -> void:
	amount += value
	if amount < 0:
		amount = 0

func multiply_damage(value) -> void:
	amount *= value
