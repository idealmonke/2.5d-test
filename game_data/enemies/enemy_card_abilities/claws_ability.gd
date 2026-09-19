class_name claws_ability
extends EnemyCardAbility

func execute() -> void:
	for i in range(2):
		var damage = Damage.new()
		damage.add_damage(9,COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
		damage.source = BattleController.active_turn
		damage.is_strike = true
		BattleController.data.player.take_damage(damage)
