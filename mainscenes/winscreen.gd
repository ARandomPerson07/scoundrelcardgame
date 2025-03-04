extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func play_fanfare():
	var sfx : AudioStreamPlayer
	sfx = get_node("./sfx")
	sfx.play()
