extends StaticBody2D

@onready var area_sprite: AnimatedSprite2D = $CollectionArea/AreaSprite
#@onready var stars: GPUParticles2D = $StarParticles
#@onready var arrow: Sprite2D = $ArrowSprite

signal win_signal


func _ready() -> void:
	area_sprite.play("default")

func on_area_entered(body:Node2D) ->void:
	var collect_obj := body as Grab_Block
	if collect_obj.block_data.get_obj_action() == BlockData.Object_Action.WIN:
		emit_signal("win_signal")

func display_arrow(active:bool) ->void: pass
	#arrow.visible = active
	#stars.emitting = active
