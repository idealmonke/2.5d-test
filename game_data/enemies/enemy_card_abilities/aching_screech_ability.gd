class_name aching_screech_ability
extends enemy_card_ability

func execute() -> void:
	var status_data = status_effect_registry.get_status_effect_data(69420)
	var status = status_effect.new(status_data)
	BattleController.data.player.add_status_stacks(status, 1, 1)
