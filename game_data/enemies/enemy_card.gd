class_name enemy_card
extends Area2D

var card_name: String
var card_id: int
var card_art: Texture2D
var stamina_cost: int
var mana_cost: int
var ability_desc: String
var ability: Callable

# Card Control Data
var controller: battle_controller
var data: battle_data
var interactable_state: COMMON_ENUMS.ENEMY_CARD_STATE
var hand_location: Vector2
var library_location: Vector2
@export var quick_lerp: int = 40
@export var slow_lerp: int = 20
@export var rotate_lerp: int = 12

func _ready() -> void:
	call_deferred("_late_setup")
	
func _late_setup() -> void:
	pass
