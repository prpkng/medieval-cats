class_name HoverOverlay extends Node2D
## Creates mouses overlays and other stuff when selecting a grid slot

const FONT = preload('res://monogram.ttf')

const BASE_OVERLAY_COLOR := Color('#fafafa', 0.25)
const INVALID_OVERLAY_COLOR := Color('#fa0f0f', 0.15)
const POSSIBLE_GRID_COLOR := Color('#0f0ffa', 0.075)

enum Modes {
	DISABLED,
	MOVE_OVERLAY,
	ATTACK_OVERLAY
}

var mode := Modes.DISABLED
var player_input: PlayerInput

var grid_pos: Vector2i
var from_pos: Vector2i

var attack_range: int

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

func draw_range(_range: int, color: Color):
	for i in range(_range):
		# Top pyramid
		var y = from_pos.y - (_range - i) + 1
		var count = i
		draw_rect(
			Rect2(
				Vector2(from_pos.x - count, y) * G.GRID_SIZE,
				Vector2(count * 2 + 1, 1) * G.GRID_SIZE
			),
			color
		)

		if i == _range - 1: continue

		# Bottom pyramid
		y = from_pos.y + (_range - i) - 1
		count = i
		draw_rect(
			Rect2(
				Vector2(from_pos.x - count, y) * G.GRID_SIZE,
				Vector2(count * 2 + 1, 1) * G.GRID_SIZE
			),
			color
		)

func draw_move() -> void:
	var max_cost = player_input.hover_max_cost
	
	# Compute possibilities
	draw_range(max_cost, POSSIBLE_GRID_COLOR)


	# Draw line
	var pts = player_input.tabletop.get_grid_path(Vector2i(from_pos.x, from_pos.y), Vector2i(grid_pos.x, grid_pos.y))


	if pts.size() <= max_cost:
		for pt in pts:
			draw_rect(
				Rect2(pt, Vector2.ONE * G.GRID_SIZE),
				BASE_OVERLAY_COLOR
			)
		draw_cell(grid_pos, BASE_OVERLAY_COLOR)
	else:
		draw_cell(grid_pos, INVALID_OVERLAY_COLOR)
		
	pts.remove_at(0)
	
	var median_point = lerp(
		Vector2(from_pos * G.GRID_SIZE),
		Vector2(grid_pos * G.GRID_SIZE) + Vector2.UP * 8,
		0.5
	)
	
	draw_string(FONT, median_point, 'Cost: %s' % pts.size(), 0, -1, 32)

func draw_attack():
	draw_range(attack_range, INVALID_OVERLAY_COLOR)

func _draw() -> void:
	if !player_input: return

	match mode:
		Modes.DISABLED:
			return
		Modes.MOVE_OVERLAY:
			draw_move()
		Modes.ATTACK_OVERLAY:
			draw_attack()
	
	