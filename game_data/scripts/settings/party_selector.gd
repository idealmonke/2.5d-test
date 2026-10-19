extends Node2D

var button_container
var card_container
var deck_label

func _ready() -> void:
	button_container = get_node("card_button_scroll_container/card_button_container/margin_container/inner_container")
	card_container = get_node("card_panel/margin_container/vbox/card_container")
	deck_label = get_node("card_panel/margin_container/vbox/deck_label")
	
	_reset_buttons()
	PartyRegistry.load_party_data()
	
	for party_name in PartyRegistry.PARTY_DB:
		var data = PartyRegistry.PARTY_DB[party_name]
		_create_button(data, party_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _reset_buttons() -> void:
	for child in  button_container.get_children():
		child.queue_free()

func _create_button(data: PartyData , cur_name : String) -> void:
	var button: Button = Button.new()
	button.text = cur_name
	button_container.add_child(button)
	button.pressed.connect(_on_pressed.bind(cur_name, data))

func _reset_window(name: String) -> void:
	for child in  card_container.get_children():
		child.queue_free()
	deck_label.text = "Showing: "+name
	

func _on_pressed(name: String, data : PartyData) -> void:
	_reset_window(name)
	
	var ids : Array[int] = data.card_ids
	
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

		card_container.add_child(hbox)
	
func _on_remove_card_pressed(card_id: int, row: HBoxContainer):
	pass
	## Update your deck data here
	#selected_card_ids.erase(card_id)
#
	## Remove the UI row
	#row.queue_free()
