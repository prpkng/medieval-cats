class_name PlayerInput extends Node
## This class is globally used to request the player to input for the current unit's actions

signal cell_clicked(cell: Vector2i)

## Singleton instance
static var instance: PlayerInput

@onready var hover_overlay: HoverOverlay = $'Hover Overlay'

var hover_requested := false
var hover_max_cost := 0

var _hover_overlay_last_position: Vector2i
var _hover_grid_from: Vector2i

func _ready() -> void:
	instance = self
	hover_overlay.player_input = self

func _process(delta: float) -> void:
	
	# Hover overlay
	if hover_requested:
		var mouse_pos = hover_overlay.get_global_mouse_position()
		var grid_pos = Vector2i(mouse_pos / G.GRID_SIZE)
		# If dirty
		if grid_pos != _hover_overlay_last_position:
			
			hover_overlay.enabled = true
			hover_overlay.grid_pos = grid_pos
			hover_overlay.from_pos = _hover_grid_from
			hover_overlay.queue_redraw()
		_hover_overlay_last_position = grid_pos
	else:
		if hover_overlay.enabled:
			hover_overlay.enabled = false
			hover_overlay.queue_redraw()

func _input(event: InputEvent) -> void:
	if hover_requested and event is InputEventMouse and event.is_pressed():
		var cell = Vector2i(event.position / G.GRID_SIZE)
		cell_clicked.emit(cell)

func request_action_select() -> ActionTypes.Types:
	print("requested")
	Events.ui_action_select_requested.emit()
	
	var action = await Events.ui_action_select_performed
	return action

func request_cell_select(from: Vector2i, max_cost := 3) -> Vector2i:
	_hover_grid_from = from
	hover_requested = true
	hover_max_cost = max_cost+1
	var cell: Vector2i
	while true:
		cell = await cell_clicked
		print(from.distance_to(cell))
		if from.distance_to(cell) <= max_cost:
			break
	hover_requested = false
	
	return cell
