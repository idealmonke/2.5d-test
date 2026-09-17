class_name holy_light_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : targeting_info) -> void:
	
	var status_data = status_effect_registry.get_status_effect_data(0009)
	
	for enem in BattleController.data.enemies:
		var status = status_effect.new(status_data)
		enem.add_status_stacks(status, 3, 1.0)
