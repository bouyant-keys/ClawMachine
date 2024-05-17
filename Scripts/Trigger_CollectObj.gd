extends Area2D

#signal load_level(NodePath)
signal win_signal

func on_area_entered(area:Area2D) ->void:
	if win_signal.get_connections().size() == 0: 
		printerr("WinArea signal win_signal has no connections!")
		return
	
	var collect_obj := area.get_parent() as Grab_Block
	var collect_type := collect_obj.block_data.get_obj_action()
	match collect_type:
		BlockData.Object_Action.NONE:
			print("! ! NOTHING ! !")
		BlockData.Object_Action.COINS:
			print("! ! COINS ! !")
		BlockData.Object_Action.WIN:
			print("! ! WIN ! !")
			emit_signal("win_signal")
