class_name CharacterRegistry
extends RefCounted

static var character_data_path: String = "res://game_data/characters/character_data/"

const CHARACTER_DB: Dictionary = {
	1: "starter_berserker",
	2: "starter_alchemist",
	3: "starter_cleric",
	4: "starter_knave",
}

static func get_character_data(ID: int) -> CharacterData:
	assert(CHARACTER_DB.has(ID), "Character ID (%s) not found in character registry" % ID)
	return load(character_data_path+CHARACTER_DB[ID]+".tres")

static func save_data(data: CharacterData) -> void:
	var ID : int = data.id;
	
	assert(CHARACTER_DB.has(ID), "Character ID (%s) not found in registry" % ID)
	ResourceSaver.save(data, character_data_path+CHARACTER_DB[ID]+".tres")
