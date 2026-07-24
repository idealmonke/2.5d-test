class_name battle_data
extends RefCounted

var enemies: Array[enemy]
var hand: skill_card_hand
var library: skill_card_library
var discard: skill_card_discard
var player: battle_player_data

## Where to place each enemy sprite on the screen, for when creating enemies. 
## Index of the vector matches index of the enemy. 
var enemy_locations: Array[Vector2] = [Vector2(480, 300), Vector2(960, 300), Vector2(1440, 300)]

func _init() -> void:
	pass

func load_enemies(enemy_ids: Array[int]) -> void:
	for index in range(3):
		if enemy_ids[index] is int:
			var enem: enemy # CREATE ENEMY HERE
			enem.initialize_data(enemy_registry.get_enemy_data(enemy_ids[index]))
			pass

func load_deck(skill_card_ids: Array[int]) -> void:
	for id in skill_card_ids:
		var new_card: skill_card # CREATE CARD HERE
		new_card.initialize_card(skill_card_registry.get_card_data(id))
		hand.add_card(new_card)

func load_player(party_id: int) -> void:
	var party: Party # Load party here
	player.initialize_player(party)
