class_name skill_card_discard
extends Area2D

var discard: Array[skill_card] = []
var detection: Area2D
var display_grid: skill_card_display_grid
var controller: battle_controller

func _ready() -> void:
	connect("input_event", _on_input_event)
	call_deferred("_late_ready")
	
func _late_ready() -> void:
	display_grid = get_parent().get_node("skill_card_display_grid")
	controller = get_parent()
	
func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and controller.global_state == COMMON_ENUMS.GLOBAL_CARD_STATE.PLAYING and !discard.is_empty():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_display_discard()

func get_size() -> int:
	return discard.size()

func pop_front_card() -> skill_card:
	return discard.pop_front()

func pop_card(card: skill_card) -> skill_card:
	var index := discard.find(card)
	if index == -1:
		return null
	return discard.pop_at(index)

func add_card(card: skill_card) -> void:
	discard.push_front(card)
	
func add_many(cards: Array) -> void:
	discard.append_array(cards)

func is_empty() -> bool:
	return discard.is_empty()

func pop_exhausted() -> Array[skill_card]:
	var exhausted_cards: Array[skill_card]
	for card in discard:
		if card.exhausted:
			exhausted_cards.push_front(pop_card(card))
	return exhausted_cards
			
func exhaust_cards() -> void:
	for card in discard:
		card.exhausted = true

func _display_discard() -> void:
	controller.global_state = COMMON_ENUMS.GLOBAL_CARD_STATE.DISPLAYING
	display_grid.load_cards(discard, _close_display, "Discard")

func _close_display(card: skill_card) -> void:
	controller.global_state = COMMON_ENUMS.GLOBAL_CARD_STATE.PLAYING
