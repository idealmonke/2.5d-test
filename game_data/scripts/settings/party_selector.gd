extends Node2D

var button_container : VBoxContainer
var card_container : VBoxContainer
var deck_label : Label
var skill_card : SkillCard
var save_label : Label

var cur_party_name : String
var cur_data : PartyData

#const SKILL_CARD_SCENE = preload("res://game_data/skill_cards/skill_card.tscn")

func _ready() -> void:
	button_container = get_node("card_button_scroll_container/card_button_container/margin_container/inner_container")
	card_container = get_node("card_panel/margin_container/tab_container/Cards/margin_container/vbox/card_container")
	deck_label = get_node("card_panel/margin_container/tab_container/Cards/margin_container/vbox/deck_label")
	skill_card = get_node("card_panel/margin_container/tab_container/Cards/skill_card")
	save_label = get_node("card_panel/margin_container/tab_container/Cards/save_label")
	
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

func _reset_window(window_name: String) -> void:
	for child in  card_container.get_children():
		child.queue_free()
	deck_label.text = "Showing: "+window_name
	save_label.visible = false
	

func _on_pressed(cur_name: String) -> void:
	_reset_window(cur_name)
	get_node("card_panel").visible = true
	cur_party_name = cur_name;
	
	cur_data = PartyRegistry.get_data(cur_name).duplicate(true)
	
	var ids : Array[int] = cur_data.card_ids
	
	for id in ids:
		var card_data : SkillCardData = SkillCardRegistry.get_card_data(id)
		
		var hbox = HBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = card_data.card_name
		hbox.add_child(name_label)

		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(spacer)

		var remove_button = Button.new()
		remove_button.text = "Remove"
		remove_button.pressed.connect(
				_on_remove_card_pressed.bind(card_data.card_id, hbox)
		)
		hbox.add_child(remove_button)
		
		hbox.mouse_entered.connect(_on_hbox_mouse_entered.bind(card_data))
		hbox.mouse_exited.connect(_on_hbox_mouse_exited);
		
		card_container.add_child(hbox)

func _on_hbox_mouse_entered(data: SkillCardData):
	skill_card.visible = true
	skill_card.set_front()
	
	skill_card.initialize_card(data)

func _on_hbox_mouse_exited():
	skill_card.visible = false

func _on_remove_card_pressed(card_id: int, row: HBoxContainer):
	cur_data.card_ids.erase(card_id)
	row.queue_free()

func _on_save_button_pressed() -> void:
	PartyRegistry.save_data(cur_party_name, cur_data)
	save_label.visible = true
