class_name AttackAction extends Action
## Moves the [Unit] to some location

var target: Unit

func _init(target: Unit):
	self.target = target
	base_cost = 2

# TODO: Attack units instead of cells

func _apply(unit: Unit, _tabletop: Tabletop) -> int:
	var start_pos = unit.grid_position
	var dest_pos = Vector2(target.global_position)
	unit.grid_position = target.grid_position
	await unit.create_tween().tween_property(unit, 'position', dest_pos, 0.3).finished
	await unit.get_tree().create_timer(0.5).timeout
	target._apply_damage(2)

	unit.grid_position = start_pos
	await unit.create_tween().tween_property(unit, 'position', Vector2(start_pos * G.GRID_SIZE), 0.3).finished
	return base_cost
