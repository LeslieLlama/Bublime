extends "res://Scripts/enemy_rush.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 1
	speed = 80000
	$SpikeStraight.rotation_degrees = (rad_to_deg(direction.angle())+90)
	$SpikeDiagonal.rotation_degrees = (rad_to_deg(direction.angle())+135)
	await get_tree().create_timer(2).timeout
	queue_free()
	
func _set_direction(vector):
	direction = vector
	
func _set_sprite(diagonal):
	print(diagonal)
	if diagonal == false:
		$SpikeStraight.show()
	else: 
		$SpikeDiagonal.show()

func _physics_process(delta):
	apply_force(direction * speed, Vector2.ZERO)
	
func _check_for_active(currentArea : Area2D, name : String):
	pass
	

	
