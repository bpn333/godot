extends Node2D

@onready var player_scene = preload("res://scenes/player.tscn");
@onready var pole_scene = preload("res://scenes/poles.tscn");
var current_pole;
var current_player_instance;
var score = 0;
@onready var sound_button = preload("res://src/flappy-bird-assets-master/audio/368744__matrixxx__button-switch-off.wav");
func _ready():
	add_pole();
	toggle_nodes($gameover);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$score.text = "SCORE : "+str(score);
	if Input.is_action_just_pressed("esc"):
		toggle_nodes($VBoxContainer);
		if($gameover.visible):
			toggle_nodes($gameover);
	if !current_pole:
		add_pole();
func toggle_nodes(node):
	node.visible = !node.visible;
	for nd in node.get_children():
		toggle_nodes(nd);

func _on_play_button_down():
	play_btn_snd();
	toggle_nodes($VBoxContainer);
	add_player();

func _on_quit_button_down():
	play_btn_snd();
	get_tree().quit();

func add_pole():
	var pole_instance = pole_scene.instantiate();
	add_child(pole_instance);
	current_pole = pole_instance;

func add_player():
	$score.visible = true;
	if !current_player_instance:
		var player_instance = player_scene.instantiate();
		add_child(player_instance);
		current_player_instance = player_instance;


func _on_replay_button_down():
	play_btn_snd();
	score = 0;
	add_player();
	toggle_nodes($gameover);

func gameover():
	var sound_die = load("res://src/flappy-bird-assets-master/audio/die.wav");
	$AudioStreamPlayer.stream = sound_die;
	toggle_nodes($gameover);
	$score.visible = false;
	$AudioStreamPlayer.play();

func play_btn_snd():
	$AudioStreamPlayer.stream = sound_button;
	$AudioStreamPlayer.play();
