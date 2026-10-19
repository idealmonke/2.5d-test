class_name natures_recourse_status_ability
extends StatusEffectAbility

func execute(target: Entity, status: StatusEffect) -> void:
	target.current_status_effects["Nature's Recourse"].stacks -= 1
	if target.current_status_effects["Nature's Recourse"].stacks < 1:
		target.current_status_effects.erase("Nature's Recourse")
	
	target.gain_shield(target.get_meta("previous_damage"))
	
