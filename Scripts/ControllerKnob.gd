extends Control

var mouse_in := false
var dragging := false
var has_dragged := false

@export var min_pos := Vector2(24.0, 127.0)
@export var center_pos := Vector2(80.0, 133.0)
@export var max_pos := Vector2(132.0, 139.0)

@onready var slider: Control = $"../Slider"
#@onready var slider_sprite: TextureRect = $"../SliderSprite"
@onready var v_click_sfx: AudioStreamPlayer = $VertClick_SFX
@onready var h_click_sfx: AudioStreamPlayer = $HorizClick_SFX
@onready var arrows: Control = $Arrows

signal v_dir_changed(value:float)
signal h_dir_changed(value:float)

func _ready() -> void:
	slider.global_position.x = global_position.x
	arrows.show()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			dragging = true
			if !has_dragged: hide_arrows()
		else:
			dragging = false
	
	elif event is InputEventMouseMotion:
		if dragging:
			move_knob()

func move_knob() ->void:
	# Clamp drag position values between x and y max and mins
	var drag_pos := get_viewport().get_mouse_position()
	if global_position == drag_pos: return
	
	var temp_x := clampf(drag_pos.x, min_pos.x, max_pos.x)
	var temp_y := clampf(drag_pos.y, min_pos.y, max_pos.y)
	
	# Normalize values for the player
	#var normal_x := (temp_x - x_min) / (x_max - x_min)
	var normal_y := (temp_y - min_pos.y) / (max_pos.y - min_pos.y)
	
	# Have the y pos 'snap' between either up, middle, or down
	if normal_y > 0.7: 
		temp_y = max_pos.y
		normal_y = 1.0
	elif normal_y < 0.3: 
		temp_y = min_pos.y
		normal_y = 0.0
	else: 
		temp_y = center_pos.y
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
	slider.global_position.x = new_pos.x
	#print(global_position.x - slider_sprite.global_position.x)

func hide_arrows() ->void:
	has_dragged = true
	await get_tree().create_timer(1.0).timeout
	arrows.hide()

func reset_knob() ->void:
	global_position = center_pos

func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false
