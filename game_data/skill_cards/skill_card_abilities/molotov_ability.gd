class_name molotov_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : targeting_info) -> void:
	
	var status_data = status_effect_registry.get_status_effect_data(4)
	
	for enem in BattleController.data.enemies:
		var damage = Damage.new()
		damage.add_damage(2, COMMON_ENUMS.DAMAGE_TYPE.FIRE)
		damage.source = BattleController.data.player
		damage.is_strike = true
		
		var status = status_effect.new(status_data)
		enem.take_damage(damage)
		enem.add_status_stacks(status, 3, 1.0)
