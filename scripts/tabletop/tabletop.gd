class_name Tabletop extends Node
## The most important class of the dungeon, responsible of handling the [method game_loop]

## The two groups of the dungeon, the players and the enemies
@onready var groups: Array[Node] = [$PlayerUnits, $EnemyUnits]

func get_enemies(): return groups[1]
func get_players(): return groups[0]

func _ready() -> void:
	game_loop()

func game_loop(): ## The tabletop event loop
	while true:
		for group in groups:
			for unit in group.get_children():
				if unit is not Unit:
					push_error("ERROR: Some of the children of %s group is not an Unit" % group)
				await unit_turn(unit as Unit)

## Asynchronous coroutine for handling the [Unit]'s turn
func unit_turn(unit):
	unit._on_turn()
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
