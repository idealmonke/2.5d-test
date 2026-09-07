class_name longsword_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute(targets : targeting_info) -> void:
	BattleController.draw_card()
	var damage = Damage.new()
	damage.add_damage(BattleController.data.hand.get_hand_size()*2, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	damage.source = BattleController.data.player
	targets.single_target().take_damage(damage)
