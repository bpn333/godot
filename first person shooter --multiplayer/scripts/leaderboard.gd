extends Node2D

func _ready():
	for i in multiplayer.get_peers():
		var lb = Label.new();
		lb.name = str(i);
		lb.text = str(i) + " : " + str(get_parent().get_parent().get_parent().get_parent().get_parent().get_node(str(i)).death)
		$VBoxContainer.add_child(lb)

func _process(delta):
	for i in multiplayer.get_peers():
		var lb = $VBoxContainer.get_node_or_null(str(i));
		if lb:
			lb.text = str(i) + " : " + str(get_parent().get_parent().get_parent().get_parent().get_parent().get_node(str(i)).death);
		else :
			var lb_new = Label.new();
			lb_new.name = str(i);
			lb_new.text = str(i) + " : " + str(get_parent().get_parent().get_parent().get_parent().get_parent().get_node(str(i)).death);
			$VBoxContainer.add_child(lb_new);
