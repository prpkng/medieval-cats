extends Control



func _ready() -> void:
	Events.ui_unit_select_requested.connect(select_requested)

func unit_selected(unit: Unit):
	Events.ui_unit_select_performed.emit(unit)
	for c in get_children(): 
		c.queue_free()
	
func select_requested(units: Array):
	print(units)
	
	var i = 0
	for unit in units:
		create_button(unit, "Unit %s" % i)
		i += 1

func create_button(unit: Unit, _name: String):
	var btn =  Button.new()
	add_child(btn)
	btn.global_position = unit.global_position
	btn.text = _name
	btn.button_up.connect(unit_selected.bind(unit))
