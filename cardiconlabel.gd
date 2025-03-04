extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cardicon_text_changed(text) -> void:
	self.text = text


func _on_cardicon_color_changed(color : Color) -> void:
	print("text color changed")
	self.add_theme_color_override("font_color", color)
