class_name enemy_data
extends Resource

@export var enemy_id: int

@export var enemy_name: String
@export var max_health: int
@export var max_stamina: int
@export var max_mana: int
@export var mana_regen: int
@export var card_ids : Array[int]
@export var hand_size : int

var deck: Array[enemy_card]

@export var art: Texture2D
