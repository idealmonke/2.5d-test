class_name enemy_registry
extends RefCounted

static var enemy_data_path: String = "res://game_data/enemies/enemy_data/"

const ENEMY_DB: Dictionary = {
	0001: "Harpy"
}

static func get_enemy_data(ID: int) -> enemy_data:
	assert(ENEMY_DB.has(ID), "Enemy ID (%s) not found in enemy card registry" % ID)
	return load(enemy_data_path+ENEMY_DB[ID]+".tres")
