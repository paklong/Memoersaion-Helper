extends Node2D

signal request_array_populated

@onready var http_request: HTTPRequest = %HTTPRequest

const FILE_ID := "1ZdMYf96RKyex2dvO_KZ5rimkiJeNpjAO"
const API_KEY := "AIzaSyCDpkwBgtch43YsY7RNqqq1OQt8GAx3f-8"
var request := "https://www.googleapis.com/drive/v3/files/%s?key=%s&alt=media" % [FILE_ID, API_KEY]

var my_array := []

func _ready():
	http_request.request_completed.connect(_http_request_completed)
	#my_array = await get_data()
	#print (my_array)

func _http_request_completed(result, response_code, headers, body):
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response : Array = json.get_data()
	if response:
		my_array = response
		request_array_populated.emit()
	else:
		push_error("An error occurred in the JSON parser.")
	
func get_data():
	var error := http_request.request(request)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		
	await request_array_populated
	return my_array
