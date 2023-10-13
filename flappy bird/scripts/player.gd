extends CharacterBody2D

const JUMP_VELOCITY = -500.0
@onready var sound_swoosh = preload("res://src/flappy-bird-assets-master/audio/swoosh.ogg");
@onready var sound_wing = preload("res://src/flappy-bird-assets-master/audio/wing.ogg");
@onready var sound_hit = preload("res://src/flappy-bird-assets-master/audio/hit.ogg");
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");
func _input(event):
	if event is InputEventScreenTouch:
		velocity.y = JUMP_VELOCITY
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if position.x < get_viewport_rect().size.x/3:
		velocity.x = 50;
	else:
		velocity.x = -50;
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	handle_sprite_animation();
	if position.y > 1280 || position.x < 0:
		get_parent().gameover();
		queue_free();
	move_and_slide();

func handle_sprite_animation():
	if velocity.y > 100:
		$AnimatedSprite2D.play("fly_down");
		if !$AudioStreamPlayer.is_playing() && velocity.y > 500:
			$AudioStreamPlayer.stream = sound_swoosh;
			$AudioStreamPlayer.play();
	elif velocity.y < -100:
		$AnimatedSprite2D.play("fly_up");
		$AudioStreamPlayer.stream = sound_wing;
		$AudioStreamPlayer.play();
	else:
		$AnimatedSprite2D.play("default");
