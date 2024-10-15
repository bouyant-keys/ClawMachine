extends Node

const DEFAULT_VOL := -12.0 # in dB

# @onready var menu_song : AudioStream = preload("res://Audio/Music/Blippy Trance Edit.wav") as AudioStream
# @onready var game_song : AudioStream = preload("res://Audio/Music/513555_Insomnia-Dreams.mp3") as AudioStream
@onready var menu_player: AudioStreamPlayer = $MenuPlayer
@onready var game_player: AudioStreamPlayer = $GamePlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#game_player.play()
	#await get_tree().create_timer(0.01).timeout
	#game_player.stop()
	
	start_music()

func start_music() ->void:
	# music_player.stream = menu_song
	#music_player.volume_db = -80.0
	#music_player.play()
	menu_player.play()

func pause_music() ->void:
	#music_player.stream_paused = true;
	game_player.stream_paused = true;

func resume_music() ->void:
	game_player.stream_paused = false;

func stop_music() ->void:
	menu_player.stop()
	game_player.stop()

# Signaled functions

func lower_vol() ->void:
	tween_vol(DEFAULT_VOL, -18.0, 0.8)

func raise_vol() ->void:
	tween_vol(-18.0, DEFAULT_VOL, 0.8)

func change_song(menu:bool) ->void: #maybe alter to fade out, then start next song
	await tween_vol(DEFAULT_VOL, -64.0, 1.0)
	
	if menu: 
		game_player.stop()
		menu_player.play()
	else: 
		menu_player.stop()
		await get_tree().create_timer(0.4).timeout
		game_player.play() #183.0
		#music_player.stream = game_song
		#music_player.play(183.0)
	
	tween_vol(-64.0, DEFAULT_VOL, 1.0)

func tween_vol(start:float, end:float, duration:float) ->void:
	var vol_tween = get_tree().create_tween()
	vol_tween.set_trans(Tween.TRANS_CUBIC)
	vol_tween.set_ease(Tween.EASE_IN)
	vol_tween.tween_method(change_volume, start, end, duration)
	await vol_tween.finished

func change_volume(value:float) ->void:
	menu_player.volume_db = value
	game_player.volume_db = value
