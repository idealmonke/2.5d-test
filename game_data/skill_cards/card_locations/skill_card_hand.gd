class_name skill_card_hand
extends Node2D

var hand: Array[skill_card] = []
var pending_pickup: Array[skill_card] = []

@export var card_width: int = 200
@export var max_hand_width: int = 550
@export var arc_height: int = 50
@export var max_tilt_degrees: int = 15

func add_card(card: skill_card) -> void:
	hand.append(card)
	_set_hand_offset()
	
func get_hand_size() -> int:
	return hand.size()

func pop_card(card: skill_card) -> skill_card:
	var index := hand.find(card)
	if index == -1:
		return null
	var popping = hand.pop_at(index)
	_reset_offset(popping)
	_set_hand_offset()
	return popping
	
func pop_front() -> skill_card:
	if hand.is_empty():
		return
	return pop_card(hand[0])
	
func pop_each() -> Array:
	var old_hand := hand.duplicate()
	hand.clear()
	for card in old_hand:
		_reset_offset(card)
	return old_hand

func _process(delta: float) -> void:
	_resolve_hover()

func is_empty() -> bool:
	return hand.is_empty()

func _resolve_hover() -> void:
	var hovered : skill_card;
	
	for card in hand:
		if(card.hover):
			hovered = card
		card.player_unhighlight_card()
	
	if hovered:
		hovered.player_highlight_card()

func register_pickup(card: skill_card) -> void:
	pending_pickup.append(card)
	call_deferred("_resolve_pickup")
	
func _resolve_pickup() -> void:
	if pending_pickup.is_empty():
		return
	pending_pickup.sort_custom(func(a, b): return hand.find(a) > hand.find(b))
	var winner = pending_pickup[0]
	winner.begin_drag()
	pending_pickup.clear()
	
func _reset_offset(card: skill_card) -> void:
		card.location_offset = Vector2.ZERO
		card.rotation_offset = 0.0
		card.rotation = 0.0

func _set_hand_offset() -> void:
	var count = hand.size()
	
	if count == 0:
		return
	if count == 1:
		hand[0].location_offset = Vector2.ZERO
		hand[0].rotation_offset = 0.0
		return
		
	var ideal_total_width = (count - 1) * card_width # Distance apart if no overlap
	var spacing = card_width # Gap between card centers
	if ideal_total_width > max_hand_width:
		spacing = max_hand_width / (count - 1)

	var total_width = spacing * (count - 1) # Actual width used
	var start_x = -total_width / 2.0 # Leftmost card x

	for index in range(count):
		var t = index / float(count - 1)  # Position as a fraction, 0 -> 1
		var centered_t = t - 0.5          # Normalized t, -0.5 to 0.5

		var x = start_x + spacing * index
		var y = arc_height * (centered_t * centered_t) * 3.0 - arc_height
		var tilt = deg_to_rad(max_tilt_degrees * centered_t * 1.2)

		hand[index].location_offset = Vector2(x, y)
		hand[index].rotation_offset = tilt
		hand[index].z_index = index
		hand[index].old_z_index = index
