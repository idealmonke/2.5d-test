extends VBoxContainer

var cur_data : Variant

const card_editor_path = "../../../../../card_editor"
var card_art : Sprite2D
var card_editor_output : Label
var card_button_container : VBoxContainer
var panel : PanelContainer

enum MODE {SKILL_CARD, ENEMY_CARD, ENEMY}

func init() -> void:
	var card_editor : Control = get_node(card_editor_path)
	
	card_art = card_editor.get_node("card_art")
	card_editor_output = card_editor.get_node("card_editor_output")
	card_button_container = card_editor.get_node("card_button_scroll_container/card_button_container")
	panel = card_editor.get_node("card_data_editor_panel")

func reset() -> void:
	for child in get_children():
		child.queue_free()
	card_art.texture = null

func display(id : int, mode: MODE) -> void:
	if mode == MODE.SKILL_CARD:
		cur_data = SkillCardRegistry.get_card_data(id)
	elif mode == MODE.ENEMY_CARD:
		cur_data = EnemyCardRegistry.get_card_data(id)
	elif mode == MODE.ENEMY:
		cur_data = EnemyRegistry.get_enemy_data(id)
	
	reset()
	
	if mode == MODE.ENEMY:
		card_art.texture = cur_data.art
	else:
		card_art.texture = cur_data.card_art
	
	card_art.scale = Vector2(100,100)/card_art.texture.get_size()
	
	var p_list : Array[Dictionary] = cur_data.get_property_list()
	for prop in p_list:
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var cur_name : String = prop["name"]
			var value : Variant = cur_data.get(cur_name)
			
			if typeof(value) != TYPE_INT and typeof(value)!= TYPE_STRING:
				continue
			
			var hbox = HBoxContainer.new()
			
			var label : Label = Label.new()
			label.text = cur_name
			
			var label2: Label
			if(cur_name=="card_id" or cur_name=="enemy_id"):
				label2 = Label.new()
				label2.text = str(value)
			
			var edit : LineEdit = LineEdit.new();
			edit.placeholder_text = "placeholder"
			edit.custom_minimum_size.x = 100
			
			if typeof(value) == TYPE_INT:
				edit.placeholder_text = str(value)
			if typeof(value) == TYPE_STRING:
				edit.placeholder_text = value
			
			hbox.set_meta("property_name",prop["name"]);
			label.custom_minimum_size.x = 200
			
			hbox.add_child(label)
			if(cur_name=="card_id" or cur_name=="enemy_id"):
				hbox.add_child(label2)
			else:
				hbox.add_child(edit)
			add_child(hbox)

func _on_save_button_pressed() -> void:
	for child in get_children():
		var text : String = child.get_child(1).text
		var prop_name : String = child.get_meta("property_name")
		var prop : Variant = cur_data.get(prop_name)
		
		if text == "":
			continue
		if(prop_name=="card_id"):
			continue
		
		if(typeof(prop) == TYPE_INT):
			if(text.is_valid_int()):
				cur_data[prop_name] = int(text)
			else:
				card_editor_output.text+="error: "+prop_name+" must be an int\n"
				return
		elif(typeof(prop) == TYPE_STRING):
			cur_data[prop_name] = str(text)
		else:
			card_editor_output.text+="error: "+prop_name+" does not have setting functionality\n"
			return
	card_editor_output.text+="successful save, good job :D \n"
	
	if cur_data is SkillCardData:
		SkillCardRegistry.save_data(cur_data)
		display(cur_data.card_id, MODE.SKILL_CARD)
	elif cur_data is EnemyCardData:
		EnemyCardRegistry.save_data(cur_data)
		display(cur_data.card_id, MODE.ENEMY_CARD)
	elif cur_data is EnemyData:
		EnemyRegistry.save_data(cur_data)
		display(cur_data.enemy_id, MODE.ENEMY)
	card_button_container.reset_buttons()
	panel.visible = true
