class_name scavenge_ability
extends skill_card_ability

var returned_card: skill_card = null

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE
	
func execute(targets : targeting_info) -> void:
	BattleController.dredge_card()
	BattleController.data.discard._custom_display_discard(return_card)
	await BattleController.display_signal
	returned_card.interactable_state = COMMON_ENUMS.INTERACT_STATE.HAND
	BattleController.data.discard.pop_card(returned_card)
	BattleController.data.hand.add_card(returned_card)
	returned_card = null
	
func return_card(card: skill_card) -> void:
	returned_card = card
		
