class_name bare_knuckles_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : TargetingInfo) -> void:
	var damage = Damage.new()
	damage.add_damage(4, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.data.player
	damage.is_strike = true
	await targets.single_target().take_damage(damage)
	
	var data: StatusEffectData = StatusEffectRegistry.get_status_effect_data(2)
	var status: StatusEffect = StatusEffect.new(data)
	BattleController.data.player.add_status_stacks(status, 2, 1)
