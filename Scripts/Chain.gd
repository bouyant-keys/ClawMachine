extends Line2D

var start_point_pos : PackedVector2Array

@export_node_path() var base_path
@export_node_path() var player_path
@export var move_curve : Curve

@onready var chain_base : Node2D = get_node(base_path)
@onready var player : CharacterBody2D = get_node(player_path)

func _ready() -> void:
	start_point_pos = points

func _process(_delta: float) -> void:
	#if !player.input_enabled: return
	
	# Simple adapting line by me :)
	# First create a var for each point in the array as a value between 0 and 1 based on its index, (e.g. 0 = 0, 1 = 0.1 if size = 10)
	# then using that value as the factor between Position A and Position B, (taking a line between two points, what is the position at 0.1 when normalized)
	
	for point : int in points.size(): # Why points.size() and not points.size() - 1 ? Who knows?
		var normalized_value := point as float / (points.size() - 1) as float
		var linear_point = lerp(player.position, chain_base.position, normalized_value)
		points[point] = linear_point #* (move_curve.sample(normalized_value) * (1.0 + player.velocity.normalized().x)) #Vector2(move_curve.sample(1.0 - normalized_value), linear_point.y)

func reset_chain() ->void:
	for point : int in points.size():
		points[point] = start_point_pos[point]
