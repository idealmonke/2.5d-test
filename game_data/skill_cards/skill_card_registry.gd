class_name skill_card_registry
extends RefCounted

static var skill_card_data_path: String = "res://game_data/skill_cards/skill_cards_data/"

const CARD_DB: Dictionary = {
	1001: "longsword",
	1002: "rondel_dagger",
	3004: "scavenge",
	1003: "brief_respite",
	7001: "molotov"
}

static func get_card_data(ID: int) -> skill_card_data:
	assert(CARD_DB.has(ID), "Card ID (%s) not found in registry" % ID)
	return load(skill_card_data_path+CARD_DB[ID]+".tres")

static func save_data(data: skill_card_data) -> void:
	var ID : int = data.card_id;
	
	assert(CARD_DB.has(ID), "Card ID (%s) not found in registry" % ID)
	ResourceSaver.save(data, skill_card_data_path+CARD_DB[ID]+".tres")
