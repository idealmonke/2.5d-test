class_name divine_favor_calculation
extends StatusEffectCalculation

func calculate(value: Variant, status: StatusEffect = null) -> Variant:
	var damage: Damage = value
	if damage.damages.has(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL):
		damage.add_damage(2, COMMON_ENUMS.DAMAGE_TYPE.HOLY)
	return null
