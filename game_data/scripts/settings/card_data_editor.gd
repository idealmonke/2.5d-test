extends VBoxContainer

var cur_data : Variant

var card_art : Sprite2D
var card_editor_output : Label
var card_button_container : VBoxContainer

func init() -> void:
	card_art = get_node("../card_art")
	card_editor_output = get_node("../card_editor_output")
	card_button_container = get_node("../card_button_scroll_container/card_button_container")

func display(id : int, is_skill_card: bool) -> void:
	if is_skill_card:
		cur_data = skill_card_registry.get_card_data(id)
	else:
		cur_data = enemy_card_registry.get_card_data(id)
	
	for child in get_children():
		child.queue_free()
	
	card_art.texture = cur_data.card_art
	card_art.scale = Vector2(100,100)/card_art.texture.get_size()
	
	var p_list : Array[Dictionary] = cur_data.get_property_list()
	for prop in p_list:
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var name : String = prop["name"]
			var value : Variant = cur_data.get(name)
			
			if typeof(value) != TYPE_INT and typeof(value)!= TYPE_STRING:
				continue
			
			var label : Label = Label.new()
			label.text = name
			
			if(name=="card_id"):
				var label2 : Label = Label.new()
				label2.text = str(value)
				label2.position.x += 200
				label.add_child(label2)
				label.set_meta("property_name",prop["name"]);
				add_child(label)
				continue
			
			var edit : LineEdit = LineEdit.new();
			edit.placeholder_text = "placeholder"
			edit.custom_minimum_size.x = 100
			
			if typeof(value) == TYPE_INT:
				edit.placeholder_text = str(value)
			if typeof(value) == TYPE_STRING:
				edit.placeholder_text = value
			else:
				#continue
				pass
			
			edit.position.x+=200
			label.add_child(edit)
			label.set_meta("property_name",prop["name"]);
			
			add_child(label)

func _on_save_button_pressed() -> void:
	for child in get_children():
		var text : String = child.get_child(0).text
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
	
	if cur_data is skill_card_data:
		skill_card_registry.save_data(cur_data)
		display(cur_data.card_id, true)
	else:
		enemy_card_registry.save_data(cur_data)
		display(cur_data.card_id, false)
	card_button_container.reset_buttons()
