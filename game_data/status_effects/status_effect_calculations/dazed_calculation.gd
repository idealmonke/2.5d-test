class_name dazed_calculation
extends StatusEffectCalculation

func calculate(value: Variant, status: StatusEffect = null) -> Variant:
	return value - 1
