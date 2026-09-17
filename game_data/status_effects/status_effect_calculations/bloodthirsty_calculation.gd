class_name bloodthirsty_calculation
extends status_effect_calculation

func calculate(value: Variant, status: status_effect = null) -> Variant:
	var damage: Damage = value
	if damage.damages.has(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL):
		damage.add_damage(status.stacks, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	return null
