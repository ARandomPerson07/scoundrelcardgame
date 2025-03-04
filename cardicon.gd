extends MarginContainer

@onready
var parent : Node = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if parent.name == "hearts" or parent.name == "diamonds":
		self.textcolor = Color("RED")
	else:
		self.textcolor = Color("BLACK")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

signal text_changed
signal color_changed

@export var text : String:
	set(value):
		text_changed.emit(value)

@export var textcolor : Color:
	set(value):
		color_changed.emit(value)

@onready
var rect :ColorRect = get_node("ColorRect")

func grayout():
	rect.color = Color("GRAY")

func highlight():
	rect.color = Color("WHITE")
