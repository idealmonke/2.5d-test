class_name brief_respite_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : targeting_info) -> void:
	BattleController.data.player.heal(5)
	BattleController.data.player.regain_mana(5)
	BattleController.draw_card()
