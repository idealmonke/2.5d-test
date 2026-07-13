class_name enemy_card_registry
extends RefCounted

static var enemy_card_data_path: String = "res://game_data/enemies/card_data/"

const CARD_DB: Dictionary = {
	0001: "Bite"
}

static func get_card_data(ID: int) -> skill_card_data:
	assert(CARD_DB.has(ID), "Card ID (%s) not found in enemy card registry" % ID)
	return load(enemy_card_data_path+CARD_DB[ID]+".tres")
