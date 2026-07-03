extends Node

enum GameState
{
	MENU,
	PLAYING,
	PAUSE
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

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:

