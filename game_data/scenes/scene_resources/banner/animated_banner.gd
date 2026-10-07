class_name AnimatedBanner
extends Control

@onready var banner: TextureRect = $banner
@onready var label: Label = $banner/banner_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	banner.position.x = -1000
	banner.modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_banner(text: String, color: Color, text_color: Color):
	label.text = text
	label.label_settings.font_color = text_color
	banner.self_modulate = color
	
	var tween = create_tween().set_parallel(false).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(banner, "position:x", 460, 0.5)
	tween.parallel().tween_property(banner, "modulate:a", 1.0, 0.5)
	
	tween.tween_interval(1.0)
	
	tween.tween_property(banner, "position:x", 1920, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(banner, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(func(): banner.position.x = -600)
	
	await tween.finished
