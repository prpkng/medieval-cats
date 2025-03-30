extends ConditionalEnemy

const ATTACK_RANGE := 4

func _init() -> void:
	add_behavior(can_attack, attack_behavior)
	add_behavior(func(_tabletop): return true, move_behavior)

func get_target_player(tabletop: Tabletop) -> Unit:
	var players = tabletop.get_players()
	players.sort_custom(sort_by_distance)

	return players[0]

func sort_by_distance(a: Unit, b: Unit):
	return grid_position.distance_to(a.grid_position) < grid_position.distance_to(b.grid_position)

func can_attack(tabletop: Tabletop):
	var player = get_target_player(tabletop)
	return player.grid_position.distance_to(grid_position) <= ATTACK_RANGE

func attack_behavior(tabletop: Tabletop):
	print("Will Attack")
	var target = get_target_player(tabletop)
	
	await get_tree().process_frame
	
	var action = AttackAction.new(target)
	send_action.emit(action)

	await action.completed


func move_behavior(tabletop: Tabletop):
	var target = get_target_player(tabletop)

	var path = tabletop.get_grid_path(grid_position, target.grid_position)
	if path.size() > action_points+1:
		path.resize(action_points+1)

	print(target)
	var dest = path[path.size() - 1] / G.GRID_SIZE
	print(dest)
	await get_tree().process_frame

	var action = MoveAction.new(dest)
	send_action.emit(action)
	
	await action.completed
