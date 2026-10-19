class_name thorns_ability
extends StatusEffectAbility

func execute(target: Entity, status: StatusEffect) -> void:
	var damage: Damage = Damage.new()
	var source: Entity = target.get_meta("previous_damage_source")
	
	damage.add_damage(target.get_meta("previous_damage") * 0.2, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	source.take_damage(damage)
	
