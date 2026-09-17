class_name status_effect_registry
extends RefCounted

static var status_effect_data_path: String = "res://game_data/status_effects/status_effect_data/"

const CARD_DB: Dictionary = {
	0001: "burning",
	0069: "haste",
	69420: "dazed",
	0002: "divine_favor"
}

static func get_status_effect_data(ID: int) -> status_effect_data:
	assert(CARD_DB.has(ID), "Effect not found in registry")
	return load(status_effect_data_path+CARD_DB[ID]+".tres")
