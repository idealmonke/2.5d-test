class_name divine_favor_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	var data: StatusEffectData = StatusEffectRegistry.get_status_effect_data(6)
	var status: StatusEffect = StatusEffect.new(data)
	BattleController.data.player.add_status_stacks(status, 2, 1)
