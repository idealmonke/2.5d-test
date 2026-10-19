class_name SkillCardRegistry
extends RefCounted

static var skill_card_data_path: String = "res://game_data/skill_cards/skill_cards_data/"

const CARD_DB: Dictionary = {
	1001: "longsword",
	1002: "whirlwind_strikes",
	1003: "brief_respite",
	1004: "rally_the_party",
	1005: "charge",
	2001: "lesser_cleanse",
	2002: "divine_favor",
	2003: "judgement_bolt",
	2004: "holy_light",
	3001: "rondel_dagger",
	3002: "hand_crossbow",
	3003: "pocket_sand",
	3004: "scavenge",
	4001: "magic_missile",
	4002: "fireball",
	4003: "arcane_ward",
	4004: "quick_focus",
	4005: "heightened_arcana",
	5001: "battle_cry",
	5002: "greatclub",
	5003: "bare_knuckles",
	5004: "shoulder_check",
	6001: "natures_recourse",
	6002: "vine_lash",
	6003: "shamanic_wave",
	6004: "bramble_wall",
	6005: "cold_front",
	7001: "molotov",
	7002: "draught_of_the_rabbit",
	7003: "regeneration_potion",
	7004: "reactant",
}

static func get_card_data(ID: int) -> SkillCardData:
	assert(CARD_DB.has(ID), "Card ID (%s) not found in registry" % ID)
	return load(skill_card_data_path+CARD_DB[ID]+".tres")

static func save_data(data: SkillCardData) -> void:
	var ID : int = data.card_id;
	
	assert(CARD_DB.has(ID), "Card ID (%s) not found in registry" % ID)
	ResourceSaver.save(data, skill_card_data_path+CARD_DB[ID]+".tres")
