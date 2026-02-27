class_name SoundController
extends Node3D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var regular_music_player_2d: AudioStreamPlayer2D = $RegularMusicPlayer2D
@onready var boss_music_player_2d: AudioStreamPlayer2D = $BossMusicPlayer2D


func _ready() -> void:
	audio_stream_player_2d.play()
	regular_music_player_2d.play()
	Global.connect("game_state_changed", OnGameStateChanged)
	OnGameStateChanged(Global.game_state)

func OnGameStateChanged(state: Global.GAME_STATE):
	match state:
		Global.GAME_STATE.CINEMATIC:
			if Global.cinematic_state == Global.CINEMATIC_STATE.BOSS:
				boss_music_player_2d.play()
				regular_music_player_2d.stop()
			elif regular_music_player_2d.playing == false:
				boss_music_player_2d.stop()
				regular_music_player_2d.play()
