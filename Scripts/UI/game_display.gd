extends Control

@onready var depth_meter: TextureProgressBar = $DepthMeter
@onready var t_arrows: TextureRect = $TopArrows
@onready var b_arrows: TextureRect = $BottomArrows
@onready var ui_anim: AnimationPlayer = $DisplayAnim
@onready var normal_fill := preload("res://Sprites/UI/DepthMeter_Fill.png") as Texture2D
@onready var goal_fill := preload("res://Sprites/UI/FillFrames/DepthFillAnim.tres") as AnimatedTexture

func update_health(value:float) ->void:
	pass
	#top_bar.update_health(value)
	#bottom_bar.update_health(value)

func update_depth(value:float) ->void:
	depth_meter.value = value

func update_depth_fill(active:bool) ->void:
	if active:
		depth_meter.texture_progress = goal_fill
	else:
		depth_meter.texture_progress = normal_fill

func enable_arrows(top_arrows:bool) ->void:
	if top_arrows: 
		t_arrows.show()
		b_arrows.hide()
	else:
		t_arrows.hide()
		b_arrows.show()
	
	ui_anim.play("ArrowBlink")

func disable_arrows() ->void:
	if ui_anim.is_playing(): ui_anim.stop()
	
	t_arrows.hide()
	b_arrows.hide()

func reset() ->void:
	depth_meter.value = 0.0
	depth_meter.texture_progress = normal_fill
