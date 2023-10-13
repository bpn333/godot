extends Node2D

var distance_btwn_poles;
#200
# Called when the node enters the scene tree for the first time.
func _ready():
	distance_btwn_poles = randf_range(50,350);
	if randi() % 2:
		$upper_wall.position.y -= distance_btwn_poles;
	else:
		$lower_wall.position.y += distance_btwn_poles;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(-1,0);
	if position.x < -80:
		queue_free();


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$AudioStreamPlayer.play();
		get_parent().score += 1;
