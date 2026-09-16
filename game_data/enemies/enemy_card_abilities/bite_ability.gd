class_name bite_ability
extends enemy_card_ability

func execute() -> void:
	var damage = Damage.new()
	damage.set_amount(1)
	damage.set_type(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	BattleController.data.player.take_damage(damage)
