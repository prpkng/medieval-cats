extends Unit


func _on_turn():
	for i in range(2):
		var action_type = await PlayerInput.instance.request_action_select()
		
		
		var action: Action
		match action_type:
			ActionTypes.Types.MOVE_ACTION:
				var cell = await PlayerInput.instance.request_cell_select(grid_position)
				action = MoveAction.new(cell)
			ActionTypes.Types.ATTACK_ACTION:
				var cell = await PlayerInput.instance.request_cell_select(grid_position, 7)
				action = AttackAction.new(cell)
			_:
				assert(false, 'ERROR: unrecognized action type')
		
		send_action.emit(action)
		await action.completed
	
	send_action.emit(null)
