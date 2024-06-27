extends Area2D

signal win_signal

@onready var arrow: Sprite2D = $ArrowSprite

func on_area_entered(body:Node2D) ->void:
	if win_signal.get_connections().size() == 0: 
		printerr("WinArea signal win_signal has no connections!")
		return
	
	var collect_obj := body as Grab_Block
	if collect_obj.block_data.get_obj_action() == BlockData.Object_Action.WIN:
		win_signal.emit()
	#var collect_type := collect_obj.block_data.get_obj_action()
	#match collect_type:
		#BlockData.Object_Action.NONE:
			#print("! ! NOTHING ! !")
		#BlockData.Object_Action.COINS:
			#print("! ! COINS ! !")
		#BlockData.Object_Action.WIN:
			#print("! ! WIN ! !")
			#emit_signal("win_signal")

func display_arrow(active:bool) ->void:
	arrow.visible = active
