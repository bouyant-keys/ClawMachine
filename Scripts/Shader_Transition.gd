extends Control

var shader : Material
var shader_tween : Tween

@export var black_tex : Texture2D
@export var clear_tex : Texture2D

@onready var colorrect = $ColorRect as ColorRect

signal transition_start
signal transition_end


func _ready() ->void:
	shader = colorrect.material
	shader.set_shader_parameter("t", 0.0)
	hide()

func _process(delta):
	if Input.is_action_just_pressed("Transition"):
		transition()

func transition() ->void:
	colorrect.color = Vector4(0.0, 0.0, 0.0, 0.0)
	show()
	fade_out()

func fade_out() ->void:
	var img = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	shader.set_shader_parameter("before", tex)
	shader.set_shader_parameter("after", black_tex)
	emit_signal("transition_end")
	
	shader_tween.tween_property(shader, "t", 1.0, 1.0)
	await shader_tween.finished
	
	shader.set_shader_parameter("before", black_tex)
	shader.set_shader_parameter("t", 0.0)
	
	await get_tree().create_timer(1.0).timeout # Hold black screen for a moment
	fade_in()

func fade_in() ->void:
	var img = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	shader.set_shader_parameter("before", black_tex)
	shader.set_shader_parameter("after", tex)
	
	shader_tween.tween_property(shader, "t", 1.0, 1.0)
	
	await shader_tween.finished
	shader.set_shader_parameter("before", clear_tex)
	shader.set_shader_parameter("t", 0.0)
	hide()
	
	await get_tree().create_timer(1.0).timeout # Hold black screen for a moment
	emit_signal("transition_end")
