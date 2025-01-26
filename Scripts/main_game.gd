extends Node2D

@export var fontToUse : FontFile
var backgroundMusic
var bossMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.popup_message.connect(pop_up_message)
	Signals.reload_game.connect(reload_game)
	Signals.new_room_entered.connect(hide_title)
	Signals.boss_fight_triggered.connect(boss_fight_triggered)
	backgroundMusic = $Audio/backgroundMusic
	bossMusic = $Audio/BossMusic
	backgroundMusic.play()


func pop_up_message(textToSay : String, pos : Vector2, textColour : Color):
	print(str("pop up message at", pos))
	var message = Label.new()
	message.text = textToSay
	message.add_theme_font_override("font", fontToUse)
	message.add_theme_font_size_override("font_size", 20)
	message.position = Vector2(pos.x,pos.y-10)
	message.modulate = textColour
	add_child(message)
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(message, "position", Vector2(pos.x,pos.y-20), 1).set_trans(tween.TRANS_QUAD)
	tween.tween_callback(message.queue_free)
	
func reload_game():
	get_tree().reload_current_scene()
	
func hide_title(_area, name):
	if name != "Room1":
		$WorldText/TutorialScreen1/Title.hide()
		
func boss_fight_triggered():
	backgroundMusic.stop()
	bossMusic.play()
	$Door.position = Vector2(1338,-968)
	
func speed_powerup_aquired(_body):
	pop_up_message("Speed Up!", $SpeedPowerup.global_position, Color.YELLOW)
	Signals.emit_signal("speed_powerup_aquired")
	$SpeedPowerup.queue_free()
	
