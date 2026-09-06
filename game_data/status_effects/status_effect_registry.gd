class_name status_effect_registry
extends RefCounted

static var status_effect_data_path: String = "res://game_data/status_effects/status_effect_data/"

const CARD_DB: Dictionary = {
	0001: "burning",
}

static func get_status_effect_data(ID: COMMON_ENUMS.STATUS_EFFECT) -> status_effect_data:
	assert(CARD_DB.has(ID), "Effect not found in registry")
	return load(status_effect_data_path+CARD_DB[ID]+".tres")
