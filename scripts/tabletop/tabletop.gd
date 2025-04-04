class_name Tabletop extends Node
## The most important class of the dungeon, responsible of handling the [method game_loop]

## The two groups of the dungeon, the players and the enemies
@onready var groups: Array[Node] = [$PlayerUnits, $EnemyUnits]

var astar: AStarGrid2D


func get_enemies() -> Array: return groups[1].get_children()
func get_players() -> Array: return groups[0].get_children()

func _ready() -> void:
	game_loop()

	astar = AStarGrid2D.new()
	astar.region = Rect2i(0, 0, 32, 32)
	astar.cell_size = Vector2.ONE * G.GRID_SIZE
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

	G.current_tabletop = self

func get_grid_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return astar.get_point_path(from, to)

func game_loop(): ## The tabletop event loop
	while true:
		for group in groups:
			for unit in group.get_children():
				if unit is not Unit:
					push_error("ERROR: Some of the children of %s group is not an Unit" % group)
				await unit_turn(unit as Unit)

## Asynchronous coroutine for handling the [Unit]'s turn
func unit_turn(unit):
	unit._on_turn(self)
	while unit.action_points > 0:
		if unit is Sprite2D: 
			# Enable unit outline
			unit.set_instance_shader_parameter('enabled', true)
		var action: Action = await unit.send_action
		if unit is Sprite2D: 
			# Disable unit outline
			unit.set_instance_shader_parameter('enabled', false)

		if action == null:
			break
		var cost = await action._apply(unit, self)
		unit.action_points -= cost
		action.completed.emit.call_deferred()
