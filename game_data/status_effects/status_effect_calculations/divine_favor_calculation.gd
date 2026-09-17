class_name divine_favor_calculation
extends status_effect_calculation

func calculate(value: Variant) -> Variant:
	var damage: Damage = value
	if damage.damages.has(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL):
		damage.add_damage(2, COMMON_ENUMS.DAMAGE_TYPE.HOLY)
	return null
