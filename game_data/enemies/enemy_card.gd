class_name enemy_card
extends Area2D

# Card Details
var card_name: String
var card_id: int
var card_art: Texture2D
var stamina_cost: int
var mana_cost: int
var ability_desc: String
var ability: Callable

# Card Sprites
var card_main_frame: Sprite2D

# Child Node References
var card_name_label: Label
var card_ability_label: Label
var card_stamina_cost_label: Label
var card_mana_cost_label: Label

# Card Control Data
var controller: battle_controller
var data: battle_data
var interactable_state: COMMON_ENUMS.ENEMY_CARD_STATE
var hand_location: Vector2
var library_location: Vector2
@export var quick_lerp: int = 40
@export var slow_lerp: int = 20
@export var rotate_lerp: int = 12
var location_offset: Vector2
var playing_target: Vector2

var rotation_offset

# tyler's bleh variables
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	
	#TEMP
	#hand_location = Vector2(screen_size.x / 2.0, screen_size.y - 150)
	#library_location = Vector2(screen_size.x - 200,200)
	
	card_main_frame = $Sprite2D
	
	interactable_state = COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY
	
	card_name_label = $card_name
	card_ability_label = $card_ability
	card_stamina_cost_label = $stamina_cost
	card_mana_cost_label = $mana_cost
	
	_update_text()
	
	call_deferred("_late_setup")

func _process(delta: float) -> void:
	match interactable_state:
		COMMON_ENUMS.ENEMY_CARD_STATE.PLAYING:
			z_index = 15
			
			if global_position.distance_to(playing_target) > 1:
				global_position = global_position.lerp(playing_target, slow_lerp * delta)
			else:
				global_position = playing_target
			
			rotation = 0
		COMMON_ENUMS.ENEMY_CARD_STATE.HAND:
			z_index = 10
			
			var target = hand_location + location_offset
			if global_position.distance_to(target) > 1:
				global_position = global_position.lerp(target, slow_lerp * delta)
			else:
				global_position = target
			
			rotation = lerp_angle(rotation, rotation_offset, rotate_lerp * delta)
		COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY:
			z_index = 0
			
			if global_position.distance_to(library_location) > 1:
				global_position = global_position.lerp(library_location, slow_lerp * delta)
			else:
				global_position = library_location
			
			rotation = 0

func _late_setup() -> void:
	#intialize controller and data
	pass

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

func _update_text() -> void:
	# Change to actual propertes once they initialize correctly
	card_name_label.text = card_name
	card_ability_label.text = ability_desc
	card_stamina_cost_label.text = str(stamina_cost)
	card_mana_cost_label.text = str(mana_cost)

func initialize_card(resource_data: enemy_card_data, idx : int) -> void:
	#temp (hi tyler >:D)
	scale = Vector2(0.5,0.5)
	
	card_name = resource_data.card_name
	card_id = resource_data.card_id
	card_art = resource_data.card_art
	mana_cost = resource_data.mana_cost
	ability_desc = resource_data.ability_desc
	#ability = resource_data.card_ability.execute
	stamina_cost = resource_data.stamina_cost
	
	#temp as well ig
	library_location = BattleController.data.enemy_locations[idx]+Vector2(-200,0)
	hand_location = BattleController.data.enemy_locations[idx]+Vector2(-100,400)
	playing_target  =  BattleController.data.enemy_locations[idx]+Vector2(0,500)
	
	_update_text()
	set_back()
