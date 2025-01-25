extends RigidBody2D

var health : int = 0
var maxHealth : int = 3
var speed : float = 60000
var player : CharacterBody2D
var active_area : String
var is_active : bool
var direction : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	health = maxHealth
	Signals.get_player.connect(_assign_player)
	Signals.new_room_entered.connect(_check_for_active)
	active_area = get_parent().name
	
func _assign_player(p : CharacterBody2D):
	player = p
	print("player assigned")


func _check_for_active(currentArea : Area2D, name : String):
	if name == active_area:
		is_active = true
		print("enemy activated")
	else: 
		is_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if player != null:
		#var direction = position - player.position
		#apply_force(-direction * speed, Vector2.ZERO)

	
func _movement():
	if is_active == true:
		direction = Vector2(position - player.position).normalized()
		apply_impulse(-direction * speed, Vector2.ZERO)
	$MovementTick.start()

func _on_body_entered(body):
	if body.is_in_group("player"):
		Signals.emit_signal("player_damaged", -direction)
	if body.is_in_group("player_bullet"):
		print(str(health))
		health -= 1
		body.apply_impulse(_random_direction() * 300, Vector2.ZERO)
		#onhit animation here
		_death_check()
		
func _death_check():
	if health <= 0:
		queue_free()
		
func _random_direction():
	var rng = RandomNumberGenerator.new()
	var output : Vector2
	output = Vector2(rng.randf_range(-1.0, 1.0),rng.randf_range(-1.0, 1.0))
	return output
