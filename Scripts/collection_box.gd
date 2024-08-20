extends StaticBody2D

@onready var area_sprite: AnimatedSprite2D = $CollectionArea/AreaSprite
@onready var arrow_sprite: Sprite2D = $ArrowSprite

func _ready() -> void:
	area_sprite.play("default")

func on_area_entered(body:Node2D) ->void:
	var collect_obj := body as Grab_Block
	if collect_obj.block_data.get_obj_action() == BlockData.Object_Action.WIN:
		collect_obj.dissolve()
		arrow_sprite.hide()
		GameManager.instance.win()

#func display_arrow(active:bool) ->void:
	#arrow_sprite.visible = active
