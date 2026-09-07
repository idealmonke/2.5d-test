class_name rondel_dagger_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute( targets : targeting_info) -> void:
	
	var damage = Damage.new()
	damage.add_damage(BattleController.data.discard.get_size()*2, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.data.player
	
	var doubling_func = func(value: int):
		return value*2
	if targets.single_target().current_health == targets.single_target().max_health:
		damage.modify_all_damage(doubling_func)
	
	targets.single_target().take_damage(damage)
