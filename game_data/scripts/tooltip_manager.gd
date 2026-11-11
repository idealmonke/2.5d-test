class_name TooltipManager
extends Node2D

var cur_card : SkillCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(cur_card.card_name)
	var name = "null"
	if cur_card:
		name = cur_card.card_name
	#DevConsole.add_message("Hovering: "+name,Color.TEAL)
	pass

func unhover():
	pass

func hover():
	pass

func hover_card(card: SkillCard):
	if not card:
		return
	if cur_card:
		unhover()
	
	cur_card = card
	hover()
func unhover_card():
	if not cur_card:
		return
	
	unhover()
	cur_card = null
