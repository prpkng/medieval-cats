extends Unit

@export var dest1: Vector2i
@export var dest2: Vector2i


## Called by the tabletop and runs the unit's turn loop
func _on_turn():
	action_points = 100
	await get_tree().create_timer(0.5).timeout
	
	var action = MoveAction.new(dest1)
	send_action.emit(action)
	await action.completed
	
	action = MoveAction.new(dest2)
	send_action.emit(action)
	await action.completed
	
	send_action.emit(null)
