extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const sensitivity = 0.008;
var health = 30;
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$head/Camera3D.rotate_x(-event.relative.y * sensitivity);
		$head.rotate_y(-event.relative.x * sensitivity);
		$head/Camera3D.rotation_degrees.x = clamp($head/Camera3D.rotation_degrees.x,-100,100);

func _physics_process(delta):
	$head/Camera3D/bullet_count.text = str($head/Camera3D/gun.current_bullets);
	$head/Camera3D/ProgressBar.value = health;
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = ($head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if health<=0:
		get_tree().quit();
	if Input.is_action_pressed("shoot"):
		$head/Camera3D/gun.shoot();
	if Input.is_action_just_pressed("reload"):
		$head/Camera3D/gun.reload();
	move_and_slide()
