class_name pocket_sand_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : TargetingInfo) -> void:
	
	var status_data = StatusEffectRegistry.get_status_effect_data(0001)
	var status = StatusEffect.new(status_data)
	targets.single_target().add_status_stacks(status, 2, 1.0)
	
	BattleController.dredge_card()
