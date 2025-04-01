class_name RangedAttackAction extends Action
## Moves the [Unit] to some location

var target: Unit
const arrow_scene = preload('res://nodes/enemies/enemy_arrow.tscn')

func _init(target: Unit):
	self.target = target
	base_cost = 2

# TODO: Attack units instead of cells

func _apply(unit: Unit, _tabletop: Tabletop) -> int:

	var arrow = arrow_scene.instantiate()
	unit.get_tree().root.add_child(arrow)
	arrow.global_position = unit.global_position
	
	var dir = (target.global_position - unit.global_position).normalized()
	arrow.global_rotation = atan2(dir.y, dir.x)

	await unit.create_tween().tween_property(arrow, 'global_position', target.global_position, 0.2).finished
	arrow.queue_free()

	target._apply_damage(1)

	return base_cost
