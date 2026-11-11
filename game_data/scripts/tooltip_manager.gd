class_name TooltipManager
extends Node2D

var cur_card : SkillCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(cur_card.card_name)
	pass

func hover_card(card: SkillCard):
	cur_card = card
	DevConsole.add_message("Hovering: "+cur_card.card_name,Color.LIGHT_CORAL)
	print("Hovering: ",cur_card.card_name)
func unhover_card(card: SkillCard):
	if cur_card==card:
		print("Unhovering: ", cur_card.card_name)
		DevConsole.add_message("Unhovering: "+cur_card.card_name,Color.LIGHT_CORAL)
