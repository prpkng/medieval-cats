class_name AttackAction extends Action
## Moves the [Unit] to some location

var dest: Vector2i

func _init(dest: Vector2i):
	self.dest = dest
	base_cost = 2

func _apply(unit: Unit, tabletop: Tabletop) -> int:
	var start_pos = unit.grid_position
	var dest_pos = Vector2(dest * G.GRID_SIZE)
	unit.grid_position = dest
	await unit.create_tween().tween_property(unit, 'position', dest_pos, 0.3).finished
	await unit.get_tree().create_timer(0.5).timeout
	unit.grid_position = start_pos
	await unit.create_tween().tween_property(unit, 'position', Vector2(start_pos * G.GRID_SIZE), 0.3).finished
	return base_cost
