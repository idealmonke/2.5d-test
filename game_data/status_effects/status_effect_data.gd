class_name StatusEffectData
extends Resource

@export var name: String
@export var desc: String
@export var id: int
@export var display_image: Texture2D
@export var status_type: COMMON_ENUMS.STATUS_TYPE

## APPLIES WHEN STATUS IS ACTIVE
@export var abilities: Dictionary[COMMON_ENUMS.TIMING, StatusEffectAbility]

## APPLIES WHEN STATUS IS PASSIVE
@export var stats_calculations: Dictionary[COMMON_ENUMS.PLAYER_STATS, StatusEffectCalculation]
