class_name judgement_bolt_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : TargetingInfo) -> void:
	
	var status_data = StatusEffectRegistry.get_status_effect_data(0003)
	
	var damage = Damage.new()
	damage.add_damage(6, COMMON_ENUMS.DAMAGE_TYPE.HOLY)
	damage.source = BattleController.data.player
	damage.is_strike = true
	
	var status = StatusEffect.new(status_data)
	await targets.single_target().take_damage(damage)
	targets.single_target().add_status_stacks(status, 2, 1.0)
