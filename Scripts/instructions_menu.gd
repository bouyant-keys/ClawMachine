extends Control

var tut_stage := 0
var current_value := -1.0

@onready var test_claw : Control = $Claw
@onready var tut_text: Label = $TutorialText
@onready var move_timer: Timer = $MoveTimer

func update_tutorial() ->void:
	if tut_stage == 0:
		tut_text.text = "Move knob left and right to move claw"
	elif tut_stage == 1:
		tut_text.text = "Move knob up and down to move claw"
	elif tut_stage == 2:
		tut_text.text = "Press the grab button to pick up an object."
	elif tut_stage == 3:
		tut_text.text = "Press the grab button again to release an object."

func on_next_pressed() ->void:
	tut_stage += 1
	update_tutorial()

func tween_claw() ->void:
	var move_tween = get_tree().create_tween()
	move_tween.tween_method(move_tutorial_objs, current_value, current_value * -1.0, 1.0)

func move_tutorial_objs(value:float) ->void: # Value = -1.0 <-> 1.0
	pass
