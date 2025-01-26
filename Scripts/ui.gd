extends CanvasLayer

var player_is_dead : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.player_dead.connect(_player_has_died)
	Signals.game_won.connect(_game_has_been_won)
	await get_tree().create_timer(0.01).timeout
	_fade_color(true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_is_dead == true:
		if Input.is_action_pressed('move_up'):
			_fade_color(false)
			await get_tree().create_timer(1).timeout
			Signals.emit_signal("reload_game")
	
func _player_has_died():
	await get_tree().create_timer(0.5).timeout
	$DeathScreen.show()
	player_is_dead = true
	
func _game_has_been_won():
	_fade_color(false)
	await get_tree().create_timer(2).timeout
	$GameWonScreen.show()
	
func _fade_color(fade_in : bool):
	if fade_in == true:
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property($FadeIn, "modulate:a", 0, 1).set_trans(tween.TRANS_QUAD)
	else:
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property($FadeIn, "modulate:a", 1, 1).set_trans(tween.TRANS_QUAD)
	
	
	
