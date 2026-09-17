class_name divine_favor_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : targeting_info) -> void:
	var data: status_effect_data = status_effect_registry.get_status_effect_data(2)
	var status: status_effect = status_effect.new(data)
	BattleController.data.player.add_status_stacks(status, 2, 1)
