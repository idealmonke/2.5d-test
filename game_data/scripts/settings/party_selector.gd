extends Node2D

#For Character display
var deck_label_2 : Label
var stats_label : Label

var window_string : String

#For Card editor
var button_container : VBoxContainer
var card_container : VBoxContainer
var deck_label : Label
var skill_card : SkillCard
var save_button: Button
var save_label : Label

var cur_party_name : String
var cur_data : PartyData

var deck_slots : int
var read_only : bool

#CARD ADDING
var add_container : VBoxContainer
var add_buttons : VBoxContainer

const CLASS_COLORS: Dictionary[COMMON_ENUMS.CHARACTER_CLASSES, Color] = {
	COMMON_ENUMS.CHARACTER_CLASSES.NONE: Color("#777D87"),
	COMMON_ENUMS.CHARACTER_CLASSES.WARRIOR: Color("#627D98"),
	COMMON_ENUMS.CHARACTER_CLASSES.CLERIC: Color("#E8D6A3"),
	COMMON_ENUMS.CHARACTER_CLASSES.KNAVE: Color("#388C83"),
	COMMON_ENUMS.CHARACTER_CLASSES.MAGE: Color("#9670D5"),
	COMMON_ENUMS.CHARACTER_CLASSES.BERSERKER: Color("#D44747"),
	COMMON_ENUMS.CHARACTER_CLASSES.SHAMAN: Color("#65A66B"),
	COMMON_ENUMS.CHARACTER_CLASSES.ALCHEMIST: Color("#D6A441"),
	COMMON_ENUMS.CHARACTER_CLASSES.OCCULTIST: Color("#633D78"),
}

func _ready() -> void:
	button_container = get_node("card_button_scroll_container/card_button_container/margin_container/inner_container")
	card_container = get_node("card_panel/margin_container/tab_container/Cards/margin_container/hbox/vbox/card_scroll/card_container")
	
	deck_label_2 = get_node("card_panel/margin_container/tab_container/Characters/margin_container/vbox/deck_label")
	stats_label = get_node("card_panel/margin_container/tab_container/Characters/margin_container/vbox/stats_label")
	
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
	
	stats_label.text += "Max health: "+str(stats.max_health)+"\n"
	stats_label.text += "Max mana: "+str(stats.max_mana)+"\n"
	stats_label.text += "Mana regen: "+str(stats.mana_regen)+"\n"
	stats_label.text += "Max stamina: "+str(stats.max_stamina)+"\n"
	stats_label.text += "Shield retension: "+str(stats.shield_retention)+"\n"
	stats_label.text += "Defense: "+str(stats.defense)+"\n"
	stats_label.text += "Handsize: "+str(stats.handsize)+"\n"
	stats_label.text += "Deckslots: "+str(stats.deck_slots)+"\n"
	
	deck_slots = stats.deck_slots

func _display_character(char_id: int):
	var data : CharacterData = CharacterDataRegistry.get_character_data(char_id)
	

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
	
	var ids : Array[int] = cur_data.card_ids
	add_cards(ids)
	add_missing(ids)
	
	_fix_entries()

func create_entry(id: int,is_remove: bool) -> PanelContainer:
	var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
	if not card_data:
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
		return "Error: you must have a full deck"
	
	
	return "error"

func _on_save_button_pressed() -> void:
	var valid = validate_save(cur_data)
	save_label.visible = true
	if valid == "valid":
		PartyRegistry.save_data(cur_party_name, cur_data)
		save_label.text = "Sucessful save"
	else:
		save_label.text = valid
