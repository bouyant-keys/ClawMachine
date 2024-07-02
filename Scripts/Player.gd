extends CharacterBody2D
class_name Player

static var input_enabled := true
static var retries := 0

const ACCEL := 15.0
const DECEL := 60.0
const MAX_VEL_Y := 600.0
const MAX_VEL_X := 600.0
#const VERTICAL_SPEED := 1000.0
#const SPEED_CHANGE := 400.0

var health := 3
var grab_obj : Grab_Block
var grabbing := false
var hurting := false
var in_center_screen := false
var vert_dir := 0.0
var y_speed := 0.0
var start_pos : Vector2

var x_dir := 0.0
var y_dir := 0.0
var prev_x_dir : float
var prev_y_dir : float


enum PlayerState {IDLE, MOVING}

@export var current_player_state : PlayerState
#@export_node_path() var ghost_parent_path

@onready var claw_sprite = $ClawSprite as AnimatedSprite2D
@onready var grab_sprite = $GrabObj_Sprite as Sprite2D
@onready var hurt_area: Area2D = $HurtArea
@onready var remote_trans = $RemoteTransform2D as RemoteTransform2D
@onready var invi_timer: Timer = $InvincibleTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var player_anim: AnimationPlayer = $player_anim
@onready var tick_anim: AnimationPlayer = $tick_anim
@onready var grab_sfx = $Grab_SFX as AudioStreamPlayer
@onready var clamp_sfx = $Clamp_SFX as AudioStreamPlayer
#@onready var ghost_parent = get_node(ghost_parent_path) as Node2D
#@onready var ghost_sprite := preload("res://Scenes/ghost_sprite.tscn")

signal player_lose
signal update_health(int)
signal update_depth(float)
signal update_tutorial(String)
signal set_display(active:bool)
signal swap_display(set_top:bool)
signal set_cam_follow(bool)
signal cam_shake
signal goal_grabbed(bool)


func _ready():
	grab_sprite.texture = null
	claw_sprite.play("Open")
	start_pos = position

func _physics_process(delta):
	if !input_enabled: return
	
	var move_dir := Vector2(x_dir * MAX_VEL_X, y_dir * MAX_VEL_Y)
	velocity = move_dir * delta
	
	if tick_anim.is_playing(): tick_anim.speed_scale = abs(y_dir)
	
	update_depth.emit(position.y)
	check_screen_pos()
	move_and_slide()

func check_screen_pos() ->void:
	var screen_y := get_global_transform_with_canvas().get_origin().y
	
	if screen_y < 32.0 or screen_y > 112.0: # if not in center
		if !in_center_screen: return
		emit_signal("set_display", false)
		in_center_screen = false
	else: # if in center
		if in_center_screen: return
		emit_signal("set_display", true)
		#print("activating display - " + str(screen_pos.y))
		in_center_screen = true

func update_v_movement(dir:float) ->void:
	y_dir = (2.0 * dir) - 1.0 # Converting 0<->1 value to -1<->1

func update_h_movement(dir:float) ->void:
	x_dir = (2.0 * dir) - 1.0 # Converting 0<->1 value to -1<->1

#func swap_movement_direction() ->void:
	#vert_dir *= -1.0
	#up_direction *= -1.0
	#emit_signal("swap_display", vert_dir > 0.0)
#
#func change_lowering_speed(new_vel:float, time:float) ->void:
	#if vert_dir == new_vel: return
	#
	#var vert_vel_tween := get_tree().create_tween()
	#vert_vel_tween.tween_method(set_v_velocity, vert_dir, new_vel, time)
#
#func set_v_velocity(value:float) ->void:
	#vert_dir = value
	#tick_anim.speed_scale = 1.0 - (abs(value) * 0.2)
#
#func change_player_state(new_state:PlayerState):
	#if current_player_state == new_state: return
	#
	#current_player_state = new_state

func on_hit() ->void:
	health -= 1
	emit_signal("update_health", health)
	
	if health != 0:
		invi_timer.start()
		player_anim.play("invincible")
	else:
		retries += 1
		player_lose.emit()

# Grab / Release Functions
func on_grab_pressed() ->void:
	if !grabbing: grab()
	else: release()

func grab() ->void:
	if !grab_obj:
		clamp_sfx.play()
		claw_sprite.play("EmptyGrab")
		return
	
	if grab_obj.block_data.obj_action == BlockData.Object_Action.WIN:
		goal_grabbed.emit(true)
	
	#swap_movement_direction()
	grabbing = true
	grab_obj.on_grab()
	remote_trans.remote_path = grab_obj.get_path()
	grab_sprite.texture = grab_obj.get_sprite()
	grab_sfx.play()
	claw_sprite.play("Closed")

func release() ->void:
	if grab_obj.block_data.obj_action == BlockData.Object_Action.WIN:
		goal_grabbed.emit(false)
	
	#swap_movement_direction()
	grabbing = false
	grab_obj.on_release()
	remote_trans.remote_path = ""
	grab_sprite.texture = null
	claw_sprite.play("Open")
	grab_obj = null

# Timer Timeouts

func on_invincible_timeout() ->void:
	if !hurting:
		player_anim.stop()
		return
	
	on_hit()

func on_idle_timeout() ->void:
	set_display.emit(true)
	update_tutorial.emit("Start (SPACE)")

# Area Functions

func on_grab_area_entered(area:Area2D) ->void:
	if grabbing: return
	
	var temp_obj := area.get_parent()
	if temp_obj is Grab_Block: 
		grab_obj = temp_obj
		emit_signal("update_tutorial", "Grab (E)")

func on_grab_area_exited(area:Area2D) ->void:
	if grabbing: return
	
	var temp_obj := area.get_parent()
	if grab_obj == temp_obj: 
		grab_obj = null
		emit_signal("update_tutorial", "")

func on_hurt_area_entered(_body:Node2D) ->void:
	if !hurting:
		hurting = true
		on_hit()
	print("Hurting: " + str(hurting))

func on_hurt_area_exited(_body:Node2D) ->void:
	if hurt_area.get_overlapping_areas().size() == 0: hurting = false
	print("Hurting: " + str(hurting))

# Enable / Disable / Reset Functions

func freeze(frozen:bool) ->void:
	if frozen:
		input_enabled = false
		tick_anim.stop()
	else:
		input_enabled = true
		if current_player_state == PlayerState.MOVING:
			tick_anim.play("tick_loop")
	
	print(tick_anim.is_playing())

func enable_input() ->void:
	input_enabled = true

func disable_input() ->void:
	input_enabled = false

func reset() ->void:
	if grabbing: release()
	#change_player_state(PlayerState.IDLE)
	y_dir = 0.0
	x_dir = 0.0
	grab_sprite.texture = null
	claw_sprite.play("Open")
	#vert_dir = 0.0
	#up_direction = Vector2(0.0, -1.0)
	velocity = Vector2.ZERO
	position = start_pos


