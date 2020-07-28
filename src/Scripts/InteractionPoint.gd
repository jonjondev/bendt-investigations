extends Area

export (NodePath) var player

func _ready():
	player = get_node(player).get_node("Player")
	var _error = connect("body_entered", self, "on_body_enter")
	_error = connect("body_exited", self, "on_body_exit")

func on_body_enter(body: Node):
	if body == player:
		body.get_node("../DialogueContainer/DialogueSelector").display_text(["test1", "test2", "test3"])
		body.get_node("../DialogueContainer/DialogueSelector").visible = true

func on_body_exit(body: Node):
	if body == player:
		body.get_node("../DialogueContainer/DialogueSelector").visible = false
