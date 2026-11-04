extends CheckButton
@export var target: Node

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		target.show()
	else:
		target.hide()
