class_name longsword_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute( targets : targeting_info) -> void:
	BattleController.draw_card()
	targets.single_target().take_damage(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL, BattleController.data.hand.get_hand_size()*2)
