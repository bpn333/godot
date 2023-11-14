extends VBoxContainer

func _process(delta):
	if Input.is_action_just_pressed("message"):
		$"../message_input".visible = true;
		$"../message_input".grab_focus();
	if Input.is_action_just_pressed("send_msg") && $"../message_input".visible:
		if $"../message_input".text != "":
			rpc("broadcast_msg",str(multiplayer.get_unique_id())+":" + $"../message_input".text);
			$"../message_input".text = ""
		$"../message_input".visible = false;

@rpc("call_local","any_peer")
func broadcast_msg(msg):
	var new_msg = Label.new();
	new_msg.text = msg;
	add_child(new_msg);
	await get_tree().create_timer(13).timeout
	new_msg.queue_free();
