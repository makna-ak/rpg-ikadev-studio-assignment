extends Control

@onready var option = $MarginContainer/Panel/OptionButton
@onready var jobname = $MarginContainer/Panel/VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var description = $MarginContainer/Panel/VBoxContainer/HBoxContainer/VBoxContainer/Description
@onready var skills = $MarginContainer/Panel/VBoxContainer/Label/Skills
@onready var ava = $MarginContainer/Panel/VBoxContainer/HBoxContainer/NinePatchRect/Ava
@onready var data = {}

func _ready():
	await _load_csv()
	select()
	_on_option_button_item_selected(0)

func _load_csv():
	var file = FileAccess.open("res://resource/class.csv", FileAccess.READ)
	if file == null:
		printerr("Could not load example.csv: %s" % error_string(FileAccess.get_open_error()))
		return
	print("begin processing csv data")
	
	var header = file.get_line()
	
	while !file.eof_reached():
		var csv_data := file.get_csv_line()
		if csv_data.size() == 4 && !csv_data.is_empty():
			data[int(csv_data[0])] = {
				#"id": csv_data[0],
				"name": csv_data[1],
				"description": csv_data[2],
				"skills": csv_data[3].split(";")
			}

func select():
	for i in data:
		option.add_item(data[i].get("name"), int(i))

func _on_option_button_item_selected(index):
	var id = option.get_item_id(index)
	jobname.text = option.get_item_text(index)
	ava.texture = load("res://assets/characters/%s.tres" % jobname.text)
	description.text = data[id].get("description")
	
	for child in skills.get_children():
		child.queue_free()

	for i in data[id].get("skills"):
		var skill = Label.new()
		skill.add_theme_color_override("font_color", "b4a794")
		skill.text = i
		skills.add_child(skill)
