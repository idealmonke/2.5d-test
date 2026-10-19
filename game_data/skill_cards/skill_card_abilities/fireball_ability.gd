class_name fireball_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	
	var status_data = StatusEffectRegistry.get_status_effect_data(4)
	
	for enem in BattleController.data.enemies:
		var damage = Damage.new()
		damage.add_damage(10, COMMON_ENUMS.DAMAGE_TYPE.FIRE)
		damage.source = BattleController.data.player
		damage.is_strike = false
		
		var status = StatusEffect.new(status_data)
		enem.take_damage(damage)
		enem.add_status_stacks(status, 2, 1.0)
