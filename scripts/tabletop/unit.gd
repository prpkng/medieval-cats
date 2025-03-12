class_name Unit extends Node2D
## The base class of all units on the game

## Sends an action up to the tabletop when executing this unit's turn, send a 
## NULL action value to finish the turn
signal send_action(action: Action)


## This dictates the number of actions that this unit can perform on its turn
var action_points = 6
## The unit's HP
var health_points = 10

var grid_position: Vector2i

## Called by the tabletop and runs the unit's turn loop
func _on_turn():
	pass

## Applies the given damage to the unit, override this to apply custom behavior
## like defense and vulnerability
func _apply_damage(points: int):
	health_points -= points
