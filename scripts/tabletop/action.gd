class_name Action extends Object
## The base class for any actions performed during a [Unit]'s turn, such as 
## attacking, moving, healing, and so on...

signal completed

## The base amount to be subtracted from the [Unit]'s action points (can be 
## overriden depending on the action proccessing)
var base_cost: int

## Runs the action behavior on the following [Unit] inside the tabletop [i](MUST 
## be a coroutine)
func _apply(unit: Unit, tabletop: Tabletop) -> int:
	await unit.get_tree().create_timer(1).timeout
	return base_cost


## Checks if the given action is suitable to be applied to a unit
static func can_be_applied(action: ActionTypes.Types, unit: Unit, _tabletop: Tabletop) -> bool:
	match action:
		ActionTypes.Types.MELEE_ATTACK_ACTION:
			const COST = 2
			if unit.action_points < COST:
				return false
		ActionTypes.Types.RANGED_ATTACK_ACTION:
			const COST = 2
			if unit.action_points < COST:
				return false
	return true