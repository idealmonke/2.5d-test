extends PanelContainer

var scroll_container : ScrollContainer;
var messages : VBoxContainer;
var edit : LineEdit;

func setup(devlog : PanelContainer) -> void:
	scroll_container = devlog.get_node("vbox/scroll_container");
	messages = devlog.get_node("vbox/scroll_container/messages");
	edit = devlog.get_node("vbox/command");

func add_message(message: String, color: Color = Color.WHITE):
	var label : Label = Label.new()
	
	var time := Time.get_time_string_from_system()
	label.text = "[" + time + "] " + message
	label.modulate = color

	messages.add_child(label)

	await get_tree().process_frame
	scroll_container.scroll_vertical = (int)(scroll_container.get_v_scroll_bar().max_value)


func _on_command_text_submitted(command: String) -> void:
	print(messages)
	
	#if command.is_empty():
		#return
		#
	#add_message("> " + command)
	#
	#edit.text = "";
	#
	#if(command=="clear"):
		#for child in messages.get_children():
			#child.queue_free()
	#elif(command=="draw"):
		#BattleController.draw_card()
	#else:
		#add_message("Unkown command "+command, Color.RED)
