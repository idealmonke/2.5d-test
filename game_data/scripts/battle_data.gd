class_name BattleData
extends RefCounted

var enemies: Array[Enemy]
var hand: SkillCardHand
var library: SkillCardLibrary
var discard: SkillCardDiscard
var player: BattlePlayerData

## Where to place each enemy sprite on the screen, for when creating enemies. 
## Index of the vector matches index of the enemy. 
var enemy_locations: Array[Vector2]

func _init() -> void:
	enemy_locations = [Vector2(480, 200), Vector2(960, 200), Vector2(1440, 200)]
