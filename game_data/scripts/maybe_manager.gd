class_name MaybeManager
extends Node2D

var yes_button : Button
var no_button : Button
var query_label : Label

func _ready() -> void:
	yes_button = $yes_button
	no_button = $no_button
	query_label = $query_label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

signal maybe_finished(answer: bool)

func _reset() -> void:
	visible = false

func maybe(query: String, yes: bool, no:bool) -> bool:
	visible = true
	query_label.text = query
	
	yes_button.disabled = not yes
	no_button.disabled = not no
	
	return await maybe_finished

func _on_yes_button_pressed() -> void:
	_reset()
	maybe_finished.emit(true)

func _on_no_button_pressed() -> void:
	_reset()
	maybe_finished.emit(false)
