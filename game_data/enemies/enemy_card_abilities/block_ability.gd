class_name block_ability
extends EnemyCardAbility

func execute() -> void:
	BattleController.active_turn.gain_shield(5)
