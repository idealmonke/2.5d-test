class_name bite_ability
extends enemy_card_ability

func execute() -> void:
	var damage = Damage.new()
	damage.add_damage(15,COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.active_turn
	damage.is_strike = true
	BattleController.data.player.take_damage(damage)
