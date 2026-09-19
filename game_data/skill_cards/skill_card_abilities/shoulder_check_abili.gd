class_name shoulder_check_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : TargetingInfo) -> void:
	var damage = Damage.new()
	damage.add_damage(6, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.data.player
	damage.is_strike = true
	targets.single_target().take_damage(damage)
	
	if(BattleController.data.player.current_status_effects.has("Bloodthirsty")):
		var data: StatusEffectData = StatusEffectRegistry.get_status_effect_data(5)
		var status: StatusEffect = StatusEffect.new(data)
		targets.single_target().add_status_stacks(status, 1, 1)
