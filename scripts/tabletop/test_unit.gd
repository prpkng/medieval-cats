extends Unit

@export var dest1: Vector2i
@export var dest2: Vector2i


## Called by the tabletop and runs the unit's turn loop
func _on_turn():
	print("turn")
	await get_tree().create_timer(0.5).timeout
	
	send_action.emit(MoveAction.new(dest1))
	
	await get_tree().create_timer(2.5).timeout
	
	send_action.emit(MoveAction.new(dest2))
	
	await get_tree().create_timer(2.5).timeout
	
	send_action.emit(null)
