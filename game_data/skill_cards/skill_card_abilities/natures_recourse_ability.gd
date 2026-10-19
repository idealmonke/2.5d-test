class_name natures_recourse
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	
	var status_data = StatusEffectRegistry.get_status_effect_data(0010)
	var status = StatusEffect.new(status_data)
	BattleController.data.player.add_status_stacks(status, 1, 1.0)
