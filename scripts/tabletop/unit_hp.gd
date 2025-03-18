extends Label

@onready var parent = get_parent() as Unit

func _process(delta: float) -> void:
	text = '%s | 10 HP' % parent.health_points
