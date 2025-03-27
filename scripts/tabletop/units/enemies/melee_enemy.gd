extends Unit


func sort_by_distance(a: Unit, b: Unit):
	return grid_position.distance_to(a.grid_position) < grid_position.distance_to(b.grid_position)

## Called by the tabletop and runs the unit's turn loop
func _on_turn(tabletop: Tabletop):
	action_points = 4

	var players = tabletop.get_players()
	players.sort_custom(sort_by_distance)

	var target = players[0]

	var path = tabletop.get_grid_path(grid_position, target.grid_position)
	if path.size() > action_points:
		path.resize(action_points)

	print(target)
	var dest = path[path.size()-1] / G.GRID_SIZE
	print(dest)
	await get_tree().process_frame

	var action = MoveAction.new(dest)
	send_action.emit(action)
	
	await action.completed
	
	send_action.emit(null)
