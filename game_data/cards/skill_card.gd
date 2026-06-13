class_name skill_card
extends Area2D

enum INTERACT_STATE {HAND, LIBRARY, DISCARD, DRAGGING, PLAYING}

# Card Details
var card_name: String
var card_id: int
var card_art: Texture2D
var mana_cost: int
var ability_desc: String
var ability: Callable
var classes: Array[String]

# Child Node References
var card_name_label
var card_ability_label

# Card Control Data
var interactable_state: INTERACT_STATE
var drag_offset: Vector2
var hand_location: Vector2
var quick_lerp: int = 40
var slow_lerp: int = 20

func _ready() -> void:
	# TEMPORARY VARIABLES
	hand_location = Vector2(500,500)
	
	input_pickable = true
	connect("input_event", _on_input_event)
	
	card_name_label = $card_name
	card_ability_label = $card_ability
	_update_ability_text()
	
func _process(delta: float) -> void:
	if interactable_state == INTERACT_STATE.DRAGGING:
		var target = get_global_mouse_position() + drag_offset
		global_position = global_position.lerp(target, quick_lerp  * delta)
	
	match interactable_state:
		INTERACT_STATE.DRAGGING:
			var target = get_global_mouse_position() + drag_offset
			global_position = global_position.lerp(target, quick_lerp  * delta)
		INTERACT_STATE.HAND:
			global_position = global_position.lerp(hand_location, slow_lerp * delta)

func initialize_card(data: skill_card_data) -> void:
	card_name = data.card_name
	card_id = data.card_id
	card_art = data.card_art
	mana_cost = data.mana_cost
	ability_desc = data.ability_desc
	ability = data.card_ability.execute
	classes = data.card_classes
	_update_ability_text()
	
func _update_ability_text() -> void:
	card_name_label.text = "card_name"
	card_ability_label.text = "This is the cards ability."
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Pick up card
				interactable_state = INTERACT_STATE.DRAGGING
				drag_offset = global_position - get_global_mouse_position()
			else:
				# Release card
				interactable_state = INTERACT_STATE.HAND
	
