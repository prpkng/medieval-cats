extends Control



func _ready() -> void:
	Events.ui_action_select_requested.connect(select_requested)
	visible = false
	for c in get_children():
		if c is ActionButton:
			c.action_selected.connect(action_selected)

func action_selected(action: ActionTypes.Types):
	Events.ui_action_select_performed.emit(action)
	visible = false

func select_requested():
	print('req')
	visible = true
