class_name longsword_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : TargetingInfo) -> void:
	BattleController.draw_card()
	var damage = Damage.new()
	damage.add_damage(BattleController.data.hand.get_hand_size()*2, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.data.player
	damage.is_strike = true
	await targets.single_target().take_damage(damage)
