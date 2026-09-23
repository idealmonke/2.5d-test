class_name aching_screech_ability
extends EnemyCardAbility

func execute() -> void:
	var status_data = StatusEffectRegistry.get_status_effect_data(5)
	var status = StatusEffect.new(status_data)
	BattleController.data.player.add_status_stacks(status, 1, 1)
