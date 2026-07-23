extends VBoxContainer

var cur_data : skill_card_data
var output

const skill_card_art_source = "../skill_card_art"
const skill_card_output_source = "../skill_card_editor_output"
const skill_card_buttons_source = "../skill_card_button_scroll_container/skill_card_buttons"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display(id) -> void:
	cur_data = skill_card_registry.get_card_data(id)
	
	for child in get_children():
		child.queue_free()
	
	var art = get_node(skill_card_art_source)
	art.texture = cur_data.card_art
	art.scale = Vector2(100,100)/art.texture.get_size()
	
	var p_list = cur_data.get_property_list()
	for prop in p_list:
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var name = prop["name"]
			var value = cur_data.get(name)
			
			if typeof(value) != TYPE_INT and typeof(value)!= TYPE_STRING:
				continue
			
			var label = Label.new()
			label.text = name
			
			if(name=="card_id"):
				var label2 = Label.new()
				label2.text = str(value)
				label2.position.x += 200
				label.add_child(label2)
				label.set_meta("property_name",prop["name"]);
				add_child(label)
				continue
			
			var edit = LineEdit.new();
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
	output = get_node(skill_card_output_source)
	
	for child in get_children():
		var text = child.get_child(0).text
		var prop_name = child.get_meta("property_name")
		var prop = cur_data.get(prop_name)
		
		if text == "":
			continue
		if(prop_name=="card_id"):
			continue
		
		if(typeof(prop) == TYPE_INT):
			if(text.is_valid_int()):
				cur_data[prop_name] = int(text)
			else:
				output.text+="error: "+prop_name+" must be an int\n"
				return
		elif(typeof(prop) == TYPE_STRING):
			cur_data[prop_name] = str(text)
		else:
			output.text+="error: "+prop_name+" does not have setting functionality\n"
			return
	output.text+="successful save, good job :D \n"
	skill_card_registry.save_data(cur_data);
	
	display(cur_data.card_id)
	get_node(skill_card_buttons_source).reset_buttons()
