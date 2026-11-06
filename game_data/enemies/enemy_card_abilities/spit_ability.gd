class_name spit_ability
extends EnemyCardAbility

func execute() -> void:
	var damage: Damage = Damage.new()
	damage.add_damage(8, COMMON_ENUMS.DAMAGE_TYPE.FIRE)
	damage.is_strike = true
	damage.source = BattleController.active_turn
	await BattleController.data.player.take_damage(damage)
