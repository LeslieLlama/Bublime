extends Area2D

var speed = 750.0
var direction : Vector2 
var friction = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2.LEFT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _set_direction(input_direction):
	direction = input_direction
	
func _physics_process(delta):
	position += direction * speed * delta
	speed = lerp(speed, 0.0, friction)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
