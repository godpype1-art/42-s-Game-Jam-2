extends CharacterBody3D

@onready var damage_timer: Timer = $Damage_Timer

@export	var	hp: int
@export	var	speed: int
@export	var	damage: int

var player: CharacterBody3D
var	player_in_range: bool = false

# ====================================== HELPER FUNCTIONS ========================================== #

func	setup(reference: CharacterBody3D) -> void:
	
	player = reference


func	resolve_direction() -> Vector3:
	
	var direction: Vector3

	direction.x = player.position.x - self.position.x
	direction.z = player.position.z - self.position.z
	direction.y = 0
	direction = direction.normalized()
	return direction


func	resolve_movement(direction: Vector3) -> void:

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()

# ====================================== ENGINE CALLBACKS ========================================== #


func _physics_process(delta: float) -> void:

	var direction: Vector3

	if player:

		if not is_on_floor():
			velocity += get_gravity() * delta
		direction = resolve_direction()
		resolve_movement(direction)


# ====================================== SIGNAL CALLBACKS ========================================== #


func _on_damage_zone_body_entered(body: Node3D) -> void:
	
	if body == player:

		player_in_range = true
		player.take_damage(damage)
		damage_timer.start()



func	_on_damage_zone_body_exited(body: Node3D) -> void:

	if body == player:

		player_in_range = false
		damage_timer.stop()



func _on_damage_timer_timeout() -> void:
	
	if player_in_range:
		player.take_damage(damage)
