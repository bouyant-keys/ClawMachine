extends TextureRect

var text_start_index : int
var on_display := false
var display_tween : Tween

@export var offscreen_pos : Vector2
@export var onscreen_pos : Vector2
@export var example_text := "------------------"
@export var scroll_text := "Crate"

@onready var label = $Label as Label

# Called when the node enters the scene tree for the first time.
func _ready() ->void:
	text_start_index = example_text.length() - 1
	
	if on_display: position = onscreen_pos
	else: position = offscreen_pos

func update_display(play:bool) ->void:
	if !play: 
		scroll_text = ""
		return
	
	if text_start_index < -(scroll_text.length() - 1): 
		text_start_index = example_text.length() - scroll_text.length()
	
	# Text manipulation time !
	var temp_text = example_text
	if text_start_index > -1:
		temp_text = temp_text.substr(0, text_start_index) + scroll_text + temp_text.substr(text_start_index)
		temp_text = temp_text.substr(0, example_text.length())
	else:
		var front_scroll_txt = scroll_text.substr(0, -text_start_index)
		var back_scroll_txt = scroll_text.substr(-text_start_index)
		temp_text = back_scroll_txt + temp_text # adding back_scroll_txt to front
		temp_text = temp_text.substr(0, example_text.length() + text_start_index) + front_scroll_txt
	
	label.text = temp_text
	text_start_index -= 1
	hold_display()

func hold_display() ->void:
	await get_tree().create_timer(0.1).timeout # Causing speed-up?
	update_display(on_display)

func update_text(new_text:String, set_display:bool) ->void:
	scroll_text = new_text
	on_display = set_display
	display_tween = get_tree().create_tween()
	display_tween.set_trans(Tween.TRANS_SPRING)
	
	if on_display:
		display_tween.tween_property(self, "position", onscreen_pos, 2.0)
	else:
		display_tween.tween_property(self, "position", offscreen_pos, 2.0)
	update_display(on_display)
