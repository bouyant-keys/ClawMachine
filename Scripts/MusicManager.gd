extends Node

@onready var music_player = $MusicPlayer as AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_music()

func start_music() ->void:
	music_player.play()

func stop_music() ->void:
	music_player.stop()

#func change_music(value:int) ->void: pass

func change_volume(value:float) ->void:
	music_player.volume_db = value
