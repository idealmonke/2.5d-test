class_name arcane_ward_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	BattleController.data.player.gain_shield(15)
