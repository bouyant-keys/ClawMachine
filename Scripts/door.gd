extends StaticBody2D

@export var is_open := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

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
	
	is_open = set_open
	if is_open: 
		sprite.play("Opening")
		await sprite.animation_finished
		sprite.play("Open")
		collision.disabled = true
	else:
		sprite.play("Closing")
		await sprite.animation_finished
		sprite.play("Closed")
		collision.disabled = false
