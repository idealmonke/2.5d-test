class_name longsword_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE

func execute( targets : targeting_info) -> void:
	BattleController.draw_card()
	var damage = Damage.new()
	damage.set_amount(BattleController.data.hand.get_hand_size()*2)
	damage.set_type(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	targets.single_target().take_damage(damage)
