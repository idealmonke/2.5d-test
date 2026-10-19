class_name regeneration_ability
extends StatusEffectAbility

func execute(target: Entity, status: StatusEffect) -> void:
	BattleController.data.player.heal(5)
