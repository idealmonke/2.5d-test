class_name charge_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : TargetingInfo) -> void:
	BattleController.draw_card()
	
	for i in range(BattleController.cards_drawn_for_turn - BattleController.data.player.hand_size):
		var damage = Damage.new()
		damage.is_strike = true
		damage.source = BattleController.data.player
		damage.add_damage(3, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
		await targets.single_target().take_damage(damage)
