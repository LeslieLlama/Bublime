extends RigidBody2D
var speed = 750.0
var direction : Vector2 
var friction = 0.05
var damp_value : float = 2.5
enum state{PROJECTILE, PICKUP, EXTRA}
@export var currentState = state.PROJECTILE
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2.LEFT
	linear_damp = damp_value
	if currentState == state.PICKUP:
		become_pickup()
	elif currentState == state.PROJECTILE:
		await get_tree().create_timer(0.8).timeout
		become_pickup()
	else:
		become_extra_pickup()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _set_direction(input_direction):
	direction = input_direction
	apply_impulse(direction * speed, Vector2.ZERO)
	
func _physics_process(delta):
	pass
	#position += direction * speed * delta
	#speed = lerp(speed, 0.0, friction)

func _on_visible_on_screen_notifier_2d_screen_exited():
	if currentState == state.PICKUP:
		Signals.emit_signal("bubble_collected", position)
	if currentState == state.EXTRA:
		Signals.emit_signal("extra_bubble_collected")
	queue_free()
	
func become_pickup():
	currentState = state.PICKUP
	$Sprite2D.modulate = Color.WHITE
	collision_layer = 0b00000000_00000000_00000000_00000100
	collision_mask = 0b00000000_00000000_00000000_00000001
	
func become_extra_pickup():
	currentState = state.EXTRA
	$Sprite2D.modulate = Color.AQUA
	collision_layer = 0b00000000_00000000_00000000_00000100
	collision_mask = 0b00000000_00000000_00000000_00000001

func _on_body_entered(body):
	if body.is_in_group("player"):
		_on_visible_on_screen_notifier_2d_screen_exited()
