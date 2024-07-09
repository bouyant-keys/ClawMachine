extends Control

var mouse_in := false
var dragging := false
#var drag_is_vertical := false
#var dir := Vector2.ZERO
#var drag_start_pos := Vector2.ZERO

var x_min := 0.0
var x_max := 0.0
var center_x := 0.0
var center_y := 0.0
var y_min := 0.0
var y_max := 0.0

@onready var left_point: Control = $"../LeftPoint"
@onready var right_point: Control = $"../RightPoint"
@onready var center_point: Control = $"../CenterPoint"
@onready var up_point: Control = $"../UpPoint"
@onready var down_point: Control = $"../DownPoint"
@onready var v_click_sfx: AudioStreamPlayer = $VertClick_SFX
@onready var h_click_sfx: AudioStreamPlayer = $HorizClick_SFX

signal v_dir_changed(value:float)
signal h_dir_changed(value:float)
#signal v_dir_changed(value:float)

func _ready() -> void:
	x_min = left_point.global_position.x
	x_max = right_point.global_position.x
	center_x = center_point.global_position.x
	center_y = center_point.global_position.y# Needs to be global to compensate for parent control's pos
	y_min = up_point.global_position.y # Because y+ is down in godot, the up point is y_min
	y_max = down_point.global_position.y

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			dragging = true
			#drag_start_pos = get_viewport().get_mouse_position()
		else:
			dragging = false
	
	elif event is InputEventMouseMotion:
		if dragging:
			move_knob()

func move_knob() ->void:
	# Clamp drag position values between x and y max and mins
	var drag_pos := get_viewport().get_mouse_position()
	if global_position == drag_pos: return
	
	var temp_x := clampf(drag_pos.x, x_min, x_max)
	var temp_y := clampf(drag_pos.y, y_min, y_max)
	
	# Normalize values for the player
	#var normal_x := (temp_x - x_min) / (x_max - x_min)
	var normal_y := (temp_y - y_min) / (y_max - y_min)
	
	# Have the y pos 'snap' between either up, middle, or down
	if normal_y > 0.7: 
		temp_y = y_max
		normal_y = 1.0
	elif normal_y < 0.3: 
		temp_y = y_min
		normal_y = 0.0
	else: 
		temp_y = center_y
		normal_y = 0.5
	
	var new_pos := Vector2(temp_x, temp_y)
	if global_position == new_pos: return
	elif (global_position - new_pos).length() < 2.0: return
	
	if global_position.x != new_pos.x:
		h_dir_changed.emit(temp_x)
		h_click_sfx.play()
	if global_position.y != new_pos.y:
		v_dir_changed.emit(normal_y)
		v_click_sfx.play()
	
	global_position = new_pos

func reset_knob() ->void:
	position = Vector2(center_x, center_y)

func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false
