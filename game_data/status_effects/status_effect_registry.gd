class_name status_effect_registry
extends RefCounted

static var status_effect_data_path: String = "res://game_data/status_effects/status_effect_data/"

const CARD_DB: Dictionary = {
	1: "blindness",
	2: "bloodthirsty",
	3: "vulnerable",
	4: "burning",
	5: "dazed",
	6: "divine_favor",
	7: "haste",
	8: "regeneration"
}

static func get_status_effect_data(ID: int) -> status_effect_data:
	assert(CARD_DB.has(ID), "Effect not found in registry")
	return load(status_effect_data_path+CARD_DB[ID]+".tres")
