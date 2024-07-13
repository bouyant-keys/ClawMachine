extends Node2D

#@export var scroll_speed := 2.0

@export_node_path() var player_path

@onready var player : Node2D = get_node(player_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#scroll_base_offset.y = player.global_position.y
	#print(scroll_offset)
	#var new_offset := Vector2(0.0, scroll_speed * delta)
	position = Vector2(0.0, player.position.y)
