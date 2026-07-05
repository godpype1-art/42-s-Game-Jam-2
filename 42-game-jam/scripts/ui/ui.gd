extends Control


@onready var	game_system: Node = get_parent()
@onready var	hud: Control = $HUD
@onready var	main_menu: Control = $Main_Menu
@onready var	pause_menu: Control = $Pause_Menu
@onready var	game_over: Control = $Game_Over_Screen


# ====================================== HELPER FUNCTIONS ========================================== #

func	hide_all() -> void:
	hud.visible = false
	main_menu.visible = false
	pause_menu.visible = false
	game_over.visible = false


# ====================================== ENGINE CALLBACKS ========================================== #

func	_ready() -> void:
	game_system.state_changed.connect(_on_changed_state)



#func	_process(_delta: float) -> void:

# ====================================== SIGNAL CALLBACKS ========================================== #

func	_on_changed_state(_old_state, new_state) -> void:

	hide_all()
	match new_state:

		game_system.GameState.MENU:
			main_menu.visible = true
		game_system.GameState.PLAYING:
			hud.visible = true
		game_system.GameState.PAUSE:
			pause_menu.visible = true
		game_system.GameState.GAMEOVER:
			game_over.visible = true



func	_on_start_button_pressed() -> void:

	game_system.change_state(game_system.GameState.PLAYING)


func	_on_restart_button_pressed() -> void:
	
	game_system.change_state(game_system.GameState.PLAYING)


func _on_quit_button_pressed() -> void:
	pass # Replace with function body.


func _on_resume_button_pressed() -> void:
	
	game_system.change_state(game_system.GameState.PLAYING)
