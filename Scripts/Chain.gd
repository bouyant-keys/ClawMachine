extends Line2D

@export_node_path() var player_path

@onready var player : CharacterBody2D = get_node(player_path)

func _ready() -> void:
	for point : int in points.size():
		points[point].y = point * -16.0

func _process(delta: float) -> void:
	if !player.input_enabled: return
	
	position = player.position
	
	for point : int in points.size():
		var drift_strength := point as float / points.size() as float
		points[point].x = drift_strength * -player.velocity.x
