extends ConditionalEnemy

const ATTACK_RANGE := 4

var attack_multiple_times := true

func _init() -> void:
	add_behavior(can_attack, attack_behavior)
	add_behavior(should_move, move_behavior)

## Sort a array by distance
func sort_by_distance(a: Unit, b: Unit):
	return grid_position.distance_to(a.grid_position) < grid_position.distance_to(b.grid_position)

## Seeks the tabletop and find the nearest HERO to this unit
func get_target_player(tabletop: Tabletop) -> Unit:
	var players = tabletop.get_players()
	players.sort_custom(sort_by_distance)

	return players[0]

# ATTACK

## Checks if this unit is able to attack the targeted player
func can_attack(tabletop: Tabletop):
	var player = get_target_player(tabletop)
	return floori(player.grid_position.distance_to(grid_position)) <= ATTACK_RANGE && action_points >= 2

func attack_behavior(tabletop: Tabletop):
	var target = get_target_player(tabletop)
	
	await get_tree().process_frame
	
	var action = MeleeAttackAction.new(target)
	send_action.emit(action)

	await action.completed

	# If the target is dead, stop the execution and don't continue attacking
	if target == null:
		halt_execution()

# MOVE

## Checks if this unit needs to move towards the targeted player
func should_move(tabletop: Tabletop):
	var player = get_target_player(tabletop)
	return floori(player.grid_position.distance_to(grid_position)) > ATTACK_RANGE

func move_behavior(tabletop: Tabletop):
	var target = get_target_player(tabletop)

	var path = Array(tabletop.get_grid_path(grid_position, target.grid_position))
	if path.size() > action_points+1:
		path.resize(action_points+1)
	
	var dest: Vector2i = Vector2i.ZERO
	path.reverse()
	for p in path:
		var g = Vector2i(p / G.GRID_SIZE)
		if g.distance_to(target.grid_position) > ATTACK_RANGE:
			dest = g
			break
	
	if dest == grid_position:
		push_error("ERROR: grid pos is same as dest")
		return

	if dest == Vector2i.ZERO:
		push_error("ERROR: dest is zero")


	await get_tree().process_frame

	var action = MoveAction.new(dest)
	send_action.emit(action)
	
	await action.completed
