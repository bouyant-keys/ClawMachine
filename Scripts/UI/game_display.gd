extends Control

@onready var depth_meter: TextureProgressBar = $DepthMeter
@onready var t_arrows: TextureRect = $TopArrows
@onready var b_arrows: TextureRect = $BottomArrows
@onready var ui_anim: AnimationPlayer = $DisplayAnim

func update_health(value:float) ->void:
	pass
	#top_bar.update_health(value)
	#bottom_bar.update_health(value)

func update_depth(value:float) ->void:
	depth_meter.value = value

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
	pass
	#swap_data_displays(true)
	#set_displaying(false)
