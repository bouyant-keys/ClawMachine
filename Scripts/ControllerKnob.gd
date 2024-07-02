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

signal v_dir_changed(value:float)
signal h_dir_changed(value:float)
#signal v_dir_changed(value:float)

func _ready() -> void:
	x_min = left_point.position.x
	x_max = right_point.position.x
	center_x = center_point.position.x
	center_y = center_point.position.y + 128.0 # Need to add 128 to y-values to compensate for parent control's pos
	y_min = up_point.position.y + 128.0 # Because y+ is down in godot, the up point is y_min
	y_max = down_point.position.y + 128.0

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
	var temp_x := clampf(drag_pos.x, x_min, x_max)
	var temp_y := clampf(drag_pos.y, y_min, y_max)
	
	# Normalize values for the player
	var normal_x := (temp_x - x_min) / (x_max - x_min)
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
	
	position = Vector2(temp_x, temp_y - 128.0)
	h_dir_changed.emit(normal_x)
	v_dir_changed.emit(normal_y)
	#print("Drag_pos: " + str(drag_pos.y) + " |Temp_y: " + str(temp_y) + " | Normal_y: " + str(normal_y))

func reset_knob() ->void:
	position = Vector2(center_x, center_y)

func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false
