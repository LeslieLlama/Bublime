extends Camera2D

var new_area : Area2D
var current_area : Area2D

func _ready():
	Signals.room_entered.connect(_on_new_room_entered)
	Signals.room_exited.connect(_on_room_exited)

#func _on_new_room_entered(area: Area2D, _room_name) -> void:
	#var collision_shape = area.get_node("CollisionShape2D")
	#var size = collision_shape.shape.extents*2
	#
	##for if room is smaller than viewport size
	#var view_size = get_viewport_rect().size
	#if size.y < view_size.y:
		#size.y = view_size.y
		#
	#if size.x < view_size.x:
		#size.x = view_size.x
	#
	#limit_top = collision_shape.global_position.y - size.y/2
	#limit_left = collision_shape.global_position.x - size.x/2
	#
	#limit_bottom = limit_top + size.y
	#limit_right = limit_left + size.x


func _on_new_room_entered(area: Area2D) -> void:
	new_area = area
	#set camera bounds on inital spawn in
	if current_area == null:
		_set_cam(area)
	
func _on_room_exited(area: Area2D):
	if new_area == null:
		return
	if area == new_area:
		return
	_set_cam(area)
	current_area = new_area
	new_area = null
	
	
func _set_cam(area: Area2D):
	var collision_shape = new_area.get_node("CollisionShape2D")
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
