class_name MoveAction extends Action
## Moves the [Unit] to some location

const MOVE_SPEED = 750.0

var dest: Vector2i

func _init(dest: Vector2i):
	self.dest = dest
	base_cost = 1

func _apply(unit: Unit, tabletop: Tabletop) -> int:
	var tween = unit.create_tween()
	var dest_pos = Vector2(dest * G.GRID_SIZE)
	var dist_grid = dest.distance_to(unit.grid_position)
	print(dist_grid)
	var dist = dest_pos.distance_to(unit.grid_position * G.GRID_SIZE) 
	unit.grid_position = dest
	await tween.tween_property(unit, 'position', dest_pos, dist / MOVE_SPEED).finished
	return base_cost * dist_grid
