class_name EnemyData
extends Resource

@export var enemy_id: int

@export var enemy_name: String
@export var max_health: int
@export var max_stamina: int
@export var max_mana: int
@export var mana_regen: int
@export var card_ids : Array[int]
@export var hand_size : int
@export var defense : Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]

var deck: Array[EnemyCard]

@export var art: Texture2D
@export var art_scaling: float = 1.0

@export var tags: Array[String] = []
