extends Path2D

var paused := false

@export var closed_loop : bool
@export var speed := 2.0
@export var speed_scale := 1.0
@export var body_size : Vector2i
@export var body_sprite : Texture2D

@onready var follower: PathFollow2D = $PathFollow2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var block_coll: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var path_tex: Line2D = $PathTex

func _ready() -> void:
	var coll_shape := RectangleShape2D.new()
	coll_shape.size = body_size 
	block_coll.shape = coll_shape
	#
	#for point : int in curve.point_count:
		#path_tex.points.append(curve.get_point_position(point))
	
	if !closed_loop: 
		anim.play("move")
		anim.speed_scale = speed_scale
		set_process(false)

func _process(_delta: float) -> void:
	if paused: return
	follower.progress += speed * speed_scale

func pause() ->void:
	paused = true
	if !closed_loop: anim.stop()

func unpause() ->void:
	paused = false 
	if !closed_loop: anim.play("move")
