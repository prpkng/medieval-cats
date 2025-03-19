class_name MoveAction extends Action
## Moves the [Unit] to some location

var dest: Vector2i

func _init(destination: Vector2i):
	self.dest = destination
	base_cost = 1

func _apply(unit: Unit, tabletop: Tabletop) -> int:
	var points = tabletop.get_grid_path(unit.grid_position, dest)
	points.remove_at(0)

	var dist_grid = points.size()
	print('grid distance: %s' % dist_grid)
	unit.grid_position = dest

	var tween = unit.create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	
	for point in points:
		tween.tween_property(unit, 'position', point, 0.2)
		tween.tween_interval(0.05)
	await tween.finished
	
	return base_cost * dist_grid
