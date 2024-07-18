extends CharacterBody2D
class_name Player

static var input_enabled := true
static var grabbing := false

const MAX_VEL_Y := 1000.0
const PULL_VEL_X := 60.0

var health := 3
var grab_obj : Grab_Block
var moving := false
var start_pos : Vector2
var goal : Node2D
var total_goal_dist : float
var grabbed_goal := false

var x_pos := 0.0
var y_dir := 0.0

#enum PlayerState {IDLE, MOVING}
#@export var current_player_state : PlayerState

@onready var claw_sprite = $ClawSprite as AnimatedSprite2D
@onready var grab_sprite = $GrabObj_Sprite as Sprite2D
@onready var hurt_area: Area2D = $HurtArea
@onready var remote_trans = $RemoteTransform2D as RemoteTransform2D
@onready var claw_anim: AnimationPlayer = $ClawAnim
@onready var invincible_anim: AnimationPlayer = $InvincibleAnim
@onready var grab_sfx = $Grab_SFX as AudioStreamPlayer
@onready var clamp_sfx = $Clamp_SFX as AudioStreamPlayer
@onready var bump_sfx: AudioStreamPlayer = $Bump_SFX
@onready var move_sfx: AudioStreamPlayer = $Move_SFX
@onready var zap_sfx: AudioStreamPlayer = $Zap_SFX

signal player_lose
signal update_health(int)
signal update_depth(float)
signal obj_nearby(bool)
signal set_cam_follow(bool)
signal wall_bumped(at:Vector2)
signal cam_shake
signal goal_grabbed(bool)


func _ready():
	grab_sprite.texture = null
	claw_sprite.play("Open")
	start_pos = position

func _physics_process(delta):
	if !input_enabled or !moving: return
	
	var x_vel : float = (x_pos - position.x) * PULL_VEL_X
	var y_vel : float = y_dir * MAX_VEL_Y
	velocity = Vector2(x_vel, y_vel) * delta
	
	check_dist_from_goal()
	if move_and_slide():
		var collision := get_last_slide_collision()
		if velocity.length() != 0.0: on_bump(collision.get_position())

func check_dist_from_goal() ->void:
	if grabbed_goal: return
	
	var dist := goal.global_position.y - global_position.y
	var n_dist := dist / total_goal_dist #normalized dist
	n_dist = (n_dist - 1.0) * -1.0
	
	update_depth.emit(n_dist)

func update_v_movement(dir:float) ->void:
	moving = true
	y_dir = (2.0 * dir) - 1.0 # Converting 0<->1 value to -1<->1
	
	if y_dir != 0.0: move_sfx.play()
	elif move_sfx.playing: move_sfx.stop()

func update_h_movement(new_pos:float) ->void:
	moving = true
	x_pos = new_pos

func set_goal(obj:Node2D) ->void:
	goal = obj
	total_goal_dist = absf(goal.global_position.y - start_pos.y)
	print("Dist to goal from start_pos: " + str(total_goal_dist))

# Needs to be activated from somewhere
func on_bump(pos:Vector2) ->void:
	claw_anim.play("bump")
	#bump_sfx.pitch_scale = randf_range(1.0, 2.5)
	#bump_sfx.play()
	wall_bumped.emit(pos) #maybe pass collision point ?

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
		grabbed_goal = true
		goal_grabbed.emit(true)
		update_depth.emit(1.0)
	
	#swap_movement_direction()
	grabbing = true
	grab_obj.on_grab()
	remote_trans.remote_path = grab_obj.get_path()
	grab_sprite.texture = grab_obj.get_sprite()
	grab_sfx.play()
	claw_sprite.play("Closed")

func release() ->void:
	if grab_obj.block_data.obj_action == BlockData.Object_Action.WIN:
		grabbed_goal = false
		goal_grabbed.emit(false)
	
	#swap_movement_direction()
	grabbing = false
	grab_obj.on_release()
	remote_trans.remote_path = ""
	grab_sprite.texture = null
	claw_sprite.play("Open")
	grab_obj = null

# Hurt Functions

func on_hit() ->void:
	zap_sfx.play()
	health -= 1
	emit_signal("update_health", health)
	
	if health != 0:
		invincible_anim.play("invincible")
	else:
		GameManager.deaths += 1
		emit_signal("player_lose")
	
	await invincible_anim.animation_finished
	
	if hurt_area.get_overlapping_areas().size() != 0:
		print("still in hurt area")
		on_hit()

# Area Functions

func on_grab_area_entered(area:Area2D) ->void:
	if grabbing: return
	
	var temp_obj := area.get_parent()
	if temp_obj is Grab_Block: 
		grab_obj = temp_obj
		obj_nearby.emit(true)

func on_grab_area_exited(area:Area2D) ->void:
	if grabbing: return
	
	var temp_obj := area.get_parent()
	if grab_obj == temp_obj: 
		grab_obj = null
		obj_nearby.emit(false)

func on_hurt_area_entered(_body:Node2D) ->void:
	print("Hurt area entered")
	if invincible_anim.is_playing(): return
	
	on_hit()

# Enable / Disable / Reset Functions

func freeze(frozen:bool) ->void:
	if frozen:
		input_enabled = false
		move_sfx.stop()
	else:
		input_enabled = true
		if y_dir != 0.0:
			move_sfx.play()

func reset() ->void:
	if grabbing: release()
	
	health = 3
	emit_signal("update_health", health)
	y_dir = 0.0
	x_pos = 0.0
	moving = false
	grab_sprite.texture = null
	claw_sprite.play("Open")
	velocity = Vector2.ZERO
	position = start_pos
