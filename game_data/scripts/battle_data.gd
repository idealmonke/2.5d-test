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

#func load_enemies(enemy_ids: Array[int]) -> void:
	#for index in range(3):
		#if enemy_ids[index] is int:
			#var enem: enemy # CREATE ENEMY HERE
			#enem.initialize_data(EnemyRegistry.get_enemy_data(enemy_ids[index]))
			#pass

func load_deck(skill_card_ids: Array[int]) -> void:
	print("grippy ty forgot about this silly function")
	for id in skill_card_ids:
		var new_card: SkillCard # CREATE CARD HERE
		new_card.initialize_card(SkillCardRegistry.get_card_data(id))
		hand.add_card(new_card)

func load_player(party_id: int) -> void:
	var party: Party # Load party here
	player.initialize_player(party)
