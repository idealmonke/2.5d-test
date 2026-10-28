class_name CharacterDataRegistry
extends RefCounted

static var character_data_path: String = "res://game_data/characters/character_data/"

const CHARACTER_DB: Dictionary = {
	1: "starter_berserker",
	2: "starter_alchemist",
	3: "starter_cleric",
	4: "starter_knave",
	5: "starter_warrior",
	6: "starter_shaman",
	7: "starter_occultist",
	8: "starter_mage",
}

static func get_character_data(ID: int) -> CharacterData:
	assert(CHARACTER_DB.has(ID), "Character ID (%s) not found in character registry" % ID)
	return load(character_data_path+CHARACTER_DB[ID]+".tres")

static func save_data(data: CharacterData) -> void:
	var ID : int = data.id;
	
	assert(CHARACTER_DB.has(ID), "Character ID (%s) not found in registry" % ID)
	ResourceSaver.save(data, character_data_path+CHARACTER_DB[ID]+".tres")

static func calculate_stats(characters: Array[CharacterData]) -> Dictionary:
	var stats = {
		"max_health": 0,
		"max_mana": 0,
		"mana_regen": 0,
		"max_stamina": 0,
		"shield_retention": 0.0,
		"handsize": 0,
		"defense": {} as Dictionary[int, int],
		"deck_slots": 0
	}

	for character in characters:
		stats.max_health += character.hp
		stats.max_mana += character.max_mana
		stats.mana_regen += character.mana_regen
		stats.max_stamina += character.stamina
		stats.shield_retention += character.shield_retention
		stats.handsize += character.hand_size
		stats.deck_slots += character.deck_slots

		for key in character.defense:
			if stats.defense.has(key):
				stats.defense[key] += character.defense[key]
			else:
				stats.defense[key] = character.defense[key]

	return stats
