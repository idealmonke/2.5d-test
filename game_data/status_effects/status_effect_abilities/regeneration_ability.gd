class_name regeneration_ability
extends StatusEffectAbility

func execute(target: Variant, status: StatusEffect) -> void:
	BattleController.data.player.heal(5)
