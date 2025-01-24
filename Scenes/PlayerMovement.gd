extends CharacterBody2D

@export var speed = 300
@export var friction = 0.1
@export var acceleration = 0.2

@export var bubble_projectile : PackedScene

var ammoCount : int = 0
var maxAmmoCount : int = 9

func _ready():
	Signals.bubble_collected.connect(collect_bubble)
	ammoCount = maxAmmoCount

func get_move_input(): 
	var input = Vector2() 
	if Input.is_action_pressed('move_right'): input.x += 1 
	if Input.is_action_pressed('move_left'): input.x -= 1 
	if Input.is_action_pressed('move_down'): input.y += 1 
	if Input.is_action_pressed('move_up'): input.y -= 1 
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
		if ammoCount >= 1:
			var bullet = bubble_projectile.instantiate()
			$"..".add_child(bullet)
			bullet.position = position
			bullet._set_direction(shoot_direction)
			ammoCount -= 1
			change_size(false)
			
		else:
			print("out of ammo!")

func change_size(is_plus : bool):
	if is_plus == true:
		scale.x += 0.05
		scale.y += 0.05
	else:
		scale.x -= 0.05
		scale.y -= 0.05
	
func collect_bubble(_position):
	change_size(true)
	ammoCount += 1
	
