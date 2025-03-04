class_name Deck
extends Area2D

var sprite : AnimatedSprite2D
var deckarr : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.sprite = get_child(0)
	deckarr = []
	for rank in range(2,14):
		deckarr.append([0,rank])
		deckarr.append([3,rank])
	for rank in range(2,10):
		deckarr.append([1, rank])
		deckarr.append([2, rank])
	deckarr.shuffle()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

signal deck_press

func get_next() -> Array:
	if len(deckarr) > 0:
		var res = self.deckarr.pop_front()
		if len(deckarr) == 0:
			self.visible = false
		return res
	return []

func put_bottom(arr) -> void:
	print(len(deckarr), "cards in deck, bottoming...")
	for entry in arr:
		deckarr.append(entry)
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		deck_press.emit()
