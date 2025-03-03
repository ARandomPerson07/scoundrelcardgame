extends Node

enum Suit {
	CLUBS = 0,
	DIAMONDS = 1,
	HEARTS = 2,
	SPADES = 3,
}

func int_to_Suit(n : int):
	match n:
		0:
			return Suit.CLUBS
		1:
			return Suit.DIAMONDS
		2:
			return Suit.HEARTS
		3:
			return Suit.SPADES
	
enum Rank {
	TWO = 2,
	THREE = 3,
	FOUR = 4,
	FIVE = 5,
	SIX = 6,
	SEVEN = 7,
	EIGHT = 8,
	NINE = 9,
	TEN = 10,
	JACK = 11,
	QUEEN = 12,
	KING = 13,
	ACE = 14
}

func int_to_rank(n : int):
	var res
	match n:
		14:
			res = Rank.ACE
		2:
			res = Rank.TWO
		3:
			res = Rank.THREE
		4:
			res = Rank.FOUR
		5:
			res = Rank.FIVE
		6:
			res = Rank.SIX
		7:
			res = Rank.SEVEN
		8:
			res = Rank.EIGHT
		9:
			res = Rank.NINE
		10:
			res = Rank.TEN
		11:
			res = Rank.JACK
		12:
			res = Rank.QUEEN
		13:
			res = Rank.KING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
