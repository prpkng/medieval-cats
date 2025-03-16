extends Unit


func _on_turn():
	action_points = randi_range(2, 6)
	while true:
		Events.ui_action_pts_update.emit(action_points)
		if action_points <= 0:
			break
		var action: Action
		while true:
			await get_tree().process_frame
			var action_type = await PlayerInput.instance.request_action_select()
			match action_type:
				ActionTypes.Types.MOVE_ACTION:
					var cell = await PlayerInput.instance.request_cell_select(grid_position, action_points)
					action = MoveAction.new(cell)
				ActionTypes.Types.ATTACK_ACTION:
					const COST = 2
					if action_points < COST:
						print('failed, try again')
						continue
					var target = await PlayerInput.instance.request_enemies_select()
					action = AttackAction.new(target)
				_:
					assert(false, 'ERROR: Unrecognized action type')
			break
		
		send_action.emit(action)
		await action.completed
	
	send_action.emit(null)
