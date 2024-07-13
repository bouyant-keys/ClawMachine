extends Node2D

@export_range(0.0, 1.0) var scroll_ratio

@onready var sprite: Sprite2D = $Sprite2D

var tex_y : float

func _ready() -> void:
	tex_y = sprite.texture.get_height()

func _process(_delta: float) -> void:
	global_position.y = get_parent().position.y * scroll_ratio
	
	if position.y > tex_y: 
		position.y -= tex_y
	elif position.y < -tex_y: 
		position.y += tex_y
