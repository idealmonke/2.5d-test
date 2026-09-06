class_name burning_ability
extends status_effect_ability

func execute(target: Variant, status: status_effect) -> void:
	var damage = Damage.new()
	damage.set_type(COMMON_ENUMS.DAMAGE_TYPE.FIRE)
	damage.set_amount(2)
	damage.multiply_damage(status.duration_active+1)
