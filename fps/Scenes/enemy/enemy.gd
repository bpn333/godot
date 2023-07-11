extends CharacterBody3D
@export var health = 3
@export var speed = 3
@export var damage = 10
@export var view_range = 4
@export var attack_range = 2
@onready var player = get_parent().find_child("Player")
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rand_min = 3
var rand_max = 5
@onready var random_location = Vector3(position.x+randf_range(rand_min,rand_max),position.y,position.y+randf_range(rand_min,rand_max))
@onready var original_rotation = rotation
@onready var attack_type = "attack"
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if position.y < -5:
		queue_free()
		player.wave -= 1
		player.score += 1
		player.scoreboard.text = str(player.score)
		player.progress.value += 1
		player.spawn()
	
	#here is some problem
	if get_last_slide_collision():
		if not get_last_slide_collision().get_collider().name == "floor":
			random()
	if position.distance_to(random_location) < 1:
		random()
	#this shit makes it move
	if position.distance_to(player.position) < view_range:
		#speed is twice because enemy is in agro mode when it sees player
		velocity = velocity * Vector3(0,1,0) + position.direction_to(player.position) * ( speed * 2 ) * Vector3(1,0,1)
		look_at(player.position)
		#$AnimationPlayer.play("walk")
		if position.distance_to(player.position) < attack_range:
			$AnimationPlayer.play(attack_type)
			#attack()
			velocity = Vector3(0,0,0) #to stop enemy from further coming close
	#this shit makes it move
	else:
		velocity = velocity * Vector3(0,1,0) + position.direction_to(random_location) * speed * Vector3(1,0,1)
		look_at(random_location)
	rotation.x = original_rotation.x
	rotation.z = original_rotation.z
	rotation.y += 110
	move_and_slide()

func random():
	if randf_range(-1,1)>0:
		random_location = Vector3(position.x+randf_range(rand_min,rand_max),position.y,position.y+randf_range(rand_min,rand_max))
	else :
		random_location = Vector3(position.x+randf_range(-rand_min,-rand_max),position.y,position.y+randf_range(-rand_min,-rand_max))


#need some extra work
func hack():
	if player.gunRay.is_colliding():
		if player.gunRay.get_collider().name.find("@girl_kunoichi") == 0 or player.gunRay.get_collider().name.find("girl_kunoichi") == 0:
			player.shoot()

func attack():
	player.health -= damage


func _on_animation_player_animation_finished(anim_name):
	if anim_name == attack_type:
		attack()
