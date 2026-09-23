class_name StatusEffectRegistry
extends RefCounted

static var status_effect_data_path: String = "res://game_data/status_effects/status_effect_data/"

const CARD_DB: Dictionary = {
	0001: "blindness",
	0002: "bloodthirsty",
	0003: "vulnerable",
	0004: "burning",
	0005: "dazed",
	0006: "divine_favor",
	0007: "haste",
	0008: "regeneration",
	0009: "holy_light",
}

static func get_status_effect_data(ID: int) -> StatusEffectData:
	assert(CARD_DB.has(ID), "Effect not found in registry")
	return load(status_effect_data_path+CARD_DB[ID]+".tres")
