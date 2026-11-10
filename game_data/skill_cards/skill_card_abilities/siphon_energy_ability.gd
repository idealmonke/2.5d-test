class_name siphon_energy_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute( targets : TargetingInfo) -> void:
	
	var damage = Damage.new()
	damage.add_damage(5, COMMON_ENUMS.DAMAGE_TYPE.MAGIC)
	damage.source = BattleController.data.player
	damage.is_strike = true
		
	damage.shield_multipliers.push_front(func(value: int): return value*2)
	await targets.single_target().take_damage(damage)
	
	var dealt: int = targets.single_target().get_meta('previous_damage')
	BattleController.data.player.gain_shield(dealt)
