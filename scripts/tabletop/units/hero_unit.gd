extends Unit


func _on_turn(tabletop: Tabletop):
	action_points = randi_range(1, 6)
	while true:
		Events.ui_action_pts_update.emit(action_points)
		if action_points <= 0:
			break
			
		var action: Action
		while true:
			await get_tree().process_frame
			var action_type = await PlayerInput.instance.request_action_select()

			if not Action.can_be_applied(action_type, self, tabletop):
				continue

			match action_type:
				ActionTypes.Types.MOVE_ACTION:
					var cell = await PlayerInput.instance.request_cell_select(grid_position, action_points)
					action = MoveAction.new(cell)
				ActionTypes.Types.MELEE_ATTACK_ACTION:
					var target = await PlayerInput.instance.request_enemies_select_range(grid_position, 4)
					if target == null:
						continue
					action = MeleeAttackAction.new(target)
				ActionTypes.Types.RANGED_ATTACK_ACTION:
					var target = await PlayerInput.instance.request_enemies_select_range(grid_position, -1)
					if target == null:
						continue
					action = RangedAttackAction.new(target)
				_:
					assert(false, 'ERROR: Unrecognized action type')
			break
		
		send_action.emit(action)
		await action.completed
	
	send_action.emit(null)

func _on_death():
	G.hero_died(self)