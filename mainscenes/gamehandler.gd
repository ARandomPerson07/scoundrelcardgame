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
var label : Label
var run : Button
var rules_window : ColorRect
var stats_window : ColorRect

var roomsfx : AudioStreamPlayer
var decksfx : AudioStreamPlayer
var n_visible_roomcards: int = 0

var conf = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dungeon = get_node("dungeon")
	play_area = get_node("play area")
	weapon = play_area.get_node("Weapon/CenterContainer/Control/WCard")
	weapontoggle = get_child(1).get_child(1).get_child(1)
	weaponrem = get_child(1).get_child(2).get_child(0).get_child(0)
	discardtop = get_child(1).get_child(3).get_child(0).get_child(0)
	rooms = dungeon.get_child(1).get_children()
	deck = dungeon.get_child(0).get_child(0).get_child(0)
	weapon.set_card_attrs(ca.Suit.CLUBS, ca.Rank.ACE)
	run = get_child(1).get_child(0).get_child(0)
	label = get_child(1).get_child(0).get_child(1)
	rules_window = get_node("../rulesscreen")
	stats_window = get_node("../statsscreen")
	roomsfx = get_node("roomsfx")
	decksfx = get_node("decksfx")
	hp = 20
	label.text = str(hp)
	weaponrem.rank = 15
	var err = conf.load("user://stats.cfg")
	if err != OK:
		print("user conf init")
		init_conf()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_warning_text():
	var warning : CanvasItem = get_node("DealWarning")
	var tween = get_tree().create_tween()
	warning.modulate.a = 1
	tween.tween_property(warning, "modulate:a", 1, 0.5)
	tween.tween_property(warning, "modulate:a", 0, 1)
	
func _on_rc_card_press(card : Card, suit : ca.Suit, rank : ca.Rank) -> void:
	if n_visible_roomcards == 1:
		fade_warning_text()
		return
	print("play", suit, rank)
	card.visible = false
	n_visible_roomcards -= 1
	run.disabled = true
	
	match suit:
		ca.Suit.CLUBS, ca.Suit.SPADES:
			var dmg : int
			if not weapontoggle.button_pressed or rank >= weaponrem.rank:
				hp -= rank
				label.text = str(hp)
			else:
				dmg = rank - weapon.rank
				if dmg < 0:
					dmg = 0
				hp -= dmg
				label.text = str(hp)
				weaponrem.set_card_attrs(suit,rank)
				weaponrem.visible = true
		ca.Suit.DIAMONDS:
			weapon.set_card_attrs(suit, rank)
			weapon.visible = true
			weaponrem.visible = false
			weaponrem.rank = 14
		ca.Suit.HEARTS:
			hp += rank
			if hp > 20:
				hp = 20
			label.text = str(hp)
	roomsfx.play()
	if hp <=0:
		lose()
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

func _on_deck_deck_press() -> void:
	print("dealing")
	if game_started and n_visible_roomcards > 1:
		return
	else:
		game_started = true
		n_visible_roomcards = 4
	run.disabled = false
	decksfx.play()
	for cont in rooms:
		var cur_card : Card = cont.get_child(0).get_child(0)
		if cur_card.visible:
			continue
		else:
			nxt = deck.get_next()
			var nsuit = nxt[0]
			var nrank = nxt[1]
			cur_card.set_card_attrs(nsuit,nrank)
			cur_card.visible = true


func _on_run_pressed() -> void:
	run.disabled = true
	var buf : Array = []
	for cont in rooms:
		var cur_card : Card = cont.get_child(0).get_child(0)
		if cur_card.visible:
			buf.append([cur_card.suit, cur_card.rank])
			cur_card.visible = false
	deck.put_bottom(buf)
	for cont in rooms:
		var cur_card : Card = cont.get_child(0).get_child(0)
		if cur_card.visible:
			continue
		else:
			nxt = deck.get_next()
			var nsuit = nxt[0]
			var nrank = nxt[1]
			cur_card.set_card_attrs(nsuit,nrank)
			cur_card.visible = true
	run.disabled = true

func _on_reset_pressed() -> void:
	get_tree().reload_current_scene()


func _on_rules_pressed() -> void:
	rules_window.visible = true
	rules_window.get_child(0).disabled = false


func _on_close_rules_pressed() -> void:
	rules_window.visible = false
	rules_window.get_child(0).disabled = true


func _on_stats_pressed() -> void:
	stats_window.visible = true


func _on_debugwins_pressed() -> void:
	win()


func _on_close_stats_pressed() -> void:
	stats_window.visible = false
	stats_window.get_node("close").disabled = true
