class_name brief_respite_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	BattleController.data.player.heal(5)
	BattleController.data.player.regain_mana(5)
	BattleController.draw_card()
