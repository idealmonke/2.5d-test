extends Node2D

#For Character display
var deck_label_2 : Label
var stats_label : Label

var window_string : String

var character_hbox : HBoxContainer

var option_buttons : Array[OptionButton]

#For Card editor
const SKILL_CARD_SCENE = preload("res://game_data/skill_cards/skill_card.tscn")
var button_container : VBoxContainer
var card_container : VBoxContainer
var deck_label : Label
var skill_card : SkillCard

var save_button: Button
var save_label : Label
var select_button : Button

var cur_party_name : String
var cur_data : PartyData

var classes : Array[COMMON_ENUMS.CHARACTER_CLASSES]
var deck_slots : int
var read_only : bool

#CARD ADDING
var add_container : VBoxContainer
var add_buttons : VBoxContainer

#CONFIG
var battle_config : BattleConfig

#Maybe Manager
var maybe_manager_instance : MaybeManager

func _ready() -> void:
	var tab_container = get_node("card_panel/margin_container/vbox/tab_container")
	
	maybe_manager_instance = get_node("maybe_manager")
	
	button_container = get_node("card_button_scroll_container/card_button_container/margin_container/inner_container")
	card_container = tab_container.get_node("Cards/margin_container/hbox/vbox/card_scroll/card_container")
	
	deck_label_2 = tab_container.get_node("Characters/margin_container/vbox/deck_label")
	stats_label = tab_container.get_node("Characters/margin_container/vbox/stats_label")
	
	character_hbox = tab_container.get_node("Characters/margin_container/vbox/character_selector/main_vbox/character_hbox")
	
	deck_label = tab_container.get_node("Cards/margin_container/hbox/vbox/deck_label")
	skill_card = SKILL_CARD_SCENE.instantiate()
	skill_card.scale = Vector2(1,1)
	tab_container.get_node("Cards").add_child(skill_card)
	
	
	var save_hbox = get_node("card_panel/margin_container/vbox/save_hbox")
	save_button = save_hbox.get_node("save_button")
	save_label = save_hbox.get_node("save_label")
	select_button = save_hbox.get_node("select_button")
	
	add_container = tab_container.get_node("Cards/margin_container/hbox/add_container")
	add_buttons = add_container.get_node("card_scroll/card_container/margin_container/inner_container")
	
	PartyRegistry.load_party_data()
	
	skill_card.visible = false
	skill_card.misc_location = Vector2(800,500)
	skill_card.interactable_state = COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY
	
	battle_config = load("res://game_data/battle_config.tres")
	
	for party_name in PartyRegistry.PARTY_DB:
		_create_button(party_name)
	
	_update_party_buttons()
	
	option_buttons = []
	var idx = 0
	for panel in character_hbox.get_children():
		var cur_vbox : VBoxContainer = panel.get_child(0).get_child(0)
		var cur_button : OptionButton = cur_vbox.get_node("character_selector")
		option_buttons.append(cur_button)
		cur_button.item_selected.connect(_on_character_selected.bind(idx))
		idx += 1

#Character display
func _on_character_selected(idx: int, slot: int):
	#Slot: slot selectes index idx
	cur_data.character_ids[slot] = option_buttons[slot].get_item_metadata(idx)
	
	_update_dropdowns()
	_reset()
	
	select_button.disabled = true

func _update_dropdowns():
	for i in range(4):
		var cur = 	option_buttons[i]
		cur.clear()
		
		for id in CharacterDataRegistry.CHARACTER_DB:
			var character_name = CharacterDataRegistry.CHARACTER_DB[id]
			
			var already_selected = false
			for j in range(4):
				if j!=i and cur_data.character_ids[j]==id:
					already_selected = true
			
			if not already_selected:
				cur.add_item(character_name)
				cur.set_item_metadata(cur.item_count-1, id)
		
		for j in range(cur.item_count):
			if(cur.get_item_metadata(j)==cur_data.character_ids[i]):
				cur.select(j)
		
		cur.disabled = read_only

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

func set_panel_color(panel: PanelContainer, color: Color):
	var style = StyleBoxFlat.new()
	style.bg_color = color
	panel.add_theme_stylebox_override("panel", style)
func mute_color(color: Color, amount: float = 0.3) -> Color:
	return color.lerp(Color("#303030"), amount)

