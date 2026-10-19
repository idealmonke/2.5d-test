class_name shamanic_wave_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	
	var status_data = StatusEffectRegistry.get_status_effect_data(4)
	var enemies_hit: int = 0
	
	for enem in BattleController.data.enemies:
		var damage = Damage.new()
		damage.add_damage(6, COMMON_ENUMS.DAMAGE_TYPE.MAGIC)
		damage.source = BattleController.data.player
		damage.is_strike = false
		enem.take_damage(damage)
		
		enemies_hit += 1
	
	BattleController.data.player.gain_shield(enemies_hit*3)
