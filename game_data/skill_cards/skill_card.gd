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

# Card Sprites
var card_main_frame: Sprite2D

# Child Node References
var card_name_label: Label
var card_ability_label: Label
var card_mana_cost_label: Label
var card_stamina_cost_label: Label

# Card Control Data
var controller: battle_controller
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
var misc_location: Vector2
@export var quick_lerp: int = 40
@export var slow_lerp: int = 20
@export var rotate_lerp: int = 12
var prev_state: COMMON_ENUMS.INTERACT_STATE

# Animation Variables
@export var hover_z_index: int = 20
var target_rotation: float
var hover_offset: Vector2 = Vector2.ZERO
var old_z_index: int
var old_position: Vector2
var old_tilt: float = 0.0
var screen_size: Vector2
var exhaust_material: ShaderMaterial

# Card State
var exhausted: bool:
	set(value):
		exhausted = value
		if exhausted == true:
			exhaust_material.set_shader_parameter("is_exhausted", exhausted)
			exhaust_material.set_shader_parameter("transition_start_time", Time.get_ticks_msec() / 1000.0)
		else:
			exhaust_material.set_shader_parameter("is_exhausted", exhausted)
			exhaust_material.set_shader_parameter("transition_start_time", (Time.get_ticks_msec() / 1000.0) - 10.0)
			
# Subscribers
var select_subscribers: Dictionary

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	
	# TEMPORARY VARIABLES
	hand_location = Vector2(screen_size.x / 2.0, screen_size.y - 150)
	discard_location = Vector2(200,screen_size.y - 200)
	library_location = Vector2(screen_size.x - 200,200)
	
	connect("input_event", _on_input_event)
	$hover_area.connect("mouse_entered", _on_mouse_entered)
	$hover_area.connect("mouse_exited", _on_mouse_exited)
	
	card_main_frame = $Sprite2D
	exhaust_material = ShaderMaterial.new() 
	exhaust_material.shader = load("res://game_data/skill_cards/card_art/exhausted_card.gdshader")
	card_main_frame.material = exhaust_material
	
	interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
	
	card_name_label = $card_name
	card_ability_label = $card_ability
	card_mana_cost_label = $mana_cost
	card_stamina_cost_label = $stamina_cost
	_update_text()

	
func _process(delta: float) -> void:
	
	match interactable_state:
		COMMON_ENUMS.INTERACT_STATE.DRAGGING:
			var target = get_global_mouse_position() + drag_offset
			global_position = global_position.lerp(target, quick_lerp  * delta)
			rotation = lerp_angle(rotation, target_rotation, rotate_lerp * delta)
		COMMON_ENUMS.INTERACT_STATE.HAND:
			var target = hand_location + location_offset + hover_offset
			if global_position.distance_to(target) > 1:
				global_position = global_position.lerp(target, slow_lerp * delta)
			else:
				global_position = target
			rotation = lerp_angle(rotation, rotation_offset, rotate_lerp * delta)
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
		COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY:
			if global_position.distance_to(misc_location) > 1:
				global_position = global_position.lerp(misc_location, slow_lerp * delta)
			else:
				global_position = misc_location
			
func initialize_card(resource_data: skill_card_data) -> void:
	card_name = resource_data.card_name
	card_id = resource_data.card_id
	card_art = resource_data.card_art
	mana_cost = resource_data.mana_cost
	ability_desc = resource_data.ability_desc
	ability = resource_data.card_ability.execute
	classes = resource_data.card_classes
	_update_text()
	

func begin_drag() -> void:
	if interactable_state != COMMON_ENUMS.INTERACT_STATE.DRAGGING:
		prev_state = interactable_state
	interactable_state = COMMON_ENUMS.INTERACT_STATE.DRAGGING
	self.old_tilt = self.target_rotation
	self.target_rotation = 0.0
	drag_offset = global_position - get_global_mouse_position()
	
func set_back() -> void:
	card_main_frame.texture = load("res://game_data/skill_cards/card_art/Card_Back.png")
	card_name_label.hide()
	card_mana_cost_label.hide()
	card_stamina_cost_label.hide()
	card_ability_label.hide()
	
func set_front() -> void:
	card_main_frame.texture = load("res://game_data/skill_cards/card_art/Blank_Card.png")
	card_name_label.show()
	card_mana_cost_label.show()
	card_stamina_cost_label.show()
	card_ability_label.show()

func set_exhausted(value: bool) -> void:
	exhausted = value
	
func set_input_pickable(value: bool) -> void:
	input_pickable = value
	
func add_select_subscriber(subscriber: Callable, key: String) -> void:
	select_subscribers[key] = subscriber
	
func remove_select_subscriber(key: String) -> void:
	select_subscribers.erase(key)
	
func _report_select() -> void:
	for subscriber in select_subscribers.values():
		subscriber.call(self)

func _update_text() -> void:
	# Change to actual propertes once they initialize correctly
	card_name_label.text = "card_name"
	card_ability_label.text = "This is the cards ability."
	card_stamina_cost_label.text = "3"
	card_mana_cost_label.text = "0"
	
## Handles Mouse Down Presses
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if BattleController.current_state == COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING and event.pressed:
				BattleController.data.hand.register_pickup(self)
				return
			if BattleController.current_state == COMMON_ENUMS.BATTLE_STATE.DISPLAYING and event.pressed:
				_report_select()
				return

func _on_mouse_entered() -> void:
	_player_highlight_card()
	
func _on_mouse_exited() -> void:
	_player_unhighlight_card()

func _input(event: InputEvent) -> void:
	if interactable_state == COMMON_ENUMS.INTERACT_STATE.DRAGGING:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				interactable_state = prev_state
				self.target_rotation = old_tilt

func _update_pickable() -> void:
	if interactable_state == COMMON_ENUMS.INTERACT_STATE.HAND or interactable_state == COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY:
		set_input_pickable(true)
	else:
		set_input_pickable(false)

func _player_highlight_card() -> void:
	z_index += 5
	hover_offset = Vector2(0,-50)

func _player_unhighlight_card() -> void:
	z_index -= 5
	hover_offset = Vector2(0,0)
