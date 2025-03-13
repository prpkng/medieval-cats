extends Node2D

const LINE_COLOR := Color(Color.WHITE, 0.5)
const WID := 1280.0
const HEI := 720.0

func _draw() -> void:
	var grid = G.GRID_SIZE
	for x in range(0, ceil(WID/grid)):
		draw_line(Vector2(x * grid, 0), Vector2(x * grid, HEI), LINE_COLOR, 1)
	for y in range(0, ceil(HEI/grid)):
		draw_line(Vector2(0, y * grid), Vector2(WID, y * grid), LINE_COLOR, 1)
