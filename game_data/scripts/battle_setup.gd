extends Node

func _ready() -> void:
	
	BattleController.setup(self, $discard, $hand, $library, $end_turn)
	
	# TEMPORARY TESTING CODE
	BattleController.data.library.push_to_top($card_storage/skill_card)
	BattleController.data.library.push_to_top($card_storage/skill_card2)
	BattleController.data.library.push_to_top($card_storage/skill_card3)
	BattleController.data.library.push_to_top($card_storage/skill_card4)
	BattleController.data.library.push_to_top($card_storage/skill_card5)
	$card_storage/skill_card/card_name.text = "Gooby"
	$card_storage/skill_card2/card_name.text = "Chungus"
	$card_storage/skill_card3/card_name.text = "Bingus"
	$card_storage/skill_card4/card_name.text = "Wakka Wakka"
	$card_storage/skill_card5/card_name.text = "Looney"
	for card in BattleController.data.library.library:
		card.set_back()
	# TEMPORARY TESTING CODE
	
	BattleController._change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP)
