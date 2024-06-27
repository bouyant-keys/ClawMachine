extends CharacterBody2D
class_name Player

static var input_enabled := true
static var retries := 0

const MAX_SPEED := 120.0
const ACCEL := 40.0
const DECEL := 40.0
const VERTICAL_SPEED := 1000.0
const SPEED_CHANGE := 400.0

var health := 3
var grab_obj : Grab_Block
var grabbing := false
var hurting := false
var in_center_screen := false
var vert_dir := 0.0
var y_speed := 0.0
var prev_x_dir : float
var start_pos : Vector2
var ghosts := false

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
signal update_depth(int)
signal update_tutorial(String)
signal set_display(active:bool)
signal swap_display(set_top:bool)
signal set_cam_follow(bool)
signal goal_grabbed(bool)


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
		if abs(velocity.x) > DECEL * delta:
			velocity.x -= (prev_x_dir * DECEL) * delta
		else:
			velocity.x = 0.0
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	if !is_on_floor() and current_player_state == PlayerState.MOVING:
		y_speed = vert_dir * VERTICAL_SPEED
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
			change_lowering_speed(1.0, 1.0)
			tick_anim.play("tick_loop")
		else:
			swap_movement_direction()
	
	if Input.is_action_just_pressed("Grab") && !grabbing: grab()
	elif Input.is_action_just_released("Grab") && grabbing: release()
	
	tick_anim.speed_scale = abs(y_speed / VERTICAL_SPEED)
	check_screen_pos()

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

func swap_movement_direction() ->void:
	vert_dir *= -1.0
	up_direction *= -1.0
	emit_signal("swap_display", vert_dir > 0.0)

func change_lowering_speed(new_vel:float, time:float) ->void:
	if vert_dir == new_vel: return
	
	var vert_vel_tween := get_tree().create_tween()
	vert_vel_tween.tween_method(set_v_velocity, vert_dir, new_vel, time)

func set_v_velocity(value:float) ->void:
	vert_dir = value
	tick_anim.speed_scale = 1.0 - (abs(value) * 0.2)

func change_player_state(new_state:PlayerState):
	if current_player_state == new_state: return
	
	current_player_state = new_state

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

func grab() ->void:
	if !grab_obj:
		clamp_sfx.play()
		claw_sprite.play("EmptyGrab")
		return
	
	if grab_obj.block_data.obj_action == BlockData.Object_Action.WIN:
		goal_grabbed.emit(true)
	
	swap_movement_direction()
	grabbing = true
	grab_obj.on_grab()
	remote_trans.remote_path = grab_obj.get_path()
	grab_sprite.texture = grab_obj.get_sprite()
	grab_sfx.play()
	claw_sprite.play("Closed")

func release() ->void:
	if grab_obj.block_data.obj_action == BlockData.Object_Action.WIN:
		goal_grabbed.emit(false)
	
	swap_movement_direction()
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

#func on_ghost_timeout() -> void:
	#var ghost_instance := ghost_sprite.instantiate()
	#ghost_instance.position = self.position
	#ghost_parent.add_child(ghost_instance)

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

func on_hurt_area_entered(body:Node2D) ->void:
	if !hurting:
		hurting = true
		on_hit()

func on_hurt_area_exited(body:Node2D) ->void:
	if hurt_area.get_overlapping_areas().size() == 0: hurting = false
	print("Hurting: " + str(hurting))

# Enable / Disable / Reset Functions

func freeze(frozen:bool) ->void:
	if frozen:
		input_enabled = false
		tick_anim.stop()
	else:
		input_enabled = true
		tick_anim.play("tick_loop")

func enable_input() ->void:
	input_enabled = true

func disable_input() ->void:
	input_enabled = false

func reset() ->void:
	if grabbing: release()
	change_player_state(PlayerState.IDLE)
	grab_sprite.texture = null
	claw_sprite.play("Open")
	vert_dir = 0.0
	up_direction = Vector2(0.0, -1.0)
	velocity = Vector2.ZERO
	position = start_pos


