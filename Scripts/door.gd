extends StaticBody2D

@export var is_open := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var open_sfx: AudioStreamPlayer = $DoorOpen_SFX
@onready var close_sfx: AudioStreamPlayer = $DoorClose_SFX

func _ready() -> void:
	if is_open:
		sprite.play("Open")
		collision.disabled = true
	else:
		sprite.play("Closed")
		collision.disabled = false

func open() ->void:
	set_door_state(true)

func close() ->void:
	set_door_state(false)

func set_door_state(set_open:bool) ->void:
	if set_open == is_open: return
	
	if set_open: 
		sprite.play("Opening")
		open_sfx.play()
		await sprite.animation_finished
		sprite.play("Open")
		collision.disabled = true
	else:
		sprite.play("Closing")
		close_sfx.play()
		await sprite.animation_finished
		sprite.play("Closed")
		collision.disabled = false
	
	is_open = set_open
