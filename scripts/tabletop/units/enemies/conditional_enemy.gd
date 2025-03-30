class_name ConditionalEnemy extends Unit
## A Enemy class that runs a list of actions by order and conditions

@export var min_ap: int = 2
@export var max_ap: int = 6

## A class that defines a pair of a behavior and a condition
class ConditionalBehavior:
    var apply: Callable ## Runs the actual behavior code if [member ConditionalBehavior.condition] is true
    ## Executes a function that returns a boolean indicating if that action should be executed [br]
    ## Note that this function should [b]NOT[/b] have side effects.
    var condition: Callable 
    
    func _init(_condition: Callable, _apply: Callable) -> void:
        apply = _apply
        condition = _condition

## Creates a [class ConditionalBehavior] and adds it to the list[br]
## [param condition]: Must be a function taking [Tabletop] as a parameter and returning a [b]boolean[/b] and should [b]NOT[/b] have side effects.
## [i]NOTE: if null, will be threated as always true[br][/i]
## [param apply]: Must be a function taking [Tabletop] as a parameter, returning a integer. Note that this callable [i]may[/i] be async
func add_behavior(condition: Callable, apply: Callable):
    _behaviors.append(ConditionalBehavior.new(condition, apply))

var _behaviors: Array[ConditionalBehavior]

## Called by the tabletop and runs the unit's turn loop
func _on_turn(tabletop: Tabletop):
    action_points = randi_range(min_ap, max_ap)
    print('ACTION_POINTS: %s' % action_points)

    var could_execute_any := false

    while true:
        print("conditional turn, AP = %s" % action_points)
        if action_points <= 0:
            break

        could_execute_any = false

        for behavior in _behaviors:
            var condition_result = behavior.condition.call(tabletop) if behavior.condition != null else true
            assert(condition_result is bool, "ERROR: ConditionalBehavior condition callable MUST return a BOOLEAN value")

            if condition_result:
                await behavior.apply.call(tabletop)
                could_execute_any = true
                break
        
        if not could_execute_any:
            break
        
        



            
        



