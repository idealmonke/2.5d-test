class_name scavenge_ability
extends SkillCardAbility

var returned_card: SkillCard = null

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE
	
func execute(targets : TargetingInfo) -> void:
	BattleController.dredge_card()
	if(BattleController.data.discard.discard.size()==0):
		return
	BattleController.data.discard._custom_display_discard(return_card)
	await BattleController.display_signal
	returned_card.interactable_state = COMMON_ENUMS.INTERACT_STATE.HAND
	BattleController.data.discard.pop_card(returned_card)
	BattleController.data.hand.add_card(returned_card)
	returned_card = null

func return_card(card: SkillCard) -> void:
	returned_card = card
		
