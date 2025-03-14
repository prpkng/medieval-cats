extends Label


func _ready() -> void:
	Events.ui_action_pts_update.connect(set_points)
	
func set_points(points: int):
	text = "%s AP" % points
