extends CheckButton

var player :AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		player.play()
	else:
		player.stop()
