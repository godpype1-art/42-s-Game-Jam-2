extends Control

@onready var	game_system: Node = get_parent()

# ====================================== ENGINE CALLBACKS ========================================== #

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# ====================================== SIGNAL CALLBACKS ========================================== #

func	_on_start_button_pressed() -> void:

	game_system.change_state(game_system.GameState.PLAYING)
