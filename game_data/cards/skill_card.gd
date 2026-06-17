class_name skill_card
extends Area2D

# Card Details
var card_name: String
var card_id: int
var card_art: Texture2D
var stamina_cost: int
var mana_cost: int
var ability_desc: String
var ability: Callable
var classes: Array[String]

# Child Node References
var card_name_label
var card_ability_label
var card_mana_cost_label
var card_stamina_cost_label

# Card Control Data
var data: battle_data
var interactable_state: COMMON_ENUMS.INTERACT_STATE:
	set(value):
		interactable_state = value
		_update_pickable()
var drag_offset: Vector2
var location_offset: Vector2
var rotation_offset: float
var hand_location: Vector2
var discard_location: Vector2
var library_location: Vector2
var quick_lerp: int = 40
var slow_lerp: int = 20
var prev_state: COMMON_ENUMS.INTERACT_STATE

# Animation Variables
var hover_offset: Vector2 = Vector2(0,-50)
@export var hover_z_index: int = 20
var old_z_index: int
var old_position: Vector2
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	
	# TEMPORARY VARIABLES
	hand_location = Vector2(screen_size.x / 2.0, screen_size.y - 150)
	discard_location = Vector2(200,screen_size.y - 200)
	library_location = Vector2(screen_size.x - 200,200)
	
	connect("input_event", _on_input_event)
	$hover_area.connect("mouse_entered", _on_mouse_entered)
	$hover_area.connect("mouse_exited", _on_mouse_exited)
	
	interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
	
	card_name_label = $card_name
	card_ability_label = $card_ability
	card_mana_cost_label = $mana_cost
	card_stamina_cost_label = $stamina_cost
	_update_ability_text()
	
	call_deferred("_late_setup")

func _late_setup() -> void:
	# TEMPORARY UNTIL INSTANCING
	data = get_parent().get_parent().data
	
func _process(delta: float) -> void:
	
	match interactable_state:
		COMMON_ENUMS.INTERACT_STATE.DRAGGING:
			var target = get_global_mouse_position() + drag_offset
			global_position = global_position.lerp(target, quick_lerp  * delta)
		COMMON_ENUMS.INTERACT_STATE.HAND:
			var target = hand_location + location_offset + hover_offset
			if global_position.distance_to(target) > 1:
				global_position = global_position.lerp(target, slow_lerp * delta)
			else:
				global_position = target
			rotation = lerp_angle(rotation, rotation_offset, slow_lerp * delta)
		COMMON_ENUMS.INTERACT_STATE.LIBRARY:
			if global_position.distance_to(library_location) > 1:
				global_position = global_position.lerp(library_location, slow_lerp * delta)
			else:
				global_position = library_location
		COMMON_ENUMS.INTERACT_STATE.DISCARD:
			if global_position.distance_to(discard_location) > 1:
				global_position = global_position.lerp(discard_location, slow_lerp * delta)
			else:
				global_position = discard_location
			
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
	# Change to actual propertes once they initialize correctly
	card_name_label.text = "card_name"
	card_ability_label.text = "This is the cards ability."
	card_stamina_cost_label.text = "3"
	card_mana_cost_label.text = "0"
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				data.hand.register_pickup(self)
				
func _on_mouse_entered() -> void:
	_player_highlight_card()
	
func _on_mouse_exited() -> void:
	_player_unhighlight_card()

func _input(event: InputEvent) -> void:
	if interactable_state == COMMON_ENUMS.INTERACT_STATE.DRAGGING:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				interactable_state = prev_state

func _update_pickable() -> void:
	if interactable_state == COMMON_ENUMS.INTERACT_STATE.HAND:
		input_pickable = true
	else:
		input_pickable = false

func _player_highlight_card() -> void:
	old_z_index = z_index
	z_index = hover_z_index
	hover_offset = Vector2(0,-50)

func _player_unhighlight_card() -> void:
	z_index = old_z_index
	hover_offset = Vector2(0,0)

func begin_drag() -> void:
	if interactable_state != COMMON_ENUMS.INTERACT_STATE.DRAGGING:
		prev_state = interactable_state
	interactable_state = COMMON_ENUMS.INTERACT_STATE.DRAGGING
	drag_offset = global_position - get_global_mouse_position()
	
	
	
