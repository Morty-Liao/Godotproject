extends Label

class_name  chatText
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _play_chat() ->void:
	animation_player.play("ChatSpeaking")
	timer.start()


func _on_timer_timeout() -> void:
	visible_ratio = 0
	game_Manager.text_showing = false 
