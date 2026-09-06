class_name rondel_dagger_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute( targets : targeting_info) -> void:
	
	var damage = Damage.new()
	damage.set_amount(BattleController.data.discard.get_size()*2)
	damage.set_type(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	
	if targets.single_target().current_health == targets.single_target().max_health:
		damage.multiply_damage(2)
	
	targets.single_target().take_damage(damage)
