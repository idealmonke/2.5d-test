class_name frozen_calculation
extends StatusEffectCalculation

func calculate(value: Variant, status : StatusEffect = null) -> Variant:
	var damage: Damage = value
	damage.add_damage(2, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	return null
