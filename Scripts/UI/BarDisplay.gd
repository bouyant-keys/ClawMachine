extends TextureRect

var on_display := false
var on_hp_sprite = preload("res://Sprites/UI/hp_unit.png") as Texture2D
var off_hp_sprite = preload("res://Sprites/UI/hpoff_unit.png") as Texture2D

@export var onscreen_y : float
@export var offscreen_y : float

@onready var ticket_label = $TicketLabel as Label
@onready var hp_units = [$HBoxContainer/TextureRect as TextureRect, 
							$HBoxContainer/TextureRect2 as TextureRect, 
							$HBoxContainer/TextureRect3 as TextureRect]

func update_tickets(value:int) ->void:
	ticket_label.text = "x" + str(value)

func update_time(value:int) ->void:
	var min := value % 60

func update_health(value:int) ->void: 
	var temp := 0
	for unit in hp_units:
		if temp > value - 1:
			unit.texture = on_hp_sprite
		else:
			unit.texture = off_hp_sprite
		temp += 1

func set_display(active:bool) ->void:
	if active == on_display: return
	
	var bar_tween = get_tree().create_tween()
	if active:
		bar_tween.tween_property(self, "position", Vector2(0, onscreen_y), 0.5)
		on_display = true
	else:
		bar_tween.tween_property(self, "position", Vector2(0, offscreen_y), 0.5)
		on_display = false
