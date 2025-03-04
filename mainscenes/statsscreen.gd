extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var conf = ConfigFile.new()

func update_label():
	conf.load("user://stats.cfg")
	var label = get_node("Label")
	var wins = conf.get_value("all", "wins")
	label.text = "Lifetime wins: " + str(wins)

func _on_visibility_changed() -> void:
	if self.visible:
		update_label()

func _on_close_stats_pressed() -> void:
	self.visible = false
	self.get_node("close").disabled = true
