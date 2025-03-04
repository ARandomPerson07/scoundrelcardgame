extends VBoxContainer

var dungeon : Node
var play_area : Node
var weapon: Card
var discardtop : Card
var weaponrem : Card
var deck : Deck
var rooms : Array[Node]
var weapontoggle : CheckButton
var hp : int
var hplabel : Label
var run : Button
var rules_window : ColorRect
var stats_window : ColorRect
var discards_window : ColorRect

var roomsfx : AudioStreamPlayer
var decksfx : AudioStreamPlayer
var n_visible_roomcards: int = 0
var conf = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dungeon = get_node("dungeon")
	play_area = get_node("play area")
	weapon = play_area.get_node("Weapon/CenterContainer/Control/WCard")
	weapontoggle = get_node("play area/Weapon/WeaponToggle")
	weaponrem = get_node("play area/Weapon_Rem/Control/WRCard")
	discardtop = get_node("play area/DiscardCont/Control/Discard")
	rooms = dungeon.get_node("room").get_children()
	deck = get_node("dungeon/CenterContainer/Control/deck")
	weapon.set_card_attrs(ca.Suit.CLUBS, ca.Rank.ACE)
	run = get_node("play area/Menu/run")
	run.disabled = true
	hplabel = get_node("play area/Menu/hplabel")
	rules_window = get_node("../rulesscreen")
	stats_window = get_node("../statsscreen")
	discards_window = get_node("../discards")
	roomsfx = get_node("roomsfx")
	decksfx = get_node("decksfx")
	hp = 20
	hplabel.text = str(hp)
	weaponrem.rank = ca.Rank.OVER
	var err = conf.load("user://stats.cfg")
	if err != OK:
		print("user conf init")
		init_conf()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func fade_warning_text():
	var warning : CanvasItem = get_node("DealWarning")
	var tween = get_tree().create_tween()
	warning.modulate.a = 1
	tween.tween_property(warning, "modulate:a", 1, 0.5)
	tween.tween_property(warning, "modulate:a", 0, 1)

func discard(card: Card):
	var deckview :MarginContainer = get_node("../discards/deckview")
	var tempsuit = "none"
	match card.suit:
		ca.Suit.CLUBS:
			tempsuit = "clubs"
		ca.Suit.DIAMONDS:
			tempsuit = "diamonds"
		ca.Suit.HEARTS:
			tempsuit = "hearts"
		ca.Suit.SPADES:
			tempsuit = "spades"
	
	var temprank = "none"
	match card.rank:
		ca.Rank.TWO:
			temprank = "2"
		ca.Rank.THREE:
			temprank = "3"
		ca.Rank.FOUR:
			temprank = "4"
		ca.Rank.FIVE:
			temprank = "5"
		ca.Rank.SIX:
			temprank = "6"
		ca.Rank.SEVEN:
			temprank = "7"
		ca.Rank.EIGHT:
			temprank = "8"
		ca.Rank.NINE:
			temprank = "9"
		ca.Rank.TEN:
			temprank = "10"
		ca.Rank.JACK:
			temprank = "J"
		ca.Rank.QUEEN:
			temprank = "Q"
		ca.Rank.KING:
			temprank = "K"
		ca.Rank.ACE:
			temprank = "A"

	var temppath = "suits/" + tempsuit + "/" + temprank
	print(temppath)
	var target = deckview.get_node(temppath)
	print(target, "is node target")
	target.highlight()
	
func update_hp(adj):
	hp += adj
	if hp > 20:
		hp = 20
	hplabel.text = str(hp)

func checkwinloss():
	if hp <= 0:
		lose()
	if n_visible_roomcards <= 0 and len(deck.deckarr) <= 0:
		win()

func move_to_discard(card: Card):
	card.visible = false
	discardtop.set_card_attrs(card.suit, card.rank)
	discardtop.visible = true
	discard(card)

func move_to_weapon(card : Card):
	if weapon.visible:
		move_to_discard(weaponrem)
		move_to_discard(weapon)
	card.visible = false
	weapon.set_card_attrs(card.suit, card.rank)	
	weapon.visible = true

func move_to_weaponrem(card: Card):
	if weaponrem.visible:
		move_to_discard(weaponrem)
	card.visible = false
	weaponrem.set_card_attrs(card.suit, card.rank)
	weaponrem.visible = true

