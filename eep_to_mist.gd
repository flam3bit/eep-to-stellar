extends Node

signal opened_file(file:FileAccess)

@onready var s_name = $CanvasLayer/StarNameEdit
@onready var status = $CanvasLayer/Status




func _on_open_file_pressed() -> void:
	var open_file = FileDialog.new()
	open_file.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	
	#uses the default file dialog for your os 
	open_file.use_native_dialog = true
	open_file.access = FileDialog.ACCESS_FILESYSTEM
	open_file.show_hidden_files = true
	open_file.display_mode = FileDialog.DISPLAY_THUMBNAILS
	
	open_file.file_selected.connect(file_selected)
	add_child(open_file)
	open_file.popup_centered()

func file_selected(path:String):
	if !path.ends_with(".eep"):
		print("Invalid file type!")
		status.text = "[color=red]Invalid file type[/color]"
		status.visible = true
		return
	status.text = "[color=green]Successfully opened {0}[/color]".format([path])
	status.visible = true

	var file = FileAccess.open(path, FileAccess.READ)
	await s_name.text_submitted
	opened_file.emit(file)

func _on_open_user_folder() -> void:
	var path = ProjectSettings.globalize_path("user://")
	OS.shell_open(path)

func convert_to_csv(file: FileAccess) -> void:
	# var line_num = 0
	var path = "user://MIST_EvolutionTrack.mist"
	if Debug.star_name != "":
		path = "user://{0}.mist".format([Debug.star_name])
	status.text = "[color=green]Saving to {0}[/color]".format([path])
		
	var testfile = FileAccess.open(path, FileAccess.WRITE)
	while file.get_position() < file.get_length():
		
		var line:String = file.get_line()
		
		if !line.begins_with("#"):
			if !line.begins_with("star_age"):
				line = line.strip_escapes()
				line = line.strip_edges()
				var line_contents = line.split("        ")
				
				var stored_data = []
				var idx = -1
				for data in line_contents:
					idx += 1
					var ndata = float(data)
					
					# 6:  luminosity (7)
					# 11: teff (12)
					# 13: radius (14) 
					if (idx == 6 or idx == 11 or idx == 13):
						ndata = 10 ** ndata
					
					stored_data.append(str(ndata))
				
				if stored_data.size() == 77:
					testfile.store_csv_line(PackedStringArray(stored_data))

func _on_star_name_edit_text_changed(new_text: String) -> void:
	Debug.star_name = new_text
