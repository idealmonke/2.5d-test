class_name status_effect_data
extends Resource

@export var name: String
@export var desc: String
@export var id: int
@export var display_image: Texture2D

## APPLIES WHEN STATUS IS ACTIVE
@export var ability: status_effect_ability

## APPLIES WHEN STATUS IS PASSIVE
@export var calculation: status_effect_calculation

## APPLIES WHEN STATUS IS ACTIVE
@export var timing: COMMON_ENUMS.TIMING
@export var status_type: COMMON_ENUMS.STATUS_TYPE

## APPLIES WHEN STATUS IS PASSIVE
@export var stat_affected: COMMON_ENUMS.PLAYER_STATS
