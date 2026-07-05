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

func	reset() -> void:

	$World/Character.reset()
	for enemy in $World/Enemies_Container.get_children():
		enemy.queue_free()
	$World/Spawn_Timer.stop()
	$World/Spawn_Timer.start()


func	resolve_state(old_state: GameState, new_state: GameState) -> void:
	print("resolve_state called, pausing: ", new_state != GameState.PLAYING)
	if new_state == GameState.PLAYING:

		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if old_state != GameState.PAUSE:
			reset()
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
	resolve_state(old_state, new_state)

func	is_state(state: GameState) -> bool:
	return current_state == state


func	print_game_state() -> void:
	print("Game State -> ", GameState.keys()[current_state])


# ====================================== ENGINE CALLBACKS ========================================== #


func _ready() -> void:
	$World/Character.game_over.connect(_on_character_game_over)
	resolve_state(current_state, GameState.MENU)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:

func	_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_cancel") and current_state == GameState.PLAYING:
		change_state(GameState.PAUSE)
	elif event.is_action_pressed("ui_cancel") and current_state == GameState.PAUSE:
		change_state(GameState.PLAYING)
	else:
		return

# ====================================== SIGNAL CALLBACKS ========================================== #

func	_on_character_game_over() -> void:
	
	change_state(GameState.GAMEOVER)