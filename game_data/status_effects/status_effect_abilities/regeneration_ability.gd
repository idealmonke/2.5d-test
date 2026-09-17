class_name regeneration_ability
extends status_effect_ability

func execute(target: Variant, status: status_effect) -> void:
	BattleController.data.player.heal(5)
