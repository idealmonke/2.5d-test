class_name rally_ability
extends EnemyCardAbility

func execute() -> void:
	for enem in BattleController.data.enemies:
		if enem.tags.has("Kobold") || enem.tags.has("Dragon"):
			enem.gain_shield(3)
