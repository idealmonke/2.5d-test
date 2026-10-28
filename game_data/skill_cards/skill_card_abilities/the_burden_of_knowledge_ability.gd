class_name the_burden_of_knowledge_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	var hand_size: int = BattleController.data.hand.get_hand_size()
	var previous_cards: Array = BattleController.data.hand.pop_each()
	for card in previous_cards:
		BattleController.discard_card(card)
	for i in range(hand_size):
		BattleController.draw_card()
