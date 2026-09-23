class_name reactant_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	for effect_name in BattleController.data.player.current_status_effects:
		var effect : StatusEffect = BattleController.data.player.current_status_effects[effect_name]
		
		var status: StatusEffect = StatusEffect.new(effect.data)
		BattleController.data.player.add_status_stacks(status, 1, 1)
