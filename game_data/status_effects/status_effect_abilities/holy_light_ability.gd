class_name holy_light_status_ability
extends status_effect_ability

func execute(target: Variant, status: status_effect) -> void:
	var damage = Damage.new()
	damage.add_damage(3, COMMON_ENUMS.DAMAGE_TYPE.HOLY)
	target.take_damage(damage)
