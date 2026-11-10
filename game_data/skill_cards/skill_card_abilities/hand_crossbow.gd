class_name hand_crossbow_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute( targets : TargetingInfo) -> void:
	
	var damage = Damage.new()
	damage.add_damage(BattleController.data.discard.get_size(), COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.data.player
	damage.is_strike = true
	damage.ignore_shield = true
		
	await targets.single_target().take_damage(damage)
