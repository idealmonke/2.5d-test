class_name holy_light_status_ability
extends StatusEffectAbility

func execute(target: Entity, status: StatusEffect) -> void:
	var damage = Damage.new()
	damage.add_damage(3, COMMON_ENUMS.DAMAGE_TYPE.HOLY)
	target.take_damage(damage)
