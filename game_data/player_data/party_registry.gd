class_name PartyRegistry
extends RefCounted

static var party_data_path: String = "res://game_data/player_data/party_data/"

static var PARTY_DB: Dictionary = {}	

static func load_party_data() -> void:
	#var out: Array[PartyData] = []
	var dir = DirAccess.open(party_data_path)

	if dir == null:
		print("ERROR: BAD PARTY DATA PATH")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			print(file_name)
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var cur = load(party_data_path + file_name)
				if cur != null:
					PARTY_DB[file_name] = cur

		file_name = dir.get_next()

	dir.list_dir_end()

static func get_data(name: String) -> PartyData:
	return PARTY_DB[name]

static func save_data(name: String, data: PartyData) -> void:
	PARTY_DB[name] = data
	ResourceSaver.save(data, party_data_path+name)

#static func get_character_data(ID: String) -> CharacterData:
	#assert(CHARACTER_DB.has(ID), "Character ID (%s) not found in character registry" % ID)
	#return load(character_data_path+CHARACTER_DB[ID]+".tres")
#
#static func save_data(data: CharacterData) -> void:
	#var ID : int = data.id;
	#
	#assert(CHARACTER_DB.has(ID), "Character ID (%s) not found in registry" % ID)
	#ResourceSaver.save(data, character_data_path+CHARACTER_DB[ID]+".tres")
