class_name Card
extends Area2D

var suit_to_anim = {
	ca.Suit.CLUBS : "clubs",
	ca.Suit.DIAMONDS : "diamonds",
	ca.Suit.HEARTS : "hearts",
	ca.Suit.SPADES : "spades",
}

var suit : ca.Suit = ca.Suit.DIAMONDS
var rank : ca.Rank = ca.Rank.SEVEN
var sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	set_card_attrs(suit, rank)
	self.sprite = get_child(0)
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_card_attrs(nsuit: ca.Suit, nrank: ca.Rank):
	print("setting attrs")
	self.suit = nsuit
	self.rank = nrank
	_set_card_sprite(nsuit, nrank)

func _set_card_sprite(nsuit: ca.Suit, nrank: ca.Rank):
	var card : AnimatedSprite2D = self.get_child(0)
	card.play(suit_to_anim[nsuit])
	card.pause()
	card.set_frame_and_progress(nrank - 1, 0)

signal card_press

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if visible:
			card_press.emit(self, self.suit, self.rank)

@onready
var warning = get_node("ColorRect")

func show_warning():
	warning.visible = true

func hide_warning():
	warning.visible = false
