class_name cold_front_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	
	var status_data = StatusEffectRegistry.get_status_effect_data(12)
	var status = StatusEffect.new(status_data)
	BattleController.data.player.add_status_stacks(status, 2, 1.0)
	BattleController.data.player.gain_shield(12)
	
	for enem in BattleController.data.enemies:
		status = StatusEffect.new(status_data)
		enem.add_status_stacks(status, 2, 1.0)
