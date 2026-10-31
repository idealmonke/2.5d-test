extends Node2D

#For Character display
var deck_label_2 : Label
var stats_label : Label

var window_string : String

var character_hbox : HBoxContainer

#For Card editor
var button_container : VBoxContainer
var card_container : VBoxContainer
var deck_label : Label
var skill_card : SkillCard
var save_button: Button
var save_label : Label

var cur_party_name : String
var cur_data : PartyData

var classes : Array[COMMON_ENUMS.CHARACTER_CLASSES]
var deck_slots : int
var read_only : bool

#CARD ADDING
var add_container : VBoxContainer
var add_buttons : VBoxContainer

const CLASS_COLORS: Dictionary[COMMON_ENUMS.CHARACTER_CLASSES, Color] = {
	COMMON_ENUMS.CHARACTER_CLASSES.NONE: Color("#777D87"),
	COMMON_ENUMS.CHARACTER_CLASSES.WARRIOR: Color("#627D98"),
	COMMON_ENUMS.CHARACTER_CLASSES.CLERIC: Color("#D6A441"),
	COMMON_ENUMS.CHARACTER_CLASSES.KNAVE: Color("#388C83"),
	COMMON_ENUMS.CHARACTER_CLASSES.MAGE: Color("296ef0ff"),
	COMMON_ENUMS.CHARACTER_CLASSES.BERSERKER: Color("#D44747"),
	COMMON_ENUMS.CHARACTER_CLASSES.SHAMAN: Color("#65A66B"),
	COMMON_ENUMS.CHARACTER_CLASSES.ALCHEMIST: Color("51370fff"),
	COMMON_ENUMS.CHARACTER_CLASSES.OCCULTIST: Color("#633D78"),
}

func _ready() -> void:
	button_container = get_node("card_button_scroll_container/card_button_container/margin_container/inner_container")
	card_container = get_node("card_panel/margin_container/tab_container/Cards/margin_container/hbox/vbox/card_scroll/card_container")
	
	deck_label_2 = get_node("card_panel/margin_container/tab_container/Characters/margin_container/vbox/deck_label")
	stats_label = get_node("card_panel/margin_container/tab_container/Characters/margin_container/vbox/stats_label")
	
	character_hbox = get_node("card_panel/margin_container/tab_container/Characters/margin_container/vbox/character_selector/main_vbox/character_hbox")
	
	deck_label = get_node("card_panel/margin_container/tab_container/Cards/margin_container/hbox/vbox/deck_label")
	skill_card = get_node("card_panel/margin_container/tab_container/Cards/skill_card")
	save_button = get_node("card_panel/margin_container/tab_container/Cards/save_button")
	save_label = get_node("card_panel/margin_container/tab_container/Cards/save_label")
	
	add_container = get_node("card_panel/margin_container/tab_container/Cards/margin_container/hbox/add_container")
	add_buttons = add_container.get_node("card_scroll/card_container/margin_container/inner_container")
	
	PartyRegistry.load_party_data()
	
	skill_card.misc_location = Vector2(800,500)
	skill_card.interactable_state = COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY
	
	for party_name in PartyRegistry.PARTY_DB:
		_create_button(party_name)

#Character display
func _display_stats(char_ids: Array[int]):
	stats_label.text = ""
	
	var characters: Array[CharacterData] = []
	for id in char_ids:
		characters.append(CharacterDataRegistry.get_character_data(id))
	
	var stats = CharacterDataRegistry.calculate_stats(characters)
	
	stats_label.text += "Max health: "+str(stats.max_health)+" | "
	stats_label.text += "Max mana: "+str(stats.max_mana)+" | "
	stats_label.text += "Mana regen: "+str(stats.mana_regen)+" | "
	stats_label.text += "Max stamina: "+str(stats.max_stamina)+" | "
	stats_label.text += "Shield retension: "+str(stats.shield_retention)+" | "
	stats_label.text += "Defense: "+str(stats.defense)+" | "
	stats_label.text += "Handsize: "+str(stats.handsize)+" | "
	stats_label.text += "Deckslots: "+str(stats.deck_slots)
	
	deck_slots = stats.deck_slots
	classes = stats.classes




func _display_characters(char_ids: Array[int]):
	var idx : int = 0
	for panel in character_hbox.get_children():
		var data : CharacterData = CharacterDataRegistry.get_character_data(char_ids[idx])
		
		var cur_vbox : VBoxContainer = panel.get_child(0).get_child(0)
		
		cur_vbox.get_node("character_name").text = CharacterDataRegistry.CHARACTER_DB[data.id]
		
		var p_list : Array[Dictionary] = data.get_property_list()
		
		for child in cur_vbox.get_node("character_stats").get_children():
			child.queue_free()
		
		for prop in p_list:
			if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
				var cur_name : String = prop["name"]
				var value : Variant = data.get(cur_name)
				
				if typeof(value) != TYPE_INT and typeof(value)!= TYPE_STRING:
					continue
				
				var hbox = HBoxContainer.new()
				
				var label : Label = Label.new()
				label.text = cur_name
				label.custom_minimum_size.x = 200
				var label2 : Label = Label.new()
				label2.text = str(value)
				
				hbox.add_child(label)
				hbox.add_child(label2)
				
				cur_vbox.get_node("character_stats").add_child(hbox)
		
		idx+=1

