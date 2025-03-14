extends Node
## Wrapper of all signals that can't be connected directly

signal ui_action_select_requested
signal ui_action_select_performed(action: ActionTypes.Types)

signal ui_action_pts_update(points: int)
