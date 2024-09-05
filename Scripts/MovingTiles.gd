extends Path2D

var paused := false
var obj : Node2D

@export var display_pos := false
@export_node_path() var move_obj_path

@export var closed_loop : bool
@export var speed := 2.0
@export var speed_scale := 1.0

@onready var follower: PathFollow2D = $PathFollow2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var path_tex: Line2D = $PathTex
#@onready var remote: RemoteTransform2D = $PathFollow2D/RemoteTransform2D


func _ready() -> void:
	#remote.remote_path = move_obj_path
	obj = get_node(move_obj_path) as Node2D
	
	if !closed_loop: 
		anim.play("move")
		anim.speed_scale = speed_scale
		#set_process(display_pos)
		#paused = display_pos

func _process(delta: float) -> void:
	if closed_loop: 
		follower.progress += (speed * speed_scale) * delta
	
	obj.global_position = follower.global_position

func pause() ->void:
	paused = true
	if !closed_loop: anim.stop()

func unpause() ->void:
	paused = false 
	if !closed_loop: anim.play("move")

