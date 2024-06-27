extends Sprite2D

func _enter_tree() -> void:
	self_modulate = Color.from_hsv(1.0, 1.0, 1.0, 1.0)
	
	var alpha_tween = get_tree().create_tween()
	alpha_tween.tween_property(self, "self_modulate", Color.from_hsv(1.0, 1.0, 1.0, 0.0), 1.0)
	
	await alpha_tween.finished
	queue_free()
