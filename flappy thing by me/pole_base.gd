extends StaticBody2D
var speed = .5;
# Called when the node enters the scene tree for the first time.
func _ready():
	# top = -100 - ?
	# bottom = ? - 1280
	#var separation = randf_range(300,800);
	$lower.position.y = randf_range(300,800);
	$lower_coll.position.y = $lower.position.y;
	$upper.position.y = ($lower.position.y - $lower.texture.get_height()) - randf_range(50,250);
	$upper_coll.position.y = $upper.position.y;
	# Find the $pole_top node by name
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed;
	if(position.x < -50):
		get_parent().poles_count -= 1;
		get_parent().score += 1
		queue_free();
