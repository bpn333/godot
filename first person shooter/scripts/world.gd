extends Node3D

func _process(delta):
	$DirectionalLight3D.rotation_degrees.x -= 0.05;
	if Input.is_action_just_pressed("exit"):
		get_tree().quit();
	if Input.is_action_just_pressed("full screen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func add_enemy():
	var enemy_scene = load("res://scenes/enemy.tscn");
	var enemy_instance = enemy_scene.instantiate();
	enemy_instance.set_name("enemy");
	enemy_instance.position = Vector3(randf_range(-20,20),5,randf_range(-20,20));
	add_child(enemy_instance);
