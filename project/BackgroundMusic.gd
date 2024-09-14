extends AudioStreamPlayer2D

const STREAM_LOOPS_2023_11_29 = preload("res://Music/Stream Loops 2023-11-29.ogg")
const STREAM_LOOPS_2024_01_24_02 = preload("res://Music/Stream Loops 2024-01-24_02.ogg")
const STREAM_LOOPS_2024_02_28_02 = preload("res://Music/Stream Loops 2024-02-28_02.ogg")
const STREAM_LOOPS_2024_04_24_03 = preload("res://Music/Stream Loops 2024-04-24_03.ogg")

const music_list := [
	STREAM_LOOPS_2023_11_29,
	STREAM_LOOPS_2024_01_24_02,
	STREAM_LOOPS_2024_02_28_02,
	STREAM_LOOPS_2024_04_24_03
]

var music_index := 0

func _ready() -> void:
	music_index = randi_range(0, music_list.size())
	print (music_index)
	play_next_music()
	finished.connect(play_next_music)

func play_next_music():
	music_index += 1
	music_index = music_index % music_list.size()
	print (music_index)
	stream = music_list[music_index]
	play()
