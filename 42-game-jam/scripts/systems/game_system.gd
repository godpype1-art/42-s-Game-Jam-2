extends Node

enum GameState
{
	MENU,
	PLAYING,
	PAUSE,
	GAMEOVER
}

signal	state_changed(old_state: GameState, new_state: GameState)

var		current_state: GameState = GameState.MENU


# ====================================== HELPER FUNCTIONS ========================================== #

func	change_state(new_state: GameState) -> void:

	var	old_state: GameState

	if current_state == new_state:
		return
	old_state = current_state
	current_state = new_state
	state_changed.emit(old_state, current_state)
	print("Game State -> ", GameState.keys()[new_state])


func	is_state(state: GameState) -> bool:
	return current_state == state


func	print_game_state() -> void:
	print("Game State -> ", GameState.keys()[current_state])


# ====================================== ENGINE CALLBACKS ========================================== #


func _ready() -> void:
	$World/Character.game_over.connect(_on_character_game_over)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:

# ====================================== SIGNAL CALLBACKS ========================================== #

func	_on_character_game_over() -> void:
	
	change_state(GameState.GAMEOVER)