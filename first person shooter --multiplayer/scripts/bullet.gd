extends Node3D

const speed = 0.1;
const max_distance = 30;
const damage = 1;
var by_plr;
var initial_pos;
func _ready():
	initial_pos = position;

func _process(delta):
	position += transform.basis * Vector3(0,0,-speed);
	if $RayCast3D.get_collider():
		$GPUParticles3D.emitting = true;
		$MeshInstance3D.visible = false;
		if $RayCast3D.get_collider().get("health"):
			var player = $RayCast3D.get_collider()
			player.deal_damage.rpc_id(player.multiplayer.get_unique_id(),damage,by_plr);
		await get_tree().create_timer(1.0).timeout
		queue_free();
	if position.distance_to(initial_pos)>max_distance:
		queue_free();
