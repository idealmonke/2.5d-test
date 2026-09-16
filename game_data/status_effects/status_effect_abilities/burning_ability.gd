class_name burning_ability
extends status_effect_ability

func execute(target: Variant, status: status_effect) -> void:
	var damage = Damage.new()
	damage.add_damage(2, COMMON_ENUMS.DAMAGE_TYPE.FIRE)
	var scale_by_turns = func(amount: int) -> int:
		return status.duration_active * amount
	damage.modify_all_damage(scale_by_turns)
	
	target.take_damage(damage)
