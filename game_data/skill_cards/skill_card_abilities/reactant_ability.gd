class_name reactant_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : TargetingInfo) -> void:
	var target = targets.single_target();
	if(target is Enemy):
		for effect_name in target.current_status_effects:
			var effect : StatusEffect = target.current_status_effects[effect_name]
			
			var status: StatusEffect = StatusEffect.new(effect.data)
			target.add_status_stacks(status, 1, 1)
	else:
		for effect_name in BattleController.data.player.current_status_effects:
			var effect : StatusEffect = BattleController.data.player.current_status_effects[effect_name]
			
			var status: StatusEffect = StatusEffect.new(effect.data)
			BattleController.data.player.add_status_stacks(status, 1, 1)
