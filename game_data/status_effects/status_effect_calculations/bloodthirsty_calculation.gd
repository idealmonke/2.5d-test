class_name bloodthirsty_calculation
extends StatusEffectCalculation

func calculate(value: Variant, status: StatusEffect = null) -> Variant:
	var damage: Damage = value
	if damage.damages.has(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL):
		damage.add_damage(status.stacks, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	return null
