class_name divine_favor_calculation
extends status_effect_calculation

func calculate(value: Variant) -> Variant:
	if value.damage.has(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL):
		value.add_damage(2, COMMON_ENUMS.DAMAGE_TYPE.HOLY)
	
	return null
