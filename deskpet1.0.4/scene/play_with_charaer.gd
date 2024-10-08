extends Node2D

@onready var animation_player: AnimationPlayer = $Portrait/AnimationPlayer
@onready var character = get_node("Portrait")
@onready var pp = get_node("Portrait/dialog_box")
@onready var pp_text = get_node("Portrait/dialog_box/Label")
@onready var input_lab = get_node("play_text")

var content = [] #介绍游戏规则
var num = "" #玩家输入的数字
var my_num = 0 #桌宠的数字
var n = 1 #猜的次数
var game_state = 0 #游戏开始的状态


func _ready() :
	content = ["让我们进行猜数字的小游戏吧。",
	"我心里想的数字范围在1—100之间",
	"看看你多少次猜中啊。",
	"通过键盘输入你的答案吧！"
	]
	pp.hide()
	input_lab.hide()
	game_state = 1
	character.position = Vector2(-112,224) #入场前的位置
	var tween = get_tree().create_tween() #tween动画
	tween.tween_property(character,"position",Vector2(154,215),1.0).set_ease(Tween.EASE_IN_OUT) #入场后的位置
	tween.connect("finished",play_ani) #播放待机玩耍动画
	my_num =randi_range(1, 100)


func play_ani():
	animation_player.play("idle_play")
	pp.show()
	pp_text.text = content[0]
	await get_tree().create_timer(2).timeout #延迟2秒
	pp_text.text = content[1]
	await get_tree().create_timer(2).timeout
	pp_text.text = content[2]
	await get_tree().create_timer(2).timeout
	pp_text.text = content[3]
	await get_tree().create_timer(2).timeout
	pp.hide()
	input_lab.show()
	game_state = 0 


func _input(event):
	if event is InputEventKey: 
		if event.pressed and game_state == 0: #检测键盘按键且游戏状态为0
			if event.keycode >= KEY_0 and event.keycode <= KEY_9 : #检测数字
				num += str(event.keycode - 48)
				input_lab.text = "第" + str(n) + "次：" + num
				pp.hide()
			if event.keycode == KEY_ENTER:
				if int(num) == my_num:
					pp_text.text="恭喜你，猜对了！"
					pp.show()
					game_state = 1
				elif int(num) >my_num:
					pp_text.text = "猜大了，再猜一次"
					num = "" #清空数字
					input_lab.text = num
					n += 1
					pp.show()
				else :
					pp_text.text = "猜小了，再猜一次"
					num = ""
					input_lab.text = num
					n += 1
					pp.show()


func _on_game_over_pressed() -> void: #退出游戏
	get_tree().change_scene_to_file("res://scene/main_window.tscn")
	


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT:#判断鼠标移动
			get_tree().root.position += Vector2i(event.relative)
