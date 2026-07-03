extends CharacterBody3D


@onready var camera_arm: SpringArm3D = $Camera_Arm


const	SPEED: float = 7.0
const	GRAVITY: float = 9.8
const	MOUSE_SENSITIVITY: float = 0.003

# ====================================== HELPER FUNCTIONS ========================================== #

func	resolve_movement(delta: float) -> Vector3:

	var	input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var	forward: Vector3 = -camera_arm.global_transform.basis.z
	var	right: Vector3 = camera_arm.global_transform.basis.x

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	velocity.x = (forward * -input_dir.y + right * input_dir.x).x * SPEED
	velocity.z = (forward * -input_dir.y + right * input_dir.x).z * SPEED

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

	direction = atan2(current_velocity.x, current_velocity.z)
	rotation.y = -direction


# ====================================== ENGINE CALLBACKS ========================================== #

func _ready() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:

	resolve_camera(event)


func _physics_process(delta: float) -> void:

	var	current_velocity: Vector3

	move_and_slide()

	current_velocity = resolve_movement(delta)
	#resolve_characters_rotation(current_velocity)
