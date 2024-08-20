extends Control

var normal_fill := preload("res://Sprites/UI/DepthMeter_Fill.png") as Texture2D
var goal_fill := preload("res://Sprites/UI/FillFrames/DepthFillAnim.tres") as AnimatedTexture
#var on_hp_sprite = preload("res://Sprites/UI/hp_unit.png") as Texture2D
#var off_hp_sprite = preload("res://Sprites/UI/hpoff_unit.png") as Texture2D

@onready var depth_meter: TextureProgressBar = $DepthMeter
@onready var ui_anim: AnimationPlayer = $DisplayAnim
@onready var hp_units = [$HBoxContainer/TextureRect as TextureRect, 
							$HBoxContainer/TextureRect2 as TextureRect, 
							$HBoxContainer/TextureRect3 as TextureRect]

func update_health(value:float) ->void:
	var temp = value
	for unit in hp_units:
		if temp == 3.0: 
			unit.show()
			continue
		else:
			unit.hide()
		temp += 1.0

func update_depth(value:float) ->void:
	depth_meter.value = value

func update_depth_fill(active:bool) ->void:
	if active:
		depth_meter.texture_progress = goal_fill
	else:
		depth_meter.texture_progress = normal_fill

#func enable_arrows(top_arrows:bool) ->void:
	#if top_arrows: 
		#t_arrows.show()
		#b_arrows.hide()
	#else:
		#t_arrows.hide()
		#b_arrows.show()
	#
	#ui_anim.play("ArrowBlink")

#func disable_arrows() ->void:
	#if ui_anim.is_playing(): ui_anim.stop()
	#
	#t_arrows.hide()
	#b_arrows.hide()

func reset() ->void:
	depth_meter.value = 0.0
	depth_meter.texture_progress = normal_fill

func hide_self() ->void: hide()
func show_self() ->void: show()
