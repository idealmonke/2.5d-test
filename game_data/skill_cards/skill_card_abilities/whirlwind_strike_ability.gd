class_name whirlwind_strike_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	var valid_enemies: Array[Enemy] = BattleController.data.enemies.duplicate()
	
	for i in range(BattleController.data.hand.get_hand_size()):
		var damage = Damage.new()
		damage.is_strike = true
		damage.add_damage(3, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
		damage.source = BattleController.data.player
		await valid_enemies[randi()%valid_enemies.size()].take_damage(damage)
		valid_enemies.filter(func(enem: Enemy): return enem.current_health > 0)
