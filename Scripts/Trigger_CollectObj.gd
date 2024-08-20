extends Area2D

signal win_signal


@onready var area_sprite: AnimatedSprite2D = $AreaSprite
#@onready var arrow: Sprite2D = $ArrowSprite
@onready var stars: GPUParticles2D = $StarParticles

func _ready() -> void:
	area_sprite.play("default")

func on_area_entered(body:Node2D) ->void:
	var collect_obj := body as Grab_Block
	if collect_obj.block_data.get_obj_action() == BlockData.Object_Action.WIN:
		pass

func display_arrow(active:bool) ->void:
	#arrow.visible = active
	stars.emitting = active
