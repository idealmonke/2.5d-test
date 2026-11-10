class_name magic_missile_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.TRIPLE

func execute(targets : TargetingInfo) -> void:
	for target in targets.all_targets():
		var damage = Damage.new()
		damage.add_damage(3, COMMON_ENUMS.DAMAGE_TYPE.MAGIC)
		damage.source = BattleController.data.player
		damage.is_strike = true
		await target.take_damage(damage)
