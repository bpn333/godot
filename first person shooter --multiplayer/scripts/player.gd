extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const sensitivity = 0.008;
var health = 30;
var death = 0;
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if is_multiplayer_authority():
		position = Vector3(randf_range(-20,20),5,randf_range(-20,20));
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		$head/Camera3D.make_current();
	if !is_multiplayer_authority():
		$head/Camera3D/Node2D/bullet_count.hide()
		$head/Camera3D/Node2D/ProgressBar.hide()
		$head/Camera3D/Node2D/Sprite2D.hide()
		$head/Camera3D/Node2D/death.hide()
		$head/Camera3D/Node2D/Death.hide()
		$head/Camera3D/Node2D/Hit.hide()

func _enter_tree():
	set_multiplayer_authority(name.to_int());

func _unhandled_input(event):
	if is_multiplayer_authority():
		if event is InputEventMouseMotion:
			$head/Camera3D.rotate_x(-event.relative.y * sensitivity);
			$head.rotate_y(-event.relative.x * sensitivity);
			$head/Camera3D.rotation_degrees.x = clamp($head/Camera3D.rotation_degrees.x,-100,100);

func _physics_process(delta):
	if is_multiplayer_authority():
		$head/Camera3D/Node2D/bullet_count.text = str($head/Camera3D/gun.current_bullets);
		$head/Camera3D/Node2D/ProgressBar.value = health;
		$head/Camera3D/Node2D/death.text = ": "+str(death);
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
			var lab = Label.new();
			lab.text = "WASTED";
			lab.size = get_viewport().size;
			lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
			lab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER;
			lab.set("theme_override_font_sizes/font_size", 100);
			get_tree().root.add_child(lab);
			await get_tree().create_timer(3).timeout
			get_tree().root.remove_child(lab)
		if Input.is_action_pressed("shoot"):
			$head/Camera3D/gun.shoot();
		if Input.is_action_just_pressed("reload"):
			$head/Camera3D/gun.reload();
	move_and_slide()

@rpc("any_peer","call_local")
func deal_damage(damage,by):
	health -= damage;
	if health <= 0:
		position = Vector3(randf_range(-20,20),5,randf_range(-20,20));
		health = 30
		death += 1;
	$head/Camera3D/Node2D/Hit.visible = true;
	await get_tree().create_timer(3).timeout
	$head/Camera3D/Node2D/Hit.visible = false;
