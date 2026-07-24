class_name enemy_card_registry
extends RefCounted

static var enemy_card_data_path: String = "res://game_data/enemies/card_data/"

const CARD_DB: Dictionary = {
	1: "bite",
	2: "knaw"
}

static func get_card_data(ID: int) -> enemy_card_data:
	assert(CARD_DB.has(ID), "Card ID (%s) not found in enemy card registry" % ID)
	return load(enemy_card_data_path+CARD_DB[ID]+".tres")

static func save_data(data: enemy_card_data) -> void:
	var ID = data.card_id;
	
	assert(CARD_DB.has(ID), "Card ID (%s) not found in registry" % ID)
	ResourceSaver.save(data, enemy_card_data_path+CARD_DB[ID]+".tres")
