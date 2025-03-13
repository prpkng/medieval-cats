extends Unit


func _on_turn():
	var cell = await PlayerInput.instance.request_cell_select(grid_position)
	
	var action = MoveAction.new(cell)
	send_action.emit(action)
	await action.completed
	
	cell = await PlayerInput.instance.request_cell_select(grid_position)
	
	action = MoveAction.new(cell)
	send_action.emit(action)
	await action.completed
	send_action.emit(null)
