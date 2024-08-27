extends TextureButton

var normal_tex_atlas : AtlasTexture = preload("res://Sprites/UI/LevelButtonAtlas.tres") as AtlasTexture
var highlight_tex_atlas : AtlasTexture = preload("res://Sprites/UI/LevelHighlightAtlas.tres") as AtlasTexture
var lock_tex : Texture2D = preload("res://Sprites/UI/LockButton.png") as Texture2D
var lock_hover_tex : Texture2D = preload("res://Sprites/UI/LockButton_Press.png") as Texture2D
var atlas_region : Rect2
var accessible : bool

@export var atlas_coords : Vector2
@export var level_index : int

@onready var locked_sfx: AudioStreamPlayer = $"../../LockedSFX"

signal load_level(index:int)

func _ready() ->void: #TODO Change this into a function called by LevelButtonContainer?
	atlas_region = Rect2(atlas_coords, Vector2(16, 16))
	normal_tex_atlas.region = atlas_region
	highlight_tex_atlas.region = atlas_region
	
	# If level this button refers to isn't completed, display locked icons instead
	# (Except if this button refers to level 1) :)
	accessible = GameManager.instance.level_progress[level_index]
	if accessible:
		texture_normal = normal_tex_atlas.duplicate()
		texture_hover = highlight_tex_atlas.duplicate()
	else:
		texture_normal = lock_tex
		texture_hover = lock_hover_tex

func on_level_button_pressed() ->void:
	if accessible:
		emit_signal("load_level", level_index)
	else:
		locked_sfx.play()
