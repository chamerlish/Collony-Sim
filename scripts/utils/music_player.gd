extends Node2D

@export var music_queue: Array[OstResource]

@onready var intro_player: AudioStreamPlayer = $OstIntro
@onready var loop_player: AudioStreamPlayer = $OstLoop

var current_playing: OstResource
var current_max_loop: int

var played_loops: int = 0

func pick_random_song() -> void:
	current_playing = music_queue.pick_random()
	
	intro_player.stream = current_playing.intro_track
	loop_player.stream = current_playing.loop_track
	
	intro_player.play()
	
	# LOOPS
	current_max_loop = current_playing.max_loop
	played_loops = 0

func _ready() -> void:
	pick_random_song()

func _on_ost_intro_finished() -> void:
	loop_player.play()


func _on_ost_loop_finished() -> void:
	loop_player.play()
	played_loops += 1
	
	if 0 < current_max_loop and played_loops >= current_max_loop:
		_music_fade_out()

func _music_fade_out():
	var tween = create_tween()
	tween.tween_property(loop_player, "volume_linear", 0, 13)
	tween.tween_callback(pick_random_song)
