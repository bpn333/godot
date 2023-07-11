extends StaticBody3D
@onready var player = get_parent().find_child("Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.distance_to(player.position) < 1:
		player.medkit_count += 1
		player.medkit_counter.text = str(player.medkit_count)
		queue_free()
	else:
		for enemy in get_parent().get_children():
			if enemy.name.find("girl_kunoichi") == 0 || enemy.name.find("@girl_kunoichi") == 0:
				if position.distance_to(enemy.position) < 2 :
					#big boss
					enemy.scale *= Vector3(2,2,2)
					enemy.health *= 3
					enemy.damage *= 2
					enemy.speed /= 1.5
					enemy.view_range += 1
					enemy.attack_range += 1
					enemy.attack_type = "frog_jump"
					queue_free()
