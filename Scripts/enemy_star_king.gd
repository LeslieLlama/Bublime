extends "res://Scripts/enemy_rush.gd"

var projectile = load("res://Scenes/Projectile_large.tscn")

var alt_fire
var shooting_pattern_A = []
var shooting_pattern_B = []
# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = 2
	health = maxHealth
	Signals.get_player.connect(_assign_player)
	Signals.new_room_entered.connect(_check_for_active)
	active_area = get_parent().name
	speed = 20000
	shooting_pattern_A = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	shooting_pattern_B = [Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1)]

func _physics_process(delta):
	if is_active == true:
		direction = Vector2(global_position - player.global_position).normalized()
		apply_force(-direction * speed, Vector2.ZERO)


func _movement():
	print("timer fired")
	if is_active == true:
		_bullet_program()
	$MovementTick.start()

func _death_check():
	if health <= 0:
		queue_free()
		Signals.emit_signal("game_won")
	
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
	print("bullet fired")
	var bullet = projectile.instantiate()
	$"..".call_deferred("add_child",bullet)
	bullet.position = global_position
	bullet._set_direction(shoot_direction)
