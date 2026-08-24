class_name status_effect_registry
extends RefCounted

static var status_effect_data_path: String = ""

const CARD_DB: Dictionary = {
	1001: "longsword",
	1002: "rondel_dagger",
	3004: "scavenge",
	1003: "brief_respite"
}

static func get_status_effect_data(ID: COMMON_ENUMS.STATUS_EFFECT) -> skill_card_data:
	assert(CARD_DB.has(ID), "Effect not found in registry")
	return load(status_effect_data_path+CARD_DB[ID]+".tres")
