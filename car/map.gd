extends Node3D
func _on_area_3d_body_entered(body):
	if body.name == "car":
		body.lap_finish();


func _on_area_3d_body_exited(body):
	if body.name == "car":
		body.lap_start();
