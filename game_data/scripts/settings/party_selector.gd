extends Node2D

var button_container : VBoxContainer
var card_container : VBoxContainer
var deck_label : Label
var skill_card : SkillCard
var save_button: Button
var save_label : Label

var cur_party_name : String
var cur_data : PartyData

#CARD ADDING
var add_container : VBoxContainer
var add_buttons : VBoxContainer

#const SKILL_CARD_SCENE = preload("res://game_data/skill_cards/skill_card.tscn")

func _ready() -> void:
	button_container = get_node("card_button_scroll_container/card_button_container/margin_container/inner_container")
	card_container = get_node("card_panel/margin_container/tab_container/Cards/margin_container/hbox/vbox/card_scroll/card_container")
	deck_label = get_node("card_panel/margin_container/tab_container/Cards/margin_container/hbox/vbox/deck_label")
	skill_card = get_node("card_panel/margin_container/tab_container/Cards/skill_card")
	save_button = get_node("card_panel/margin_container/tab_container/Cards/save_button")
	save_label = get_node("card_panel/margin_container/tab_container/Cards/save_label")
	
	add_container = get_node("card_panel/margin_container/tab_container/Cards/margin_container/hbox/add_container")
	add_buttons = add_container.get_node("card_scroll/card_container/margin_container/inner_container")
	
	_reset_buttons()
	PartyRegistry.load_party_data()
	
	print(PartyRegistry.PARTY_DB)
	
	skill_card.misc_location = Vector2(800,500)
	skill_card.interactable_state = COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY
	
	for party_name in PartyRegistry.PARTY_DB:
		_create_button(party_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _reset_buttons() -> void:
	for child in  button_container.get_children():
		child.queue_free()

func _create_button(cur_name : String) -> void:
	var button: Button = Button.new()
	button.text = cur_name
	button_container.add_child(button)
	button.pressed.connect(_on_pressed.bind(cur_name))

func _reset_window(window_name: String, read_only: bool) -> void:
	for child in card_container.get_children():
		child.queue_free()
	for child in add_buttons.get_children():
		child.queue_free()
	deck_label.text = "Showing: "+window_name;
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
	_reset_window(cur_name, cur_data.read_only)
	
	var ids : Array[int] = cur_data.card_ids
	add_cards(ids)
	add_missing(ids)

func create_entry(id: int,is_remove: bool) -> HBoxContainer:
	var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
	if not card_data:
		return null
	
	var hbox = HBoxContainer.new()
	
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
				_on_card_pressed.bind(card_data.card_id, hbox, is_remove)
		)
		hbox.add_child(button)
	
	hbox.mouse_entered.connect(_on_hbox_mouse_entered.bind(card_data))
	hbox.mouse_exited.connect(_on_hbox_mouse_exited);
	
	hbox.set_meta("id", id)
	
	return hbox

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

func _on_card_pressed(card_id: int, row: HBoxContainer, is_remove: bool):
	if(is_remove):
		var entry = create_entry(card_id, false)
		if entry:
			add_buttons.add_child(entry)
			cur_data.card_ids.erase(card_id)
			row.queue_free()
			
			sort_buttons(add_buttons)
		else:
			print("ERROR: party_selector.gd, removed entry should exist")
	else:
		var entry = create_entry(card_id, true)
		if entry:
			card_container.add_child(entry)
			row.queue_free()
			cur_data.card_ids.append(card_id)
			
			sort_buttons(card_container)
		else:
			print("ERROR: party_selector.gd, added entry should exist")

func _on_save_button_pressed() -> void:
	PartyRegistry.save_data(cur_party_name, cur_data)
	save_label.visible = true
