extends Control
class_name MenuClaw 

@onready var claw_sprite: TextureRect = $ClawSprite
@onready var grab_sprite: TextureRect = $ClawSprite/GrabObj
@onready var start_block: TextureRect = $"../StartButtonContainer/StartButton/StartTexture"
@onready var select_block: TextureRect = $"../StartButtonContainer/LevelSelectbutton/LvlSelectTexture"
@onready var level_button_parent: HFlowContainer = $"../LevelButtonContainer"
@onready var grab_sfx: AudioStreamPlayer = $Grab_SFX
@onready var claw_open_tex: Texture2D = preload("res://Sprites/ClawOpen_Swap.png")
@onready var claw_closed_tex: Texture2D = preload("res://Sprites/ClawClosed_Swap.png")
@onready var start_tex : Texture2D = preload("res://Sprites/UI/ResumeButton.png")
@onready var select_tex : Texture2D = preload("res://Sprites/UI/LvlSelectButton.png")
@onready var empty_tex : Texture2D = preload("res://Sprites/UI/Empty.png")

func menu_start() ->void:
	# Move claw to idle position
	start_block.texture = start_tex
	select_block.texture = select_tex
	await get_tree().create_timer(0.5).timeout
	
	var move_pos := Vector2(32.0, 64.0)
	claw_sprite.texture = claw_open_tex
	grab_sprite.hide()
	
	var start_tween = get_tree().create_tween()
	start_tween.set_trans(Tween.TRANS_BACK)
	start_tween.set_ease(Tween.EASE_OUT)
	start_tween.tween_property(self, "position", move_pos, 1.6)
	await start_tween.finished

func start_button_pressed() ->void:
	# Tween claw to button position
	var move_pos = start_block.get_global_transform_with_canvas().get_origin() + Vector2(8.0, 8.0)
	await move_claw_in(move_pos)
	
	# Claw grabs button, button disappears
	await get_tree().create_timer(0.2).timeout
	claw_sprite.texture = claw_closed_tex
	grab_sprite.texture = start_tex
	grab_sprite.show()
	start_block.texture = null
	grab_sfx.play()
	await get_tree().create_timer(0.2).timeout
	
	# Claw tweens away with button
	await move_claw_out(Vector2(position.x, position.y - 160.0))

func lvl_select_button_pressed() ->void:
	# Tween claw to button position
	var move_pos = select_block.get_global_transform_with_canvas().get_origin() + Vector2(8.0, 8.0)
	await move_claw_in(move_pos)
	
	# Claw grabs button, button disappears
	await get_tree().create_timer(0.2).timeout
	claw_sprite.texture = claw_closed_tex
	grab_sprite.texture = select_tex
	grab_sprite.show()
	select_block.texture = null
	grab_sfx.play()
	await get_tree().create_timer(0.2).timeout
	
	# Claw tweens away with button
	await move_claw_out(Vector2(position.x, position.y - 160.0))

func level_button_pressed(index : int) ->void:
	# Tween claw to button position
	var level_button : TextureButton = level_button_parent.get_child(index) as TextureButton
	var move_pos := level_button.get_global_transform_with_canvas().get_origin() + Vector2(8.0, 6.0)
	await move_claw_in(move_pos)
	
	# Claw grabs button, button disappears
	await get_tree().create_timer(0.2).timeout
	claw_sprite.texture = claw_closed_tex
	grab_sprite.texture = level_button.texture_normal
	grab_sprite.show()
	var lvl_button_container := get_node("../LevelButtonContainer") as Control # Ugly, but it works
	lvl_button_container.self_modulate = Color8(128, 128, 128, 255)
	level_button.texture_normal = empty_tex
	grab_sfx.play()
	await get_tree().create_timer(0.2).timeout
	
	# Claw tweens away with button
	await move_claw_out(Vector2(position.x, position.y - 160.0))

func move_claw_in(pos:Vector2) ->void:
	grab_sprite.hide()
	var to_tween = get_tree().create_tween()
	to_tween.set_trans(Tween.TRANS_SINE)
	to_tween.set_ease(Tween.EASE_IN_OUT)
	to_tween.tween_property(self, "position", pos, 1.0)
	await to_tween.finished

func move_claw_out(pos:Vector2) ->void:
	var out_tween = get_tree().create_tween()
	out_tween.set_trans(Tween.TRANS_BACK)
	out_tween.set_ease(Tween.EASE_IN)
	out_tween.tween_property(self, "position", pos, 1.6)
	await out_tween.finished
