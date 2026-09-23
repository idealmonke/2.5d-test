class_name holy_light_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	
	var status_data = StatusEffectRegistry.get_status_effect_data(0009)
	
	for enem in BattleController.data.enemies:
		var status = StatusEffect.new(status_data)
		enem.add_status_stacks(status, 3, 1.0)
