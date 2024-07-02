extends ColorRect
class_name Transition_Shader

var dir : Vector2

@export var wipe_time := 1.5
@export var hold_time := 1.0

@onready var level_label: Label = $LevelChangeText
@onready var level_sfx: AudioStreamPlayer = $LevelChange_SFX
@onready var fade_in_sfx: AudioStreamPlayer = $FadeIn_SFX
@onready var fade_out_sfx: AudioStreamPlayer = $FadeOut_SFX
#@onready var level_pfx: GPUParticles2D = $LevelChangeParticles

#signal start_transition
#signal end_transition
signal change_palette(int)

func _ready() -> void:
	show()
	level_label.hide()
	material.set_shader_parameter("progress", 1.0)

func fade_out(new_dir:Vector2) ->void:
	show()
	
	var mult = 0.0
	dir = new_dir
	material.set_shader_parameter("direction", dir)
	
	if dir.x < 0.0 or dir.y < 0.0: mult = -0.5
	material.set_shader_parameter("mult", mult)
	
	var wipe_tween = get_tree().create_tween()
	wipe_tween.tween_method(update_shader_progress, 0.0, 1.0, wipe_time)
	#fade_out_sfx.play()
	
	await wipe_tween.finished

func fade_in(new_dir:Vector2) ->void:
	var mult = 0.0
	dir = new_dir
	material.set_shader_parameter("direction", dir)
	
	if dir.x < 0.0 or dir.y < 0.0: mult = -0.5
	material.set_shader_parameter("mult", mult)
	
	var wipe_tween = get_tree().create_tween()
	wipe_tween.tween_method(update_shader_progress, 1.0, 0.0, wipe_time)
	#fade_in_sfx.play()
	
	await wipe_tween.finished
	hide()

func update_shader_progress(value:float) ->void:
	material.set_shader_parameter("progress", value)

func play_level_change() ->void:
	level_label.text = "Level: " + str(MainLevel.current_level)
	level_label.show()
	await get_tree().create_timer(1.0).timeout
	emit_signal("change_palette", MainLevel.current_level)
	level_label.text = "Level: " + str(MainLevel.current_level+1)
	level_sfx.play()
	await get_tree().create_timer(1.0).timeout
	level_label.hide()
