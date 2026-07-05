extends CharacterBody3D


@onready var	camera_arm: SpringArm3D = $Camera_Arm
@onready var	character_model: Node3D = $Character_Model
@onready var	anim_player: AnimationPlayer = $Character_Model/AnimationPlayer
@onready var	attack_hitbox: Area3D = $Attack_Hitbox
@onready var	attack_timer: Timer = $Attack_Timer

const	SPEED: float = 7.0
const	JUMP_VELOCITY = 4.5
const	MOUSE_SENSITIVITY: float = 0.003

@export var	hp: int = 150
@export var attack_damage: int = 30

signal	game_over

var		can_attack: bool = true
var 	start_position: Vector3

# ====================================== HELPER FUNCTIONS ========================================== #

func	resolve_attack() -> void:
	if not can_attack:
		return
	can_attack = false
	attack_hitbox.monitoring = true
	anim_player.play("GreatSwordSlash")
	attack_timer.start()


func	resolve_animation(current_velocity: Vector3) -> void:

	if anim_player.current_animation == "GreatSwordSlash":
		return
	if anim_player.current_animation == "GreatSwordJump":
		return
	if current_velocity.x == 0 and current_velocity.z == 0:

		if anim_player.current_animation != "GreatSwordIdle":
			anim_player.play("GreatSwordIdle")

	else:

		if anim_player.current_animation != "GreatSwordRun":
			anim_player.play("GreatSwordRun")



func	reset() -> void:
	
	hp = 150
	global_position = start_position


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
	character_model.rotation.y = lerp_angle(character_model.rotation.y, direction, 0.3)
	attack_hitbox.rotation.y = character_model.rotation.y


# ====================================== ENGINE CALLBACKS ========================================== #

func _ready() -> void:

	start_position = global_position
	print(anim_player.get_animation_list())


func _input(event: InputEvent) -> void:

	resolve_camera(event)
	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:
			resolve_attack()





func _physics_process(delta: float) -> void:

	var	current_velocity: Vector3

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():

		velocity.y = JUMP_VELOCITY
		if anim_player.current_animation != "GreatSwordJump" and anim_player.current_animation != "GreatSwordSlash":
			anim_player.play("GreatSwordJump")

	current_velocity = resolve_movement(delta)
	resolve_animation(current_velocity)
	resolve_characters_rotation(current_velocity)


func _on_attack_timer_timeout() -> void:

	can_attack = true
	attack_hitbox.monitoring = false


func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	
	if body == self:
		return
	if body.has_method("take_damage"):

		body.take_damage(attack_damage)
		print("you dealt damage")
