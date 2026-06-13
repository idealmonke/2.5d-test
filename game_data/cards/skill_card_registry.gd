class_name skill_card_registry
extends Node

static var skill_card_data_path: String = "res://game_data/cards/skill_cards_data/"

const CARD_DB: Dictionary = {
	1001: "slash"
}

static func get_card_data(ID: int) -> skill_card_data:
	assert(CARD_DB.has(ID))
	return load(skill_card_data_path+CARD_DB[ID]+".tres")