func _on_rc_card_press(card : Card, suit : ca.Suit, rank : ca.Rank) -> void:
	if n_visible_roomcards == 1:
		if !len(deck.deckarr) == 0:
			fade_warning_text()
			return
	#print("play", suit, rank)
	#card.visible = false
	n_visible_roomcards -= 1
	run.disabled = true
	
	match suit:
		ca.Suit.CLUBS, ca.Suit.SPADES:
			var dmg : int
			if not weapontoggle.button_pressed or rank >= weaponrem.rank:
				update_hp(-rank)
				move_to_discard(card)
			else:
				dmg = rank - weapon.rank
				if dmg < 0:
					dmg = 0
				update_hp(-dmg)
				move_to_weaponrem(card)
		ca.Suit.DIAMONDS:
			if weapon.visible:
				move_to_discard(weapon)
			if weaponrem.visible:
				move_to_discard(weaponrem)
			move_to_weapon(card)
			if weapontoggle.disabled:
				print("first weapon")
				weapontoggle.disabled = false
				weapontoggle.set_pressed_no_signal(true)
			weaponrem.rank = ca.Rank.OVER
		ca.Suit.HEARTS:
			update_hp(rank)
			move_to_discard(card)
	roomsfx.play()
	update_monsters()
	checkwinloss()

var nxt

var game_started = false

func init_conf():
	conf.set_value("all","wins", 0)
	save_stats()

func save_stats():
	conf.save("user://stats.cfg")

func lose():
	for cont in rooms:
		cont.get_child(0).get_child(0).visible = false
	var losescreen = get_node("../losescreen")
	losescreen.visible = true
	losescreen.play_fanfare()

func win():
	for cont in rooms:
		cont.get_child(0).get_child(0).visible = false
	var winscreen = get_node("../winscreen")
	conf.set_value("all","wins", conf.get_value("all","wins") + 1)
	save_stats()
	winscreen.visible = true
	winscreen.play_fanfare()

func deal():
	#print("dealing")
	decksfx.play()
	for cont in rooms:
		var cur_card : Card = cont.get_node("Control/RC")
		#print(cur_card.suit, cur_card.rank)
		if cur_card.visible:
			#print("skipping")
			continue
		else:
			nxt = deck.get_next()
			var nsuit = nxt[0]
			var nrank = nxt[1]
			cur_card.set_card_attrs(nsuit,nrank)
			#print("updated to", cur_card.suit, cur_card.rank)
			cur_card.visible = true
	update_monsters()

@onready
var warn : CheckButton = get_node("play area/Menu/warn")

func update_monsters():
	#print("updating monsters")
	if not warn.button_pressed:
		for cont in rooms:
			cont.get_node("Control/RC").hide_warning()
		return
	for cont in rooms:
		#print("checking card")
		var cur_card = cont.get_node("Control/RC")
		if cur_card.suit == ca.Suit.CLUBS or cur_card.suit == ca.Suit.SPADES:
			if cur_card.rank >= weaponrem.rank:
				#print("cur_card has rank", cur_card.rank, "compared to ", weaponrem.rank, "warning")
				cur_card.show_warning()
			else:
				cur_card.hide_warning()
		else:
			#print("cur_card has lower rank or is not monster, hiding...", cur_card.rank)
			cur_card.hide_warning()

func _on_deck_deck_press() -> void:
	#print("dealing")
	if game_started and n_visible_roomcards > 1:
		return
	else:
		game_started = true
		n_visible_roomcards = 4
	run.disabled = false
	deal()


func _on_run_pressed() -> void:
	run.disabled = true
	var buf : Array = []
	for cont in rooms:
		var cur_card : Card = cont.get_child(0).get_child(0)
		if cur_card.visible:
			buf.append([cur_card.suit, cur_card.rank])
			cur_card.visible = false
	deck.put_bottom(buf)
	deal()
	run.disabled = true
	
func _on_reset_pressed() -> void:
	get_tree().reload_current_scene()


func _on_rules_pressed() -> void:
	rules_window.visible = true
	rules_window.get_child(0).disabled = false

func _on_stats_pressed() -> void:
	stats_window.visible = true
	stats_window.get_node("close").disabled = false

func _on_debugwins_pressed() -> void:
	var game = get_node("../gamehandler")
	game.update_hp(10)

func _on_warn_toggled(_toggled_on: bool) -> void:
	update_monsters()


func _on_close_discards_pressed() -> void:
	discards_window.visible = false
	get_node("../discards/close").disabled = true


func _on_discard_card_press(c, s, r ) -> void:
	discards_window.visible = true
	get_node("../discards/close").disabled = false
