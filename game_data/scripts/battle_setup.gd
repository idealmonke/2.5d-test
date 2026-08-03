extends Node

const SKILL_CARD_SCENE = preload("res://game_data/skill_cards/skill_card.tscn")
const BATTLE_CONFIG = preload("res://game_data/battle_config.tres")

func _ready() -> void:
	
	BattleController.setup(self, $discard, $hand, $library, $end_turn)
	
	_init_player_cards()
	
	BattleController._change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP)


func _on_end_turn_pressed() -> void:
	BattleController._end_turn()

func _init_player_cards() -> void:
	var party: Party = BATTLE_CONFIG.party
	var cards: Array[int] = party.card_ids
	
	for card in cards:
		var data: card_data = skill_card_registry.get_card_data(card)
		var card_instance: skill_card = SKILL_CARD_SCENE.instantiate()
		$card_storage.add_child(card_instance)
		card_instance.initialize_card(data)
		BattleController.data.library.push_to_top(card_instance)
	BattleController.data.library.shuffle()
	
