class_name dazed_calculation
extends status_effect_calculation

func calculate(value: Variant, status : status_effect = null) -> Variant:
	return value - 1
