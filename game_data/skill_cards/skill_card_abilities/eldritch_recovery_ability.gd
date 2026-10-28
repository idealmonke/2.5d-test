class_name eldritch_recovery_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	BattleController.data.player.regain_mana(10)
	
	var damage: Damage = Damage.new()
	damage.add_damage(5, COMMON_ENUMS.DAMAGE_TYPE.MAGIC)
	damage.is_strike = false
	damage.ignore_shield = true

	BattleController.data.player.take_damage(damage)
