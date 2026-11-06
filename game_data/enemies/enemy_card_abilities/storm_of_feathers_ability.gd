class_name storm_of_feathers_ability
extends EnemyCardAbility

func execute() -> void:
	for i in range(3):
		var damage = Damage.new()
		damage.add_damage(10,COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
		damage.source = BattleController.active_turn
		damage.is_strike = true
		await BattleController.data.player.take_damage(damage)
