extends TextureRect

var on_display := false
var on_hp_sprite = preload("res://Sprites/UI/hp_unit.png") as Texture2D
var off_hp_sprite = preload("res://Sprites/UI/hpoff_unit.png") as Texture2D

@export var onscreen_y : float
@export var offscreen_y : float

@onready var tutorial_text: Label = $TutorialText
@onready var time = $TimeLabel as Label
@onready var hp_units = [$HBoxContainer/TextureRect as TextureRect, 
							$HBoxContainer/TextureRect2 as TextureRect, 
							$HBoxContainer/TextureRect3 as TextureRect]

func update_tutorial(text:String) ->void:
	tutorial_text.text = text

func update_time(value:int) ->void:
	var temp := value / 10
	var min := temp / 60
	var sec := temp % 60
	time.text = str(min) + ":" + str(sec)

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
