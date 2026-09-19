class_name EnemyCardRegistry
extends RefCounted

static var enemy_card_data_path: String = "res://game_data/enemies/card_data/"

const CARD_DB: Dictionary = {
	1: "bite",
	2: "claws",
	3: "block",
	4: "aching_screech",
	5: "storm_of_feathers"
}

static func get_card_data(ID: int) -> EnemyCardData:
	assert(CARD_DB.has(ID), "Card ID (%s) not found in enemy card registry" % ID)
	return load(enemy_card_data_path+CARD_DB[ID]+".tres")

static func save_data(data: EnemyCardData) -> void:
	var ID : int = data.card_id;
	
	assert(CARD_DB.has(ID), "Card ID (%s) not found in registry" % ID)
	ResourceSaver.save(data, enemy_card_data_path+CARD_DB[ID]+".tres")
