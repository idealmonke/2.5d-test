class_name rondel_dagger_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute( targets : targeting_info) -> void:
	
	if targets.single_target().is_full_health():
		targets.single_target().take_damage(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL, 4 * BattleController.data.discard.get_size())
	else:
		targets.single_target().take_damage(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL, 2 * BattleController.data.discard.get_size())
