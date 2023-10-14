extends Node2D

@onready var player_scene = preload("res://scenes/player.tscn");
@onready var pole_scene = preload("res://scenes/poles.tscn");
var current_pole;
var last_pole;
var current_player_instance;
var score = 0;
func _ready():
	toggle_nodes($gameover);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$score.text = "SCORE : "+str(score);
	if Input.is_action_just_pressed("esc"):
		toggle_nodes($VBoxContainer);
		if($gameover.visible):
			toggle_nodes($gameover);
	add_pole();
func toggle_nodes(node):
	node.visible = !node.visible;
	for nd in node.get_children():
		toggle_nodes(nd);

func _on_play_button_down():
	if score==0:
		clean_up();
	play_btn_snd();
	toggle_nodes($VBoxContainer);
	add_player();

func _on_quit_button_down():
	play_btn_snd();
	get_tree().quit();

func add_pole():
	if !current_pole:
		var pole_instance = pole_scene.instantiate();
		add_child(pole_instance);
		current_pole = pole_instance;
	if current_pole.position.x < randf_range(0, 300+score*10):
		last_pole = current_pole;
		current_pole = null;
		add_pole();

func add_player():
	$score.visible = true;
	if !current_player_instance:
		clean_up();
		var player_instance = player_scene.instantiate();
		add_child(player_instance);
		current_player_instance = player_instance;
		add_pole();


func _on_replay_button_down():
	play_btn_snd();
	score = 0;
	add_player();
	toggle_nodes($gameover);

func gameover():
	$death.play();
	toggle_nodes($gameover);
	$gameover/score.text = str(score);
	$score.visible = false;

func play_btn_snd():
	$button.play();

func clean_up():
	if current_pole:
		remove_child(current_pole);
		current_pole = null;
	if last_pole:
		remove_child(last_pole);
		last_pole = null;


func _on_about_button_down():
	play_btn_snd();
	OS.shell_open("https://github.com/bipin333");
