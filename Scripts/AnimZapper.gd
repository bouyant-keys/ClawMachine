extends AnimatableBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim_sprite = $AnimSprite as AnimatedSprite2D
	anim_sprite.play("default")
