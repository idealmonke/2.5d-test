class_name SkillCardDiscard
extends Area2D

var discard: Array[SkillCard] = []
var detection: Area2D
var display_grid: SkillCardDisplayGrid

func _ready() -> void:
	connect("input_event", _on_input_event)
	call_deferred("_late_ready")
	
func _late_ready() -> void:
	display_grid = get_parent().get_node("skill_card_display_grid")
	
func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and BattleController.current_state == COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING and !discard.is_empty():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_display_discard()

func get_size() -> int:
	return discard.size()

func pop_front_card() -> SkillCard:
	return discard.pop_front()

func pop_card(card: SkillCard) -> SkillCard:
	var index := discard.find(card)
	if index == -1:
		return null
	return discard.pop_at(index)

func add_card(card: SkillCard) -> void:
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD
	discard.push_front(card)
	
func add_many(cards: Array) -> void:
	discard.append_array(cards)

func is_empty() -> bool:
	return discard.is_empty()

func pop_exhausted() -> Array[SkillCard]:
	var exhausted_cards: Array[SkillCard] = []
	for card in discard.duplicate():
		if card.exhausted:
			exhausted_cards.push_front(pop_card(card))
	return exhausted_cards
			
func exhaust_cards() -> void:
	for card in discard:
		card.exhausted = true

func _display_discard() -> void:
	BattleController._change_state(COMMON_ENUMS.BATTLE_STATE.DISPLAYING)
	display_grid.load_cards(discard, _close_display, "Discard")

func _custom_display_discard(custom_func: Callable) -> void:
	BattleController._change_state(COMMON_ENUMS.BATTLE_STATE.DISPLAYING)
	display_grid.load_cards(discard, custom_func, "Discard")

func _close_display(card: SkillCard) -> SkillCard:
	BattleController._change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING)
	return card