func _display_characters(char_ids: Array[int]):
	var idx : int = 0
	for panel in character_hbox.get_children():
		var data : CharacterData = CharacterDataRegistry.get_character_data(char_ids[idx])
		
		var color = mute_color(COMMON_ENUMS.CLASS_COLORS[data.main_class], 0.5)
		set_panel_color(panel, color)
		
		var cur_vbox : VBoxContainer = panel.get_child(0).get_child(0)
		cur_vbox.get_node("character_name").text = CharacterDataRegistry.CHARACTER_DB[data.id]
		
		cur_vbox.get_node("character_img").texture = data.art
		
		for child in cur_vbox.get_node("character_stats").get_children():
			child.queue_free()
		
		var p_list : Array[Dictionary] = data.get_property_list()
		for prop in p_list:
			if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
				var cur_name : String = prop["name"]
				var value : Variant = data.get(cur_name)
				
				if typeof(value) != TYPE_INT and typeof(value)!= TYPE_STRING:
					continue
				
				var hbox = HBoxContainer.new()
				
				var label : Label = Label.new()
				label.text = cur_name
				label.custom_minimum_size.x = 100
				var label2 : Label = Label.new()
				label2.text = str(value)
				
				hbox.add_child(label)
				hbox.add_child(label2)
				
				cur_vbox.get_node("character_stats").add_child(hbox)
		
		idx+=1

#Card Editor
func _update_party_buttons() -> void:
	for button in button_container.get_children():
		if(button.text==cur_party_name):
			button.modulate = Color(0.5, 0.8, 1.0)
		else:
			button.modulate = Color.WHITE
		
		if(button.text==battle_config.party.file_name):
			var style = StyleBoxFlat.new()
			style.bg_color = Color(0.2, 0.5, 0.8)

			style.border_width_left = 3
			style.border_width_right = 3
			style.border_width_top = 3
			style.border_width_bottom = 3
			style.border_color = Color(0.4, 0.8, 1.0)

			button.add_theme_stylebox_override("normal", style)
			button.add_theme_stylebox_override("hover", style)
		else:
			button.remove_theme_stylebox_override("normal")
			button.remove_theme_stylebox_override("hover")

func _create_button(cur_name : String) -> void:
	var button: Button = Button.new()
	button.text = cur_name
	button_container.add_child(button)
	button.pressed.connect(_on_pressed.bind(cur_name))

func _reset_window(window_name: String) -> void:
	window_string = "Showing: "+window_name
	deck_label.text = window_string;
	deck_label_2.text = window_string;
	save_button.disabled = false
	add_container.visible = true
	
	if(read_only):
		deck_label.text += " (READ_ONLY)"
		deck_label_2.text += " (READ_ONLY)"
		save_button.disabled = true
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
	
	_reset()
	_update_dropdowns()
	
	_update_party_buttons()
	select_button.disabled = false

func _reset():
	for child in card_container.get_children():
		child.queue_free()
	for child in add_buttons.get_children():
		child.queue_free()
	
	var char_ids : Array[int] = cur_data.character_ids
	_display_stats(char_ids)
	_display_characters(char_ids)
	
	verify_ids()
	
	var ids : Array[int] = cur_data.card_ids
	
	add_cards(ids)
	add_missing(ids)
	
	_fix_entries()

func verify_ids():
	for id in cur_data.card_ids.duplicate():
		var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
		
		var valid = false
		for char_id in cur_data.character_ids:
			var data : CharacterData = CharacterDataRegistry.get_character_data(char_id)
			if card_data.card_classes[0]==data.main_class:
				valid = true
		if not valid:
			cur_data.card_ids.erase(id)

func create_entry(id: int,is_remove: bool) -> PanelContainer:
	var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
	if not card_data:
		return null
	
	if not is_remove:
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
		style.bg_color = mute_color(COMMON_ENUMS.CLASS_COLORS[card_data.card_classes[0]])

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
	
	
	skill_card.initialize_card(data)
	skill_card.base_z_index = 100
	skill_card.set_front()
	#skill_card.get_node("Sprite2D").z_index = 101
	#skill_card.get_node("Sprite2D/CardArt").z_index = 100

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
	select_button.disabled = true
	if(is_remove):
		var entry = create_entry(card_id, false)
		if entry:
			add_buttons.add_child(entry)
		
		cur_data.card_ids.erase(card_id)
		row.queue_free()
		
		_fix_entries()
			#print("ERROR: party_selector.gd, removed entry should exist")
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
	
	for id in data.card_ids:
		var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
		
		var valid = false
		for c in classes:
			if(card_data.card_classes[0]==c):
				valid = true
		
		if not valid:
			return "Error: you have a card not in one of your classes: "+card_data.card_name
	
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
		
		select_button.disabled = false
		
		select_party()
	else:
		save_label.text = valid

func select_party() -> void:
	battle_config.party = cur_data
	ResourceSaver.save(battle_config, "res://game_data/battle_config.tres")
	_update_party_buttons()
	
	save_label.visible = true
	save_label.text = "Party selected"

func _on_select_button_pressed() -> void:
	select_party()

func unsaved_changes() -> bool:
	return select_button.disabled
