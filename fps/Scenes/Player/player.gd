extends CharacterBody3D

@onready var gunRay = $Head/Camera3d/RayCast3d as RayCast3D
@onready var Cam = $Head/Camera3d as Camera3D
@export var _bullet_scene : PackedScene
var mouseSensibility = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var can_fire = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var reloading = false
var scoped = false
var sound = AudioStreamPlayer.new()
@onready var shell = get_node("Head/Camera3d/a7b6b26165b543cf9116bdfe23470a15/CPUParticles3D")
@onready var animation = get_node("Head/Camera3d/a7b6b26165b543cf9116bdfe23470a15/AnimationPlayer")
@onready var scoreboard = get_node("Head/Camera3d/score")
@onready var enemy_scene = preload("res://Scenes/enemy/enemy.tscn")
@onready var medkit_scene = preload("res://Scenes/consumables/static_body_3d.tscn")
var score = 0
@export var health = 100
@export var bullets = 30
@onready var medkit_counter = $Head/Camera3d/medkit_count
@onready var progress = $Head/Camera3d/wave
var wave = 1
var medkit_count = 0
var medkit_effect = 33
var count = 0
var dash = 1
func _ready():
	#Captures mouse and stops rgun from hitting yourself
	$Head/Camera3d/wave.visible = false
	$Head/Camera3d/gameover.visible = false
	add_child(sound)
	gunRay.add_exception(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta):
	var collision = gunRay.get_collider()
	$Head/Camera3d/health.value = health
	$Head/Camera3d/bullet_count.text = str(bullets)
	if health <= 0 or position.y < -5:
		$Head/Camera3d/gameover.visible = true
		await get_tree().create_timer(3.0).timeout
		get_tree().quit()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Handle Shooting
	if Input.is_action_pressed("Shoot"):
		if can_fire and bullets and !reloading:
			shoot()
	elif !reloading and !scoped:
		animation.play("idle")
	if Input.is_action_just_pressed("reload") and !scoped :
		reloading = true
		animation.play("reload")
		sound.stream = load("res://071674_pistol-reloadingmp3-47529.mp3")
		sound.play()
		bullets = 30
		for child in get_parent().get_children():
			#print(child.name)
			if child.name.find("@bullet") == 0 || child.name.find("bullet") == 0:
				child.queue_free()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if !sound.is_playing():
		reloading = false
	if Input.is_action_pressed("scope"):
		animation.play("scoped")
		scoped = true
	if Input.is_action_just_released("scope"):
		scoped = false
	if Input.is_action_just_pressed("heal"):
		if medkit_count > 0 :
			medkit_count -= 1
			medkit_counter.text = str(medkit_count)
			if medkit_count == 0 :
				medkit_counter.visible = false
			heal(medkit_effect)
	if Input.is_action_just_pressed("dash") && count>=20:
		dash = 20
		$Head/Camera3d/Sprite2D2.visible = false
		count = 0
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * dash
		velocity.z = direction.z * SPEED * dash
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * dash)
		velocity.z = move_toward(velocity.z, 0, SPEED * dash)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensibility
		$Head/Camera3d.rotation.x -= event.relative.y / mouseSensibility
		$Head/Camera3d.rotation.x = clamp($Head/Camera3d.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)


func shoot():
	var bulletInst = _bullet_scene.instantiate() as Node3D
	bulletInst.set_as_top_level(true)
	bulletInst.name = "bullet"
	get_parent().add_child(bulletInst)
	bulletInst.global_transform.origin = gunRay.get_collision_point() as Vector3
	bulletInst.look_at((gunRay.get_collision_point()+gunRay.get_collision_normal()),Vector3.BACK)
	#print(gunRay.get_collision_point())
	#print(gunRay.get_collision_point()+gunRay.get_collision_normal())
	bullets -= 1
	can_fire = false
	shell.set_emitting(true)
	animation.play("recoil")
	if not gunRay.is_colliding():
		return
	var collision = gunRay.get_collider()
	#print(collision)
	#print(collision.get_collision_layer())
	#print(collision.get_path())
	#print(collision.get_collision_layer())
	if collision.get_collision_layer() == 32:
		var enemy_path = str(collision.get_path())
		#print(enemy_path)
		var enemy = get_node(enemy_path)
		enemy.health -= 1
		if enemy.health <= 0:
			enemy.queue_free()
			wave -= 1
			score += 1
			scoreboard.text = str(score)
			$Head/Camera3d/wave.value += 1
			if wave == 0:
				spawn()
	if wave > 1:
		$Head/Camera3d/wave.visible = true

func _on_rate_timeout():
	dash = 1
	count += 1
	can_fire = true
	heal(.05)
	if count >= 20:
		$Head/Camera3d/Sprite2D2.visible = true
	else:
		$Head/Camera3d/Sprite2D2.visible = false
func spawn():
	spawn_medkit()
	$Head/Camera3d/wave.max_value = wave
	$Head/Camera3d/wave.value = 0
	for i in wave :
		var new_enemy = enemy_scene.instantiate()
		new_enemy.position = Vector3(randf_range(position.x-5, position.x+5), 0.5 , randf_range(position.z-5, position.z+5))
		get_parent().add_child(new_enemy)

func spawn_medkit():
	wave = int(sqrt(score))
	var medkit = medkit_scene.instantiate()
	medkit.position = Vector3(randf_range(position.x-5, position.x+5), 1 , randf_range(position.z-5, position.z+5))
	get_parent().add_child(medkit)

func heal(effect):
	if health == 100:
		return
	elif health + effect >= 100 :
		health = 100
	else:
		health += effect
