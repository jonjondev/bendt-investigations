extends Camera

export (NodePath) var player

func _ready():
	player = get_node(player).get_node("Player")

func _physics_process(delta):
	if abs(translation.x - player.translation.x) > 0.1:
		translation.x = lerp(translation.x, player.translation.x, delta)
