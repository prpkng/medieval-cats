extends Label

@onready var parent = get_parent() as Unit

func _process(delta: float) -> void:
	text = '%s | 10' % parent.health_points
