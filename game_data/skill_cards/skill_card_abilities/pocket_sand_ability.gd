class_name pocket_sand_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : targeting_info) -> void:
	
	var status_data = status_effect_registry.get_status_effect_data(0001)
	var status = status_effect.new(status_data)
	targets.single_target().add_status_stacks(status, 2, 1.0)
	
	BattleController.dredge_card()
