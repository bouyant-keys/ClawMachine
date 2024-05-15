extends CharacterBody2D
class_name Player

static var input_enabled := true

const MAX_SPEED := 120.0
const ACCEL := 60.0
const DECEL := 40.0
const VERTICAL_SPEED := 1000.0
const SPEED_CHANGE := 400.0

var grab_obj : Node2D
var grabbing := false
var hurting := false
var in_center_screen := false
var vert_vel := 0.0
var prev_x_dir : float
var start_pos : Vector2

enum PlayerState {IDLE, MOVING}

@export var current_player_state : PlayerState

@onready var claw_sprite = $ClawSprite as AnimatedSprite2D
@onready var grab_sprite = $GrabObj_Sprite as Sprite2D
@onready var remote_trans = $RemoteTransform2D as RemoteTransform2D
@onready var grab_sfx = $Grab_SFX as AudioStreamPlayer
@onready var clamp_sfx = $Clamp_SFX as AudioStreamPlayer
@onready var verttick_sfx = $VertTick_SFX as AudioStreamPlayer
@onready var horiztick_sfx = $HorizTick_SFX as AudioStreamPlayer

signal update_health(float)
signal update_coins(int)
signal set_display(active:bool)
signal swap_display(set_top:bool)
signal change_palette(int)
signal object_grab(String, bool)


func _ready():
	grab_sprite.texture = null
	claw_sprite.play("Open")
	start_pos = position

func _physics_process(delta):
	if !input_enabled: return
	
	# Horizontal movement works regardless of lowering
	var x_dir := Input.get_axis("Left", "Right")
	if x_dir != 0.0:
		velocity.x += (x_dir * ACCEL) * delta
		prev_x_dir = x_dir
	else:
		if abs(velocity.x) < DECEL * delta:
			velocity.x = 0.0
		else:
			velocity.x -= (prev_x_dir * DECEL) * delta
	
	if !is_on_floor() and current_player_state == PlayerState.MOVING:
		var y_speed := -vert_vel if grabbing else vert_vel
		var y_dir := Input.get_axis("Up", "Down")
		# Slow or Increase the lowering speed by pressing Up or Down
		# Works inversely when claw is moving upwards (up increases speed instead)
		y_speed += y_dir * SPEED_CHANGE
		velocity.y = y_speed * delta
	
	move_and_slide()

func _process(_delta):
	if !input_enabled: return
	
	if Input.is_action_just_pressed("Swap"):
		if current_player_state == PlayerState.IDLE: 
			change_player_state(PlayerState.MOVING)
			start_lowering()
		else:
			swap_movement_direction()
	
	if Input.is_action_just_pressed("Grab"): grab()
	elif Input.is_action_just_released("Grab"): release()
	
	if Input.is_action_just_pressed("Inc_Palette"): emit_signal("change_palette", 1)
	elif Input.is_action_just_pressed("Dec_Palette"): emit_signal("change_palette", -1)
	
	check_screen_pos()

func check_screen_pos() ->void:
	var screen_pos := get_global_transform_with_canvas().get_origin()
	
	if screen_pos.y < 32.0 or screen_pos.y > 112.0: # if not in center
		if !in_center_screen: return
		emit_signal("set_display", false)
		in_center_screen = false
	else: # if in center
		if in_center_screen: return
		emit_signal("set_display", true)
		print("activating display - " + str(screen_pos.y))
		in_center_screen = true

#func check_nearby_walls(dir:float) ->bool:
	#var space_state = get_world_2d().direct_space_state
	#var ray_end := Vector2(position.x + (8.5 * dir), position.y)
	#var top_ray = PhysicsRayQueryParameters2D.create(position, Vector2(ray_end.x, ray_end.y - 4.0), 0)
	#var bottom_ray = PhysicsRayQueryParameters2D.create(position, Vector2(ray_end.x, ray_end.y + 4.0), 0)
	#top_ray.exclude = [self]
	#bottom_ray.exclude = [self]
	#
	#var top_result := space_state.intersect_ray(top_ray)
	#var bottom_result := space_state.intersect_ray(bottom_ray)
	#
	#return !top_result.is_empty() or !bottom_result.is_empty()

func swap_movement_direction() ->void:
	vert_vel *= -1.0
	emit_signal("swap_display", vert_vel > 0.0)


func start_lowering() ->void:
	print("start_lowering")
	
	await get_tree().create_timer(1.0).timeout # Allow time for camera move
	var vert_vel_tween := get_tree().create_tween()
	vert_vel_tween.tween_property(self, "vert_vel", VERTICAL_SPEED, 1.0)

func pause_lowering() ->void:
	vert_vel = 0.0
	await get_tree().create_timer(0.5).timeout
	vert_vel = VERTICAL_SPEED

func change_player_state(new_state:PlayerState):
	if current_player_state == new_state: return
	
	current_player_state = new_state

# Grab / Release Functions

func grab() ->void:
	if grabbing: return
	elif !grab_obj:
		# clamp_sfx.play()
		claw_sprite.play("EmptyGrab")
		return
	
	pause_lowering()
	grabbing = true
	grab_obj.on_grab()
	remote_trans.remote_path = grab_obj.get_path()
	
	var data = grab_obj.get_data() as BlockData
	
	claw_sprite.play("Closed")
	grab_sprite.texture = data.get_obj_sprite()
	emit_signal("object_grab", data.get_obj_name(), true)

func release() ->void:
	if !grabbing: return
	
	pause_lowering()
	grabbing = false
	grab_sprite.texture = null
	claw_sprite.play("Open")
	remote_trans.remote_path = ""
	grab_obj.on_release()
	grab_obj = null
	emit_signal("object_grab", "Empty", false)

# Area Functions

func on_grab_area_entered(area:Area2D) ->void:
	if grabbing: return
	
	var temp_obj = area.get_parent().get_block()
	if temp_obj is Grabbable: grab_obj = temp_obj

func on_grab_area_exited(area:Area2D) ->void:
	if !grabbing: return
	
	if grab_obj == area: grab_obj = null

func on_hurt_area_entered(_area:Area2D) ->void:
	hurting = true

func on_hurt_area_exited(_area:Area2D) ->void:
	hurting = false

# Enable / Disable / Reset Functions

func enable_input() ->void:
	input_enabled = true

func disable_input() ->void:
	input_enabled = false

func reset() ->void:
	release()
	grab_sprite.texture = null
	claw_sprite.play("Open")
	position = start_pos
