class_name quick_focus_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	BattleController.draw_card()
	BattleController.draw_card()
	BattleController.data.player.regain_mana(5)
