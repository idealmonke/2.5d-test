class_name EnemyCard
extends Area2D

# Card Details
var card_name: String
var card_id: int
var card_art: Texture2D
var stamina_cost: int
var mana_cost: int
var ability_desc: String
var ability: EnemyCardAbility

# Card Sprites
var card_main_frame: Sprite2D

# Child Node References
var card_name_label: Label
var card_ability_label: Label
var card_stamina_cost_label: Label
var card_mana_cost_label: Label

# Card Control Data
var interactable_state: COMMON_ENUMS.ENEMY_CARD_STATE
var hand_location: Vector2
var library_location: Vector2
@export var quick_lerp: int = 40
@export var slow_lerp: int = 20
@export var rotate_lerp: int = 12
var location_offset: Vector2
var playing_target: Vector2
var rotation_offset : float = 0


func _ready() -> void:	
	card_main_frame = $Sprite2D
	
	change_state(COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY)
	
	card_name_label = $card_name
	card_ability_label = $card_ability
	card_stamina_cost_label = $stamina_cost
	card_mana_cost_label = $mana_cost
	
	_update_text()
	
func change_state(state : COMMON_ENUMS.ENEMY_CARD_STATE):
	interactable_state = state
	if(state==COMMON_ENUMS.ENEMY_CARD_STATE.PLAYING):
		z_index = 100
		_create_tween(playing_target, 0)
	if(state==COMMON_ENUMS.ENEMY_CARD_STATE.HAND):
		z_index = 90
		_create_tween(hand_location + location_offset, rotation_offset)
	if(state==COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY):
		z_index = 80
		
		_create_tween(library_location, 0)

func _create_tween(pos : Vector2, rot: float):
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "position", pos, 0.2)
	tween.parallel().tween_property(self, "rotation", rot, 0.2)

func set_back() -> void:
	card_main_frame.texture = load("res://game_data/card_frames/Back_Enemy.png")
	card_name_label.hide()
	card_mana_cost_label.hide()
	card_stamina_cost_label.hide()
	card_ability_label.hide()
	
	
func set_front() -> void:
	card_main_frame.texture = load("res://game_data/card_frames/Front_Card.png")
	card_name_label.show()
	card_mana_cost_label.show()
	card_stamina_cost_label.show()
	card_ability_label.show()

func _update_text() -> void:
	card_name_label.text = card_name
	card_ability_label.text = ability_desc
	card_stamina_cost_label.text = str(stamina_cost)
	card_mana_cost_label.text = str(mana_cost)

func initialize_card(resource_data: EnemyCardData) -> void:
	#TEMP SCALE
	scale = Vector2(0.5,0.5)
	
	card_name = resource_data.card_name
	card_id = resource_data.card_id
	card_art = resource_data.card_art
	mana_cost = resource_data.mana_cost
	ability_desc = resource_data.ability_desc
	
	ability = resource_data.card_ability
	
	stamina_cost = resource_data.stamina_cost
	
	#HARDCODED LOCATIONS
	library_location = Vector2(-200,0)
	hand_location = Vector2(-100,400)
	playing_target  =  Vector2(0,500)
	
	change_state(COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY)
	
	_update_text()
	set_back()
