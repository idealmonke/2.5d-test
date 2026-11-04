class_name EnemyRegistry
extends RefCounted

static var enemy_data_path: String = "res://game_data/enemies/enemy_data/"

const ENEMY_DB: Dictionary = {
	0001: "harpy",
	0002: "knife_kobold"
}

static func get_enemy_data(ID: int) -> EnemyData:
	assert(ENEMY_DB.has(ID), "Enemy ID (%s) not found in enemy card registry" % ID)
	return load(enemy_data_path+ENEMY_DB[ID]+".tres")

static func save_data(data: EnemyData) -> void:
	var ID : int = data.enemy_id;
	
	assert(ENEMY_DB.has(ID), "Enemy  ID (%s) not found in registry" % ID)
	ResourceSaver.save(data, enemy_data_path+ENEMY_DB[ID]+".tres")
