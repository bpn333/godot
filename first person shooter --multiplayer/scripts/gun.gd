extends Node3D

const bullet_scene = preload("res://scenes/bullet.tscn");
const mag = 7;
var current_bullets = mag; 
var gun_shoot_sound = preload("res://src/sounds/gun_shot.wav");
var gun_reload_sound = preload("res://src/sounds/gun_reload.wav");

func shoot():
	if !$AnimationPlayer.is_playing() && !current_bullets:
		reload();
		return;
	elif !$AnimationPlayer.is_playing() && current_bullets:
		$AudioStreamPlayer.stream = gun_shoot_sound;
		$AudioStreamPlayer.play();
		$AnimationPlayer.play("recoil");
		rpc("add_bullet_to_scene");
		current_bullets -= 1;

func reload():
	$AnimationPlayer.play("reloading");
	current_bullets = mag;
	$AudioStreamPlayer.stream = gun_reload_sound;
	$AudioStreamPlayer.play();

@rpc("call_local")
func add_bullet_to_scene():
	var bullet_instance = bullet_scene.instantiate();
	bullet_instance.position = $RayCast3D.global_position;
	bullet_instance.rotation_degrees = $RayCast3D.global_rotation_degrees;
	bullet_instance.by_plr = get_multiplayer_authority();
	get_tree().root.add_child(bullet_instance);
