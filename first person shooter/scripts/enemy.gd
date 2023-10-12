extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var health = 10;
var nav:NavigationRegion3D;
func _ready():
	nav = get_parent().find_child("NavigationRegion3D");
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	var direction;
	$NavigationAgent3D.target_position = get_parent().find_child("player").global_transform.origin;
	direction = $NavigationAgent3D.get_next_path_position() - global_transform.origin;
	direction = direction.normalized();
	look_at(global_transform.origin * Vector3(0,1,0) + get_parent().find_child("player").global_transform.origin*Vector3(1,0,1));
	if position.distance_to(get_parent().find_child("player").global_transform.origin)>5:
		velocity = velocity.lerp(direction * SPEED,2*delta);
	if not is_on_floor():
		velocity.y -= gravity * delta;
	if health<=0:
		queue_free();
		get_parent().add_enemy();
	if $RayCast3D.get_collider():
		if $RayCast3D.get_collider().name == "player":
			$gun.shoot();
	move_and_slide()
