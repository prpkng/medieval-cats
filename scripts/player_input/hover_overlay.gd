class_name HoverOverlay extends Node2D
## Creates mouses overlays and other stuff when selecting a grid slot

const BASE_OVERLAY_COLOR := Color('#fafafa', 0.25)
const INVALID_OVERLAY_COLOR := Color('#fa0f0f', 0.15)
const POSSIBLE_GRID_COLOR := Color('#0f0ffa', 0.075)

var enabled := false
var player_input: PlayerInput
var grid_pos: Vector2i
var from_pos: Vector2i


func interpolated_line(p0, p1):
	var points = []
	var dx = p1[0] - p0[0]
	var dy = p1[1] - p0[1]
	var N = max(abs(dx), abs(dy))
	for i in N + 1:
		var t = float(i) / float(N)
		var point = [round(lerp(p0[0], p1[0], t)), round(lerp(p0[1], p1[1], t))]
		points.append(point)
	return points


func draw_cell(pos: Vector2i, clr: Color):
	draw_rect(
		Rect2(pos * G.GRID_SIZE, Vector2.ONE * G.GRID_SIZE),
		clr
	)

func _draw() -> void:
	if !enabled or !player_input: return
	
	
	var max_cost = player_input.hover_max_cost-1
	
	# Compute possibilities
	var min_cell = from_pos - Vector2i(max_cost-1, max_cost-1)
	
	draw_rect(
		Rect2(min_cell * G.GRID_SIZE, G.GRID_SIZE * (max_cost * 2 - 1) * Vector2.ONE),
		POSSIBLE_GRID_COLOR
	)
	
	# Draw line
	var pts = interpolated_line([from_pos.x, from_pos.y], [grid_pos.x, grid_pos.y])
	if pts.size() <= max_cost:
		for pt in pts:
			draw_cell(Vector2i(pt[0], pt[1]), BASE_OVERLAY_COLOR)
		draw_cell(grid_pos, BASE_OVERLAY_COLOR)
	else:
		draw_cell(grid_pos, INVALID_OVERLAY_COLOR)
	
