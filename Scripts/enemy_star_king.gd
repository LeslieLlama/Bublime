extends "res://Scripts/enemy_rush.gd"

var projectile = load("res://Scenes/Projectile_large.tscn")

var alt_fire : bool
var shooting_pattern_A = []
var shooting_pattern_B = []
# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = 10
	health = maxHealth
	Signals.get_player.connect(_assign_player)
	Signals.new_room_entered.connect(_check_for_active)
	active_area = get_parent().name
	speed = 20000
	alt_fire = false
	shooting_pattern_A = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	shooting_pattern_B = [Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]

func _physics_process(delta):
	if is_active == true:
		direction = Vector2(global_position - player.global_position).normalized()
		apply_force(-direction * speed, Vector2.ZERO)


func _movement():
	if is_active == true:
		_bullet_program()
	$MovementTick.start()

func _death_check():
	if health <= 0:
		queue_free()
		Signals.emit_signal("game_won")
	
func _check_for_active(currentArea : Area2D, name : String):
	if name == active_area:
		await get_tree().create_timer(1.0).timeout
		is_active = true
		print("enemy activated")
		Signals.emit_signal("boss_fight_triggered")
	else: 
		is_active = false
		

func _bullet_program():
	if alt_fire == false:
		for i in 4:
			_shoot_projectile(shooting_pattern_A[i])
		alt_fire = true
	else:
		for i in 4:
			_shoot_projectile(shooting_pattern_B[i])
		alt_fire = false
			
func _shoot_projectile(shoot_direction):
	var bullet = projectile.instantiate()
	$"..".call_deferred("add_child",bullet)
	bullet.position = position
	bullet._set_sprite(alt_fire)
	bullet._set_direction(shoot_direction)
