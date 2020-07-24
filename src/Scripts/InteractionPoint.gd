extends Area

export (NodePath) var player

func _ready():
	player = get_node(player).get_node("Player")
	var _error = connect("body_entered", self, "on_body_enter")

func on_body_enter(body: Node):
	if body == player:
		print("agent entered")
