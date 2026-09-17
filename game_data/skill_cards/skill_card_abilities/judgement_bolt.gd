class_name judgement_bolt_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : targeting_info) -> void:
	
	var status_data = status_effect_registry.get_status_effect_data(0003)
	
	var damage = Damage.new()
	damage.add_damage(6, COMMON_ENUMS.DAMAGE_TYPE.HOLY)
	damage.source = BattleController.data.player
	damage.is_strike = true
	
	var status = status_effect.new(status_data)
	targets.single_target().take_damage(damage)
	targets.single_target().add_status_stacks(status, 2, 1.0)
