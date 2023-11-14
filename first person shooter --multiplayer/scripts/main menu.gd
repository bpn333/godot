extends Node2D

var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new();
var world = preload("res://scenes/world.tscn");
const PORT = 33333
func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT);
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(start);
	multiplayer.peer_disconnected.connect(end);
	load_world();
	start();
	remove_child($Node2D);
	#upnp_setup();

func _on_join_pressed():
	$Node2D/VBoxContainer/join/LineEdit.visible = true;
	$Node2D/VBoxContainer/join/done.visible = true;

func start(id = 1):
	var player = load("res://scenes/player.tscn");
	var player_inst = player.instantiate();
	player_inst.name = str(id);
	add_child(player_inst);

func end(id):
	var p = get_node_or_null(str(id));
	if p:
		remove_child(p);

func load_world():
	var world_inst = world.instantiate();
	world_inst.name = "world";
	add_child(world_inst);
	
func _on_done_pressed():
	peer.create_client($Node2D/VBoxContainer/join/LineEdit.text, PORT);
	multiplayer.multiplayer_peer = peer;
	load_world();
	remove_child($Node2D);



#check if port forwarding is enabled
func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())
