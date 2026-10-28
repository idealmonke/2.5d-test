class_name heightened_arcana_calculation
extends StatusEffectCalculation

var types: Array[COMMON_ENUMS.DAMAGE_TYPE] = [
	COMMON_ENUMS.DAMAGE_TYPE.MAGIC,
	COMMON_ENUMS.DAMAGE_TYPE.FIRE,
	COMMON_ENUMS.DAMAGE_TYPE.LIGHTNING,
	COMMON_ENUMS.DAMAGE_TYPE.ICE
]

func calculate(value: Variant, status: StatusEffect = null) -> Variant:
	var damage: Damage = value
	for type in types:	
		if damage.damages.has(type):
			damage.add_damage(2, type)
	return null
