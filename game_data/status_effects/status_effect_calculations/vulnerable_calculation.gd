class_name vulnerable_calculation
extends StatusEffectCalculation

func calculate(value: Variant, status : StatusEffect = null) -> Variant:
	var damage: Damage = value
	damage.modify_all_damage(func(value: int): return value * 1.2)
	return null
