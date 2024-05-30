extends Path2D

var paused := false

@export_node_path() var move_obj_path

@export var closed_loop : bool
@export var speed := 2.0
@export var speed_scale := 1.0

@onready var follower: PathFollow2D = $PathFollow2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var path_tex: Line2D = $PathTex
@onready var remote: RemoteTransform2D = $PathFollow2D/RemoteTransform2D


func _ready() -> void:
	remote.remote_path = move_obj_path
	
	for point : int in curve.point_count:
		path_tex.points.append(curve.get_point_position(point))
	
	if !closed_loop: 
		anim.play("move")
		anim.speed_scale = speed_scale
		set_process(false)

func _process(delta: float) -> void:
	if paused: return
	follower.progress += speed * speed_scale

func pause() ->void:
	paused = true
	if !closed_loop: anim.stop()

func unpause() ->void:
	paused = false 
	if !closed_loop: anim.play("move")

