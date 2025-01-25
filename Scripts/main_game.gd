extends Node2D

@export var fontToUse : FontFile
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.popup_message.connect(pop_up_message)


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
