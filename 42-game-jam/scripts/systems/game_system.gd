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

func	resolve_state(new_state: GameState) -> void:
	print("resolve_state called, pausing: ", new_state != GameState.PLAYING)
	if new_state == GameState.PLAYING:

		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.get_tree().paused = false

	else:

		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		self.get_tree().paused = true
	print("tree paused: ", get_tree().paused)



func	change_state(new_state: GameState) -> void:

	var	old_state: GameState

	if current_state == new_state:
		return
	old_state = current_state
	current_state = new_state
	state_changed.emit(old_state, current_state)
	print("Game State -> ", GameState.keys()[new_state])
	resolve_state(new_state)


func	is_state(state: GameState) -> bool:
	return current_state == state


func	print_game_state() -> void:
	print("Game State -> ", GameState.keys()[current_state])


# ====================================== ENGINE CALLBACKS ========================================== #


func _ready() -> void:
	$World/Character.game_over.connect(_on_character_game_over)
	resolve_state(GameState.MENU)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:

# ====================================== SIGNAL CALLBACKS ========================================== #

func	_on_character_game_over() -> void:
	
	change_state(GameState.GAMEOVER)