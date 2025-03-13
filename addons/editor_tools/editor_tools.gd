@tool
extends EditorPlugin

const ACTIONS_ENUM_TEMPLATE_PATH := 'res://addons/editor_tools/actions_enum_template.gd.template'


func _enter_tree() -> void:
	add_tool_menu_item('Regenerate actions enum', regenerate_actions_enum)

func get_all_files(path: String) -> Array[String]:
	var dir = DirAccess.open(path)
	var files: Array[String] = []
	
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	
	while file_name != '':
		if dir.current_is_dir():
			files.append_array(get_all_files(dir.get_current_dir()))
		else:
			if file_name.get_extension() != 'gd':
				file_name = dir.get_next()
				continue
			files.append(file_name)
		
		file_name = dir.get_next()
		
	
	return files

func regenerate_actions_enum():
	var template = FileAccess.open(ACTIONS_ENUM_TEMPLATE_PATH, FileAccess.READ).get_as_text()
	var files = get_all_files('res://scripts/tabletop/actions')
	
	var action_types: Array[String] = []
	
	var i = 0
	for file in files:
		action_types.push_back(file.get_basename().to_snake_case().to_upper() + ' = %s' % i)
		i += 1
	
	var script_file = template % ',\n\t'.join(action_types)
	var script = GDScript.new()
	script.source_code = script_file
	ResourceSaver.save(script, 'res://scripts/tabletop/action_types.gd')
	print_rich("[wave][color=cornflower_blue]INFO:[/color][/wave] Regenerated 'action_types.gd' script")
	
	
func _exit_tree() -> void:
	remove_tool_menu_item('Regenerate actions enum')
