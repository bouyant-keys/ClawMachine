extends Node2D

@export_node_path() var player_path

@onready var player = get_node(player_path) as Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !Player.input_enabled: return
	
	position.x = lerp(position.x, player.position.x, delta)
