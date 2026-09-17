class_name block_ability
extends enemy_card_ability

func execute() -> void:
	BattleController.active_turn.gain_shield(5)
