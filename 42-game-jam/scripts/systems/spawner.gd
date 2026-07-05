extends Node3D

@onready var player: CharacterBody3D = $Character
@onready var spawn_timer: Timer = $Spawn_Timer
@onready var enemies_container: Node3D = $Enemies_Container

const ENEMY = preload("res://scenes/characters/enemy.tscn")

# ====================================== HELPER FUNCTIONS ========================================== #

func	spawn_enemy() -> void:

	var	enemy: CharacterBody3D

	enemy = ENEMY.instantiate()
	enemies_container.add_child(enemy)
	enemy.setup(player)


# ====================================== ENGINE CALLBACKS ========================================== #

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	spawn_timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# ====================================== SIGNAL CALLBACKS ========================================== #

func _on_timer_timeout() -> void:
	
	spawn_enemy()
