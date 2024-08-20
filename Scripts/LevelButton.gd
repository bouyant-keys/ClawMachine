extends TextureButton

var normal_tex_atlas : AtlasTexture = preload("res://Sprites/UI/LevelButtonAtlas.tres") as AtlasTexture
var highlight_tex_atlas : AtlasTexture = preload("res://Sprites/UI/LevelHighlightAtlas.tres") as AtlasTexture
var atlas_region : Rect2

@export var atlas_coords : Vector2
@export var level_index : int

signal load_level(index:int)

func _ready() ->void:
	atlas_region = Rect2(atlas_coords, Vector2(16, 16))
	
	normal_tex_atlas.region = atlas_region
	highlight_tex_atlas.region = atlas_region
	
	texture_normal = normal_tex_atlas.duplicate()
	texture_hover = highlight_tex_atlas.duplicate()

func on_level_button_pressed() ->void:
	emit_signal("load_level", level_index)
