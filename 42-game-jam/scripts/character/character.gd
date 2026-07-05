extends CharacterBody3D


@onready var	camera_arm: SpringArm3D = $Camera_Arm
@onready var	character_mesh: MeshInstance3D = $Character_Mesh


const	SPEED: float = 7.0
const	JUMP_VELOCITY = 4.5
const	MOUSE_SENSITIVITY: float = 0.003

@export var	hp: int = 150

signal	game_over

# ====================================== HELPER FUNCTIONS ========================================== #

func	take_damage(damage: int) -> void:

	hp = hp - damage
	print("you took damage")
	if hp <= 0:
		game_over.emit()


func	resolve_movement(delta: float) -> Vector3:

	var	input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var	forward: Vector3 = -camera_arm.global_transform.basis.z
	var	right: Vector3 = camera_arm.global_transform.basis.x
	var	direction: Vector3

	if not is_on_floor():
		velocity += get_gravity() * delta
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()
	direction = (forward * -input_dir.y + right * input_dir.x)
	if direction:

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED


	else:

		velocity.x = move_toward(velocity.x, 0, 0.2)
		velocity.z = move_toward(velocity.z, 0, 0.2)

	move_and_slide()
	return velocity


func	resolve_camera(event: InputEvent) -> void:

	if event is InputEventMouseMotion:

		camera_arm.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		camera_arm.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		camera_arm.rotation.x = clamp(camera_arm.rotation.x, -1.2, 0.5)
	
	else:
		return


func	resolve_characters_rotation(current_velocity: Vector3) -> void:

	var	direction: float

	if current_velocity.x == 0 and current_velocity.z == 0:
		return
	direction = atan2(current_velocity.x, current_velocity.z)
	character_mesh.rotation.y = lerp_angle(character_mesh.rotation.y, direction, 0.3)


# ====================================== ENGINE CALLBACKS ========================================== #

func _ready() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:

	resolve_camera(event)


func _physics_process(delta: float) -> void:

	var	current_velocity: Vector3

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	current_velocity = resolve_movement(delta)
	resolve_characters_rotation(current_velocity)
