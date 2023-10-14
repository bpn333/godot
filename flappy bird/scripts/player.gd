extends CharacterBody2D

const JUMP_VELOCITY = -25000.0
var JUMP = false;
var gameover = false;
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");
func _input(event):
	if event is InputEventScreenTouch:
		JUMP = true;
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if position.x < get_viewport_rect().size.x/3:
		velocity.x = 50;
	else:
		velocity.x = -50;
	# Handle Jump.
	if (Input.is_action_just_pressed("jump") || JUMP) && !gameover:
		velocity.y = delta * JUMP_VELOCITY
		JUMP = false;
	handle_sprite_animation();
	if position.y > 1280 || position.x < 0:
		death();
	move_and_slide();

func handle_sprite_animation():
	if velocity.y > 100:
		if velocity.y > 500:
			if !$fall.is_playing():
				$fall.play();
			$AnimatedSprite2D.rotation_degrees= 25;
			$AnimatedSprite2D.play("fly_down");
	elif velocity.y < -100:
		$AnimatedSprite2D.rotation_degrees = -25;
		$AnimatedSprite2D.play("fly_up");
		if !$jump.is_playing():
			$jump.play();
	else:
		$AnimatedSprite2D.rotation_degrees = 0;
		$AnimatedSprite2D.play("default");

func death():
	gameover = true;
	$AnimatedSprite2D.rotation_degrees = lerp(0, 270 , 10);
	$hit.play();
	velocity.y = 500;
	await get_tree().create_timer(1).timeout;
	get_parent().gameover();
	queue_free();
