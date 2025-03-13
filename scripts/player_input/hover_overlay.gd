class_name HoverOverlay extends Node2D
## Creates mouses overlays and other stuff when selecting a grid slot

const BASE_OVERLAY_COLOR := Color('#fafafa', 0.25)

var enabled := false
var grid_pos: Vector2i
var from_pos: Vector2i

func draw_cell(pos: Vector2i):
	draw_rect(
		Rect2(pos * G.GRID_SIZE, Vector2.ONE * G.GRID_SIZE),
		BASE_OVERLAY_COLOR
	)

func _draw() -> void:
	if !enabled: return
	
	draw_cell(grid_pos)
	
