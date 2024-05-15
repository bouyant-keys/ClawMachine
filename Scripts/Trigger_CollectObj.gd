extends Area2D

#signal load_level(NodePath)
signal win_signal

func on_area_entered(area:Area2D) ->void:
	if win_signal.get_connections().size() == 0: 
		printerr("WinArea signal win_signal has no connections!")
		return
	
	var collect_obj = area.get_parent() as Grabbable
	var collect_type = collect_obj.action
	match collect_type:
		collect_obj.Object_Action.NONE:
			print("! ! NOTHING ! !")
		#collect_obj.Object_Action.LEVEL_LOAD:
			#print("LOAD LEVEL: " + str(collect_obj.get_level_path()))
			#emit_signal("load_level", collect_obj.get_level_path())
		collect_obj.Object_Action.WIN:
			print("! ! WIN ! !")
			emit_signal("win_signal")
