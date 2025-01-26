extends "res://Scripts/enemy_rush.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 1
	speed = 80000
	if (direction == Vector2.UP || direction == Vector2.DOWN || direction == Vector2.LEFT || direction == Vector2.RIGHT):
		$Sprite2D.frame = 0
	else:
		$Sprite2D.frame = 1
	$Sprite2D.rotation_degrees = (rad_to_deg(direction.angle())+90)
	await get_tree().create_timer(2).timeout
	queue_free()
	
func _set_direction(vector):
	direction = vector

func _physics_process(delta):
	apply_force(direction * speed, Vector2.ZERO)
	
func _check_for_active(currentArea : Area2D, name : String):
	pass
	

	
