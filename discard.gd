extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

signal disc_press

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		disc_press.emit()
