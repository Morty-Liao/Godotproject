extends Control

@onready var music: AudioStreamPlayer = $music
@onready var menu = $"."

func _on_option_button_item_selected(index): #选择音乐
	match index:
		0:pass
		1:_QQmusic()
		2:_163music()
		3:music.play()
	menu.hide()


func _on_exit_pressed() -> void: #退出桌宠
	get_tree().quit()


func _on_music_pause_pressed(): #暂停音乐
	#music.stop()
	music.set_stream_paused(true)
	menu.hide()


func _on_play_pressed() -> void: #进入游戏
	get_tree().change_scene_to_file("res://scene/play_with_charaer.tscn")


func _QQmusic():
	OS.shell_open("https://y.qq.com/")
	music.stop()


func _163music():
	OS.shell_open("https://music.163.com/")
	music.stop()


func _on_ks_pressed():
	music.set_stream_paused(false)
	menu.hide()
