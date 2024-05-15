extends Line2D

var start_point_pos : Array[Vector2]

@export_node_path() var base_path
@export_node_path() var player_path
@export var move_curve : Curve

@onready var chain_base : Node2D = get_node(base_path)
@onready var player : CharacterBody2D = get_node(player_path)

func _process(delta: float) -> void:
	if !player.input_enabled: return
	
	#points[0] = player.position
	#points[points.size()-1] = chain_base.position
	#print(points.size())
	for point : int in points.size(): # Why points.size() and not points.size() - 1 ? Who knows?
		var normalized_value := point as float / (points.size() - 1) as float
		var linear_point = lerp(player.position, chain_base.position, normalized_value)
		print(str(point) + " | " + str(normalized_value) + " -=- " + str(linear_point))
		points[point] = linear_point * move_curve.sample(normalized_value) #Vector2(move_curve.sample(1.0 - normalized_value), linear_point.y)
