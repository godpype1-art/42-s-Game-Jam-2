extends Node3D

@onready var player: CharacterBody3D = $Character
@onready var spawn_timer: Timer = $Spawn_Timer
@onready var enemies_container: Node3D = $Enemies_Container

const	ENEMY = preload("res://scenes/characters/enemy.tscn")

# ====================================== HELPER FUNCTIONS ========================================== #

func	spawn_enemy() -> void:

	var	enemy: CharacterBody3D
	var	angle: float = randf() * TAU  # TAU = 2*PI, full circle
	var	radius: float = 15.0
	var	spawn_pos: Vector3 = player.global_position + Vector3(cos(angle) * radius, 0, sin(angle) * radius)

	enemy = ENEMY.instantiate()
	enemies_container.add_child(enemy)
	enemy.global_position = spawn_pos
	enemy.setup(player)


# ====================================== ENGINE CALLBACKS ========================================== #

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# ====================================== SIGNAL CALLBACKS ========================================== #

func _on_timer_timeout() -> void:
	
	spawn_enemy()
