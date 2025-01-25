extends CharacterBody2D

@export var speed = 300
@export var friction = 0.1
@export var acceleration = 0.2
var stunTime = 0.5

@export var bubble_projectile : PackedScene

var ammoCount : int = 0
var maxAmmoCount : int = 3
var is_stunned : bool = false

var sprite2D 

func _ready():
	Signals.bubble_collected.connect(collect_bubble)
	Signals.extra_bubble_collected.connect(collect_extra_bubble)
	Signals.new_room_entered.connect(reset_bubble_split)
	Signals.player_damaged.connect(TakeDamage)
	
	ammoCount = maxAmmoCount
	sprite2D = $Sprite2D
	await get_tree().create_timer(0.01).timeout
	Signals.emit_signal("get_player", self)

func get_move_input(): 
	var input = Vector2() 
	if Input.is_action_pressed('move_right'): input.x += 1 
	if Input.is_action_pressed('move_left'): input.x -= 1 
	if Input.is_action_pressed('move_down'): input.y += 1 
	if Input.is_action_pressed('move_up'): input.y -= 1 
	if is_stunned == true : input = Vector2.ZERO
	return input
func get_shoot_input(): 
	var input = Vector2() 
	if Input.is_action_just_released('fire_right'): input.x += 1 
	if Input.is_action_just_released('fire_left'): input.x -= 1 
	if Input.is_action_just_released('fire_down'): input.y += 1 
	if Input.is_action_just_released('fire_up'): input.y -= 1 
	return input

func _physics_process(delta): 
	var direction = get_move_input() 
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration) 
	else: 
		velocity = lerp(velocity, Vector2.ZERO, friction) 
	move_and_slide() 
	var shoot_direction = get_shoot_input()
	if shoot_direction.length() > 0:
		shoot_bubble(shoot_direction)

func change_size(is_plus : bool):
	sprite2D.frame = (7-ammoCount) #8 total frames, so starting at 0 it's 7
	$CollisionShape2D.shape.radius = 15 + (3.5*(ammoCount))
	if is_plus == true:
		pass
	else:
		pass
	
func shoot_bubble(shoot_direction):
	if ammoCount >= 1:
		var bullet = bubble_projectile.instantiate()
		$"..".call_deferred("add_child",bullet)
		bullet.position = position
		bullet._set_direction(shoot_direction)
		ammoCount -= 1
		change_size(false)
	else:
		Signals.emit_signal("popup_message", "Too Small!", position, Color.WHITE)

func collect_bubble(_position):
	if ammoCount <= maxAmmoCount:
		change_size(true)
		ammoCount += 1
	
func collect_extra_bubble():
	maxAmmoCount += 1
	change_size(true)
	ammoCount += 1
	Signals.emit_signal("popup_message", "+1 Bubble!", position, Color.WHITE)
	
func reset_bubble_split(_area, _room_name):
	#currently don't need a "kill all" function on the bubble projectiles since they die on screen exit
	for m in maxAmmoCount-ammoCount:
		change_size(true)
	Signals.emit_signal("get_player", self)
		
func TakeDamage(direction_to_move):
	if is_stunned == true:
		pass
	else:
		if ammoCount > 2:
			for i in 3:
				shoot_bubble(_random_direction())
		if ammoCount == 1:
			shoot_bubble(_random_direction())
		if ammoCount == 0:
			_death()
		knockback(direction_to_move)
		
func knockback(direction_to_move):
	velocity += direction_to_move * (speed*3)
	is_stunned = true
	sprite2D.modulate = Color.WEB_GRAY
	await get_tree().create_timer(stunTime).timeout
	is_stunned = false
	sprite2D.modulate = Color.WHITE
	
func _random_direction():
	var rng = RandomNumberGenerator.new()
	var output : Vector2
	output = Vector2(rng.randf_range(-1.0, 1.0),rng.randf_range(-1.0, 1.0))
	return output
	
func _death():
	print("player has died")
	
