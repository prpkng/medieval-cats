extends Label

@onready var parent = get_parent() as Unit

func _process(_delta: float) -> void:
	text = '%s ACTION PTS\n%s | 10 HP' % [parent.action_points, parent.health_points]
