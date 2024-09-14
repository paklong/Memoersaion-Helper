extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var previous_button: Button = %PreviousButton
@onready var show_hints_button: Button = %ShowHintsButton
@onready var show_answer_button: Button = %ShowAnswerButton
@onready var google_drive_file: Node2D = %GoogleDriveFile



const COLOR_LIST := [
	'GOLD',
	'ORANGE',
	'ORANGE_RED',
	'SALMON',
	'SANDY_BROWN',
	'SKY_BLUE',
	'STEEL_BLUE',
	'TAN',
	'TEAL',
	'THISTLE',
	'TOMATO',
	'TURQUOISE',
	'VIOLET',
	'WHEAT',
	'YELLOW',
]

#const NODES_JSON = "user://nodes.json"

var nodes := []

var current_item_index := 0
var current_hint_index := 0

func _ready() -> void:
	toggle_all_buttons()
	nodes = await download_data()
	next_button.pressed.connect(next_item)
	previous_button.pressed.connect(previous_item)
	show_hints_button.pressed.connect(next_hint)
	show_answer_button.pressed.connect(show_answer)
	toggle_all_buttons()
	show_item()
	
func download_data():
	var data = await google_drive_file.get_data()
	return data
	
#func load_json():
	#var file = FileAccess.open(NODES_JSON, FileAccess.READ)
	#var content = file.get_as_text()
	#var json = JSON.new()
	#nodes = json.parse_string(content)
	
#func save_json():
	#var file = FileAccess.open(NODES_JSON, FileAccess.WRITE)
	#var json_string = JSON.stringify(nodes, "\t")
	#file.store_string(json_string)

func show_item():
	current_item_index = wrapi(current_item_index, 0, nodes.size())
	rich_text_label.text = 'Items: [b]%s[/b]' % [current_item_index+1]
	
func show_hints():
	var node_hints : Array = nodes[current_item_index]['hints']
	rich_text_label.text = rich_text_label.text + '\n' + 'Hint %d: [b]%s[/b]' % [current_hint_index-1 ,node_hints[current_hint_index-1]]
	if current_hint_index == node_hints.size():
		show_hints_button.disabled = true

func show_all_hints():
	var node_hints : Array = nodes[current_item_index]['hints']
	for i in range(node_hints.size()):
		rich_text_label.text = rich_text_label.text + '\n' + 'Hint %d: [b]%s[/b]' % [i ,node_hints[i]]
	show_hints_button.disabled = true

func show_all():
	rich_text_label.text = ""
	show_item()
	show_all_hints()
	show_answer()

func show_answer():
	var node_name : String = nodes[current_item_index]['name']
	var color_index = current_item_index % COLOR_LIST.size()
	print (color_index)
	rich_text_label.text = rich_text_label.text + '\n\n' + '[color=%s][font_size=20][b]%s[/b][/font_size][/color]' % [COLOR_LIST[color_index], node_name]
	show_answer_button.disabled = true
	
func next_item():
	if show_hints_button.disabled == false or show_answer_button.disabled == false:
		show_all()
	else:
		current_item_index += 1 
		current_hint_index = 0
		show_hints_button.disabled = false
		show_answer_button.disabled = false
		show_item()

func previous_item():
	current_item_index -= 1
	current_hint_index = 0
	show_hints_button.disabled = false
	show_answer_button.disabled = false
	show_item()
	
func next_hint():
	current_hint_index += 1
	show_hints()
	
func toggle_all_buttons():
	next_button.visible = !next_button.visible
	previous_button.visible  = !previous_button.visible
	show_hints_button.visible  = !show_hints_button.visible
	show_answer_button.visible  = !show_answer_button.visible
