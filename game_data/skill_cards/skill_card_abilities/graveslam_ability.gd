class_name graveslam_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	
	
	for enem in BattleController.data.enemies:
		var damage = Damage.new()
		damage.add_damage(BattleController.data.discard.get_size()/2 + 1, COMMON_ENUMS.DAMAGE_TYPE.MAGIC)
		damage.source = BattleController.data.player
		damage.is_strike = false
		enem.take_damage(damage)
