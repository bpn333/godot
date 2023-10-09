extends Node2D
var pole:PackedScene;
var poles_count = 0;
var wave = 1;
var score = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pole = preload("res://pole_base.tscn") as PackedScene;
	$score.text = "SCORE : "+str(score);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$score.text = "SCORE : "+str(score);
	if Input.is_action_just_pressed("exit"):
		get_tree().quit();
	if(poles_count < wave):
		var new_pole = pole.instantiate();
		#new_pole.position.x += randf_range(30,80);
		add_child(new_pole);
		poles_count += 1;
