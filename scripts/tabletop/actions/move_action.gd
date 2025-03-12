class_name MoveAction extends Action
## Moves the [Unit] to some location



var dest: Vector2i

func _init(dest: Vector2i):
	self.dest = dest
	base_cost = 1

func _apply(unit: Unit, tabletop: Tabletop) -> int:
	var tween = unit.create_tween()
	var dest_pos = Vector2(dest * G.GRID_SIZE)
	unit.grid_position = dest
	await tween.tween_property(unit, 'position', dest_pos, 1).finished
	return base_cost