#Card Editor
func _create_button(cur_name : String) -> void:
	var button: Button = Button.new()
	button.text = cur_name
	button_container.add_child(button)
	button.pressed.connect(_on_pressed.bind(cur_name))

func _reset_window(window_name: String) -> void:
	for child in card_container.get_children():
		child.queue_free()
	for child in add_buttons.get_children():
		child.queue_free()
	
	window_string = "Showing: "+window_name
	deck_label.text = window_string;
	deck_label_2.text = window_string;
	save_button.visible = true
	add_container.visible = true
	
	if(read_only):
		deck_label.text += " (READ_ONLY)"
		save_button.visible = false
		add_container.visible = false
		
	save_label.visible = false

func sort_buttons(container: VBoxContainer) -> void:
	var buttons = container.get_children()
	
	buttons.sort_custom(func(a, b):return a.get_meta("id") < b.get_meta("id"))
	
	for i in range(buttons.size()):
		container.move_child(buttons[i], i)

func _on_pressed(cur_name: String) -> void:
	get_node("card_panel").visible = true
	cur_party_name = cur_name;
	
	cur_data = PartyRegistry.get_data(cur_name).duplicate(true)
	read_only = cur_data.read_only
	_reset_window(cur_name)
	
	var char_ids : Array[int] = cur_data.character_ids
	_display_stats(char_ids)
	_display_characters(char_ids)
	
	var ids : Array[int] = cur_data.card_ids
	add_cards(ids)
	add_missing(ids)
	
	_fix_entries()

func create_entry(id: int,is_remove: bool) -> PanelContainer:
	var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
	if not card_data:
		return null
	
	var good : bool = false
	for c in classes:
		if(card_data.card_classes[0]==c):
			good = true
			break
	
	if not good:
		return null
	
	var panel = PanelContainer.new()
	
	var style = StyleBoxFlat.new()
	if(card_data.card_classes.size()==0):
		style.bg_color = Color("#777D87")
	else:
		style.bg_color = CLASS_COLORS[card_data.card_classes[0]]

	panel.add_theme_stylebox_override("panel", style)
	
	var hbox = HBoxContainer.new()
	
	panel.set_meta("id", id)
	panel.add_child(hbox)
	
	var name_label = Label.new()
	name_label.text = card_data.card_name+" ("+str(card_data.card_id)+")"
	hbox.add_child(name_label)

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(spacer)
	
	if(not cur_data.read_only):
		var button = Button.new()
		if(is_remove):
			button.text = "Remove"
		else:
			button.text = "Add"
		button.pressed.connect(
				_on_card_pressed.bind(card_data.card_id, panel, is_remove)
		)
		hbox.add_child(button)
	
	hbox.mouse_entered.connect(_on_hbox_mouse_entered.bind(card_data))
	hbox.mouse_exited.connect(_on_hbox_mouse_exited);
	hbox.custom_minimum_size.x = 300
	
	return panel

#Adds all missing cards into possible addition zone
func add_missing(ids: Array[int]):
	for id in SkillCardRegistry.CARD_DB:
		if not ids.has(id):
			var entry = create_entry(id, false)
			if entry:
				add_buttons.add_child(entry)

#Adds all cards in current deck
func add_cards(ids: Array[int]):
	for id in ids:
		var entry = create_entry(id, true)
		if entry:
			card_container.add_child(entry)

func _on_hbox_mouse_entered(data: SkillCardData):
	skill_card.visible = true
	skill_card.set_front()
	
	skill_card.initialize_card(data)

func _on_hbox_mouse_exited():
	skill_card.visible = false

func _fix_entries():
	sort_buttons(add_buttons)
	sort_buttons(card_container)
	
	var cur_size = cur_data.card_ids.size()
	if(not read_only):
		deck_label.text = window_string+ "("+str(cur_size)+"/"+str(deck_slots)+")";
	
	for child in add_buttons.get_children():
		var hbox = child.get_child(0) as HBoxContainer
		for item in hbox.get_children():
			if item is Button:
				item.disabled = cur_size >= deck_slots
				break

func _on_card_pressed(card_id: int, row: PanelContainer, is_remove: bool):
	if(is_remove):
		var entry = create_entry(card_id, false)
		if entry:
			add_buttons.add_child(entry)
			cur_data.card_ids.erase(card_id)
			row.queue_free()
			
			_fix_entries()
		else:
			print("ERROR: party_selector.gd, removed entry should exist")
	else:
		var entry = create_entry(card_id, true)
		if entry:
			card_container.add_child(entry)
			row.queue_free()
			cur_data.card_ids.append(card_id)
			
			_fix_entries()
		else:
			print("ERROR: party_selector.gd, added entry should exist")

func validate_save(data: PartyData) -> String:
	if(data.card_ids.size() != deck_slots):
		print(data.card_ids)
		
		return "Error: you must have a full deck"
	
	for c in classes:
		if c==COMMON_ENUMS.CHARACTER_CLASSES.NONE:
			continue
		
		var count = 0
		for id in data.card_ids:
			var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
			if(card_data.card_classes[0]==c):
				count+=1
		if(count<2):
			return "Error: you must have at least 2 of each class"
	
	return "valid"

func _on_save_button_pressed() -> void:
	var valid = validate_save(cur_data)
	save_label.visible = true
	if valid == "valid":
		PartyRegistry.save_data(cur_party_name, cur_data)
		save_label.text = "Sucessful save"
	else:
		save_label.text = valid
