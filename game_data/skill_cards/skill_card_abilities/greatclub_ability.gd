class_name greatclub_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : targeting_info) -> void:
	var damage = Damage.new()
	damage.add_damage(12, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.data.player
	damage.is_strike = true
	targets.single_target().take_damage(damage)
	
	if(BattleController.data.player.current_status_effects.has("Bloodthirsty")):
		var data: status_effect_data = status_effect_registry.get_status_effect_data(2)
		var status: status_effect = status_effect.new(data)
		BattleController.data.player.add_status_stacks(status, 1, 1)
