class_name vulnerable_calculation
extends status_effect_calculation

func calculate(value: Variant, status : status_effect = null) -> Variant:
	var damage: Damage = value
	damage.modify_all_damage(func(value: int): return value * 1.2)
	return null
