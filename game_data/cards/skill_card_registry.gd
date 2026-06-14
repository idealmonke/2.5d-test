class_name skill_card_registry
extends RefCounted

static var skill_card_data_path: String = "res://game_data/cards/skill_cards_data/"

const CARD_DB: Dictionary = {
	1001: "Longsword"
}

static func get_card_data(ID: int) -> skill_card_data:
	assert(CARD_DB.has(ID), "Card ID (%s) not found in registry" % ID)
	return load(skill_card_data_path+CARD_DB[ID]+".tres")
