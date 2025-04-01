class_name ActionButton extends Button
## A button that triggers a unit action on the parent ActionSelect

signal action_selected(action: ActionTypes.Types)

@export var action: ActionTypes.Types


func _ready() -> void:
	pressed.connect(action_selected.emit.bind(action))
