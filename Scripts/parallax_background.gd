extends ParallaxBackground

@onready var game_far: ParallaxLayer = $Game_Far
@onready var game_mid: ParallaxLayer = $Game_Mid
@onready var menu_far: ParallaxLayer = $Menu_Far
@onready var menu_mid: ParallaxLayer = $Menu_Mid
@onready var menu_near: ParallaxLayer = $Menu_Near

func set_menu_background() ->void:
	game_far.hide()
	game_mid.hide()
	menu_far.show()
	menu_mid.show()
	menu_near.show()

func set_game_background() ->void:
	game_far.show()
	game_mid.show()
	menu_far.hide()
	menu_mid.hide()
	menu_near.hide()
