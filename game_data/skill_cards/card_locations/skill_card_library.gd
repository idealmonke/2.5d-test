class_name SkillCardLibrary
extends Node2D

var library: Array[SkillCard] = []
var shuffle_func: Callable

func _ready() -> void:
	shuffle_func = _unweighted_shuffle

func load_cards_from_party(party: PartyData) -> void:
	for i in range(party.card_ids):
		var data := SkillCardRegistry.get_card_data(party.card_ids[i])
		var card := SkillCard.new()
		card.initialize_card(data)
		library.append(card)
	self.shuffle()
	
func get_size() -> int:
	return library.size()

func pop_top_card() -> SkillCard:
	if library.is_empty():
		return null
	return	library.pop_front()

func shuffle() -> void:
	library.shuffle()
	#shuffle_func.call()
	
func push_to_top(card: SkillCard) -> void:
	library.push_front(card)

func push_each(cards: Array[SkillCard]) -> void:
	library.append_array(cards)
	library.shuffle()

func is_empty() -> bool:
	return library.is_empty()

func _unweighted_shuffle() -> void:
	library.shuffle()
	
