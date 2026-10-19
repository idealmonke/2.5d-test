class_name DamageNumber
extends Label

var color_map: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, Color] = {
	COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL: Color(18.892, 18.892, 18.892, 1.0),
	COMMON_ENUMS.DAMAGE_TYPE.FIRE: Color(0.915, 0.337, 0.0, 1.0),
	COMMON_ENUMS.DAMAGE_TYPE.ICE: Color(0.0, 0.781, 0.927, 1.0),
	COMMON_ENUMS.DAMAGE_TYPE.LIGHTNING: Color(0.997, 0.787, 0.0, 1.0),
	COMMON_ENUMS.DAMAGE_TYPE.POISON: Color(0.462, 0.506, 0.047, 1.0),
	COMMON_ENUMS.DAMAGE_TYPE.HOLY: Color(1.0, 1.0, 0.0, 1.0),
	COMMON_ENUMS.DAMAGE_TYPE.MAGIC: Color(0.161, 0.188, 0.537, 1.0)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = create_tween().set_parallel()
	scale = Vector2(0.5, 0.5)
	
	tween.tween_property(self, "position:y", position.y - 60.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", position.x + (50*(randf() - 0.5)), 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.4).set_delay(0.5)
	tween.tween_property(self, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.chain().tween_callback(queue_free)
	

func setup(damage: int, color: COMMON_ENUMS.DAMAGE_TYPE) -> void:
	text = str(damage)
	modulate = color_map[color]
	pivot_offset = size/2.0
	
