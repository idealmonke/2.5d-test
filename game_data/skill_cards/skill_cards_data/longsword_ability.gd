class_name longsword_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.DOUBLE

func execute(controller: battle_controller, targets : targeting_info) -> void:
	targets.deal_damage(controller, 0, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL, 5)
	targets.deal_damage(controller, 1, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL, 5)
