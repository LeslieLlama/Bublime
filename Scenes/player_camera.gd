extends Camera2D

func _ready():
	Signals.new_room_entered.connect(_on_new_room_entered)

func _on_new_room_entered(area: Area2D) -> void:
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents*2
	
	#for if room is smaller than viewport size
	var view_size = get_viewport_rect().size
	if size.y < view_size.y:
		size.y = view_size.y
		
	if size.x < view_size.x:
		size.x = view_size.x
	
	limit_top = collision_shape.global_position.y - size.y/2
	limit_left = collision_shape.global_position.x - size.x/2
	
	limit_bottom = limit_top + size.y
	limit_right = limit_left + size.x
