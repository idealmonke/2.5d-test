class_name lesser_cleanse_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	BattleController.data.player.heal(12)
	for key in BattleController.data.player.current_status_effects:
		var status: StatusEffect = BattleController.data.player.current_status_effects.get(key)
		if status.data.status_type == COMMON_ENUMS.STATUS_TYPE.NEGATIVE:
			status.stacks -= 1
			if status.stacks == 0:
				BattleController.data.player.current_status_effects.erase(key)
	BattleController.data.player._update_status()
